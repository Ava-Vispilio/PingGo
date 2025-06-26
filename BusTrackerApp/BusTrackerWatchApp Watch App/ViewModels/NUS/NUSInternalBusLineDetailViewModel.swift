//
//  NUSInternalBusLineDetailViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 23/6/25.
//
// Loads data for a selected NUS internal bus route (fetching its currently active buses and the list of stops associated with the route) from a local JSON file

import Foundation

@MainActor
class NUSInternalBusLineDetailViewModel: ObservableObject {
    @Published var isLoadingBus = false
    @Published var isLoadingStops = false
    @Published var errorMessage: String?
    @Published var stops: [NUSInternalBusStop] = []
    @Published var bus: NUSInternalBusRoute?

    private let apiClient = NUSNextBusService.shared

    func fetchBus(for route: NUSInternalBusRoute) async {
        isLoadingBus = true
        defer { isLoadingBus = false }

        do {
            let activeResponse = try await apiClient.fetchActiveBuses(routeCode: route.code)
            self.bus = NUSInternalBusRoute(
                code: route.code,
                name: route.name,
                vehicles: activeResponse.activebus
            )
        } catch {
            self.errorMessage = "Failed to load NUS Internal active buses: \(error.localizedDescription)"
        }
    }

    func fetchStops(for route: NUSInternalBusRoute) async {
        isLoadingStops = true
        defer { isLoadingStops = false }

        guard let url = Bundle.main.url(forResource: "NUSInternalBusStopList", withExtension: "json") else {
            self.errorMessage = "Missing NUSInternalBusStopList.json"
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let stopDict = try JSONDecoder().decode([String: [NUSInternalBusStop]].self, from: data)
            self.stops = stopDict[route.code] ?? []
        } catch {
            self.errorMessage = "Failed to load stops: \(error.localizedDescription)"
        }
    }
}
