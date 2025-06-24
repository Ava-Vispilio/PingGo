//
//  NTUInternalBusLineDetailViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//  Updated for NTU-specific logic using shared BusRouteColor
//
// Fetches NTU's internal bus stops at a selected bus line

import Foundation

@MainActor
class NTUInternalBusLineDetailViewModel: ObservableObject {
    @Published var bus: NTUInternalBus? = nil
    @Published var stops: [NTUInternalBusStop] = []
    @Published var isLoadingBus = false
    @Published var isLoadingStops = false
    @Published var errorMessage: String? = nil

    private let apiClient: NTUBusAPIClient

    init(apiClient: NTUBusAPIClient = .shared) {
        self.apiClient = apiClient
    }

    func fetchBus(for line: BusRouteColor) async {
        isLoadingBus = true
        errorMessage = nil
        do {
            let fetchedBus = try await apiClient.fetchBusLineInfo(for: line).bus
            self.bus = fetchedBus
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoadingBus = false
    }

    func fetchStops(for line: BusRouteColor) async {
        isLoadingStops = true
        errorMessage = nil
        do {
            let fetchedStops = try await apiClient.fetchStops(for: line)
            self.stops = fetchedStops
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoadingStops = false
    }
}

