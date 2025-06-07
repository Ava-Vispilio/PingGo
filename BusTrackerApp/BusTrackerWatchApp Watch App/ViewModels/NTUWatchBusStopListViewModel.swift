//
//  WatchBusStopListViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 4/6/25.
//

import Foundation

@MainActor
class NTUWatchBusStopListViewModel: ObservableObject {
    @Published var stops: [NTUBusStop] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiClient: NTUBusAPIClient

    init(apiClient: NTUBusAPIClient = .shared) {
        self.apiClient = apiClient
    }

    func fetchStops(for line: BusRouteColor) async {
        isLoading = true
        errorMessage = nil
        print("[Watch] Fetching stops for NTU line: \(line.rawValue)")

        do {
            self.stops = try await apiClient.fetchStops(for: line)
            print("[Watch] Received \(stops.count) stops for NTU \(line.rawValue)")
        } catch {
            self.errorMessage = "Failed to load stops."
            print("[Watch] Error fetching stops for NTU \(line.rawValue): \(error.localizedDescription)")
        }

        isLoading = false
    }
}
