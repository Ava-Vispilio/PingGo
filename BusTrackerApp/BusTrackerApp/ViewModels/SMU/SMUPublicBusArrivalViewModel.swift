//
//  SMUBusArrivalViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//

import Foundation
import Combine

@MainActor
class SMUPublicBusArrivalViewModel: ObservableObject {
    @Published var arrivals: [PublicBusArrival] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let service = ArriveLahService()

    func fetchArrivals(for stopCode: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let response: PublicBusArrivalResponse = try await service.fetchArrivals(for: stopCode, as: PublicBusArrivalResponse.self)

            if response.services.isEmpty {
                errorMessage = "No operating buses at this stop."
                arrivals = []
            } else {
                arrivals = response.services.map { PublicBusArrival(from: $0) }
                let activeBusNumbers = arrivals.map { $0.serviceNo }
                print("Active SMU bus services at stop \(stopCode): \(activeBusNumbers)")
            }
        } catch {
            errorMessage = "Failed to load bus arrivals: \(error.localizedDescription)"
            arrivals = []
        }
        
        isLoading = false
    }
}
