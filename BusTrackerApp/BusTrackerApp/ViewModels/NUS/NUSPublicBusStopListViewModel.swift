//
//  NUSBusStopListViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//

import Foundation

@MainActor
class NUSPublicBusStopListViewModel: ObservableObject {
    @Published var stops: [PublicBusStop] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    func loadStops(for line: PublicBusLine) {
        isLoading = true
        errorMessage = nil

        // Directly assign stops from the selected line
        self.stops = line.stops
        isLoading = false
    }
}

