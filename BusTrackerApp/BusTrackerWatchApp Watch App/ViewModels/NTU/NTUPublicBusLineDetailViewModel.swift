//
//  NTUPublicBusLineDetailViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 24/6/25.
//
// Loads a list of NTU's public bus stops for a selected bus line


import Foundation

@MainActor
class NTUPublicBusLineDetailViewModel: ObservableObject {
    @Published var stops: [PublicBusStop] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    func loadStops(for lineName: String) {
            isLoading = true
            errorMessage = nil

            // Load from bundled JSON
            guard let url = Bundle.main.url(forResource: "NTUPublicBusStopList", withExtension: "json") else {
                errorMessage = "Bus stop list not found."
                isLoading = false
                return
            }

            do {
                let data = try Data(contentsOf: url)
                let stopList = try JSONDecoder().decode([String: [PublicBusStop]].self, from: data)
                if let stops = stopList[lineName] {
                    self.stops = stops
                } else {
                    errorMessage = "No stops found for \(lineName)"
                }
            } catch {
                errorMessage = "Error decoding stops: \(error.localizedDescription)"
            }

            isLoading = false
        }
}
