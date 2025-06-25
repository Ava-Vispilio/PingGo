//
//  SMUPublicBusLineSelectionViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 22/6/25.
//


import Foundation

@MainActor
class SMUPublicBusLineSelectionViewModel: ObservableObject {
    @Published var services: [PublicBusArrival] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = ArriveLahService()

    func fetchServices(for stopCode: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let response: PublicBusArrivalResponse = try await service.fetchArrivals(for: stopCode, as: PublicBusArrivalResponse.self)

            if response.services.isEmpty {
                errorMessage = "No operating buses at this stop."
                services = []
            } else {
                services = response.services.map { PublicBusArrival(from: $0) }
                let activeBusNumbers = services.map { $0.serviceNo }
                print("Active SMU bus services at stop \(stopCode): \(activeBusNumbers)")
            }
        } catch {
            errorMessage = "Failed to load bus arrivals: \(error.localizedDescription)"
            services = []
        }

        isLoading = false
    }
}
