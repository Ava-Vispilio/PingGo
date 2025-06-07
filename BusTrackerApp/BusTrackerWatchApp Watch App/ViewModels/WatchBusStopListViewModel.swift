//
//  WatchBusStopListViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 4/6/25.
//

import Foundation

@MainActor
class WatchBusStopListViewModel: ObservableObject {
    @Published var stops: [BusStop] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiClient: BusAPIClient

    init(apiClient: BusAPIClient = .shared) {
        self.apiClient = apiClient
    }

    func fetchStops(for line: BusRouteColor) async {
        isLoading = true
        errorMessage = nil
        print("[Watch] Fetching stops for line: \(line.rawValue)")

        do {
            self.stops = try await apiClient.fetchStops(for: line)
            print("[Watch] Received \(stops.count) stops for \(line.rawValue)")
        } catch {
            self.errorMessage = "Failed to load stops."
            print("[Watch] Error fetching stops for \(line.rawValue): \(error.localizedDescription)")
        }

        isLoading = false
    }
}
