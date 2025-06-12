//
//  NUSActiveBusLineListViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Manages the list of active public bus lines in NUS

import Foundation

@MainActor
class NUSActiveBusLineListViewModel: ObservableObject {
    @Published var availableBusLines: [PublicBusLine] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let service = ArriveLahService()

    func loadAvailableLines() async {
        isLoading = true
        errorMessage = nil

        guard let url = Bundle.main.url(forResource: "NUSPublicBusStopList", withExtension: "json") else {
            errorMessage = "Missing NUSPublicBusStopList.json"
            isLoading = false
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let rawDictionary = try JSONDecoder().decode([String: [PublicBusStop]].self, from: data)

            let allLines: [PublicBusLine] = rawDictionary.map { key, stops in
                PublicBusLine(lineName: key.replacingOccurrences(of: "Bus", with: ""), stops: stops)
            }

            var filteredLines: [PublicBusLine] = []

            await withTaskGroup(of: (PublicBusLine, Bool).self) { group in
                for line in allLines {
                    guard let firstStopCode = line.stops.first?.BusStopCode else { continue }

                    group.addTask {
                        do {
                            let response: ServicesWrapper = try await self.service.fetchArrivals(for: firstStopCode, as: ServicesWrapper.self)
                            let isActive = !response.services.isEmpty
                            print("NUS public line \(line.lineName) is \(isActive ? "active" : "inactive")")
                            return (line, isActive)
                        } catch {
                            print("Error fetching arrivals for NUS LTA line \(line.lineName): \(error)")
                            return (line, false)
                        }
                    }
                }

                for await (line, isActive) in group {
                    if isActive {
                        filteredLines.append(line)
                    }
                }
            }

            availableBusLines = filteredLines.sorted { $0.lineName < $1.lineName }

        } catch {
            errorMessage = "Failed to load or parse NUS bus stop data: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
