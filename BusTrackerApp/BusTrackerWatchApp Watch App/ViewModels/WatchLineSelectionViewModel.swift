//
//  WatchLineSelectionViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 4/6/25.
//

import Foundation

@MainActor
class WatchLineSelectionViewModel: ObservableObject {
    @Published var activeLines: [BusRouteColor] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiClient: BusAPIClient

    init(apiClient: BusAPIClient = .shared) {
        self.apiClient = apiClient
    }

    func fetchActiveLines() async {
        isLoading = true
        errorMessage = nil
        activeLines = []

        let allLines = BusRouteColor.allCases
        var foundLines: [BusRouteColor] = []

        await withTaskGroup(of: (BusRouteColor, Bool).self) { group in
            for color in allLines {
                group.addTask {
                    do {
                        print("[Watch] Fetching line info for: \(color.rawValue)")
                        let response = try await self.apiClient.fetchBusLineInfo(for: color)
                        
                        let isActive = !response.bus.vehicles.isEmpty
                        print("[Watch] Received \(response.bus.name) for \(color.rawValue): \(isActive ? "active" : "inactive")")

                        return (color, isActive)
                    } catch {
                        print("[Watch] Error fetching \(color.rawValue): \(error.localizedDescription)")
                        return (color, false)
                    }
                }
            }

            for await (color, isActive) in group {
                if isActive {
                    foundLines.append(color)
                }
            }
        }

        self.activeLines = foundLines.sorted { $0.rawValue < $1.rawValue }
        print("[Watch] Final active lines: \(activeLines.map { $0.rawValue })")
        isLoading = false
    }
}
