//
//  NTUActiveBusLinesViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 24/6/25.
//
// Fetches & decodes bus stops for NTU's internal & public bus lines

import Foundation

@MainActor
class NTUActiveBusLinesViewModel: ObservableObject {
    @Published var internalActiveLines: [BusRouteColor] = []
    @Published var publicActiveLines: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let apiClient: NTUBusAPIClient
    private let arriveLahService = ArriveLahService()

    init(apiClient: NTUBusAPIClient = .shared) {
        self.apiClient = apiClient
    }

    func fetchActiveLines() async {
        isLoading = true
        errorMessage = nil

        async let internalTask = fetchActiveInternalLines()
        async let publicTask = fetchActivePublicLines()

        self.internalActiveLines = await internalTask
        self.publicActiveLines = await publicTask

        print("Final active NTU internal lines: \(internalActiveLines.map { $0.rawValue })")
        print("Final active NTU public lines: \(publicActiveLines)")

        isLoading = false
    }

    private func fetchActiveInternalLines() async -> [BusRouteColor] {
        let allLines = BusRouteColor.allCases
        var foundActiveLines: [BusRouteColor] = []

        await withTaskGroup(of: (BusRouteColor, Bool).self) { group in
            for color in allLines {
                group.addTask {
                    do {
                        print("Fetching NTU internal line: \(color.rawValue)")
                        let response = try await self.apiClient.fetchBusLineInfo(for: color)
                        let isActive = !response.bus.vehicles.isEmpty
                        print("Internal \(response.bus.name): \(isActive ? "active" : "inactive")")
                        return (color, isActive)
                    } catch {
                        print("Error fetching NTU internal line \(color.rawValue): \(error.localizedDescription)")
                        return (color, false)
                    }
                }
            }

            for await (color, isActive) in group {
                if isActive {
                    foundActiveLines.append(color)
                }
            }
        }

        return foundActiveLines.sorted { $0.rawValue < $1.rawValue }
    }

    private func fetchActivePublicLines() async -> [String] {
        do {
            guard let url = Bundle.main.url(forResource: "NTUPublicBusStopList", withExtension: "json") else {
                print("NTUPublicBusStopList.json not found in bundle")
                return []
            }

            let data = try Data(contentsOf: url)
            let stopList = try JSONDecoder().decode([String: [PublicBusStop]].self, from: data)
            var activeLines: Set<String> = []

            await withTaskGroup(of: (String, Bool).self) { group in
                for (line, stops) in stopList {
                    guard let firstStop = stops.first else { continue }

                    group.addTask {
                        do {
                            let wrapper = try await self.arriveLahService.fetchArrivals(for: firstStop.BusStopCode, as: ServicesWrapper.self)
                            let isActive = !wrapper.services.isEmpty
                            print("Public line \(line): \(isActive ? "active" : "inactive")")
                            return (line, isActive)
                        } catch {
                            print("Error fetching public line \(line): \(error.localizedDescription)")
                            return (line, false)
                        }
                    }
                }

                for await (line, isActive) in group {
                    if isActive {
                        activeLines.insert(line)
                    }
                }
            }

            return Array(activeLines).sorted()
        } catch {
            print("Error decoding NTU public bus stop list: \(error.localizedDescription)")
            return []
        }
    }
}
