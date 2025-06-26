//
//  SMUPublicBusStopListViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Loads a list of SMU's public bus stop

import Foundation
import Combine

class SMUPublicBusStopListViewModel: ObservableObject {
    @Published var busStops: [PublicBusStop] = []

    init() {
        loadSMUBusStops()
    }

    private func loadSMUBusStops() {
        guard let url = Bundle.main.url(forResource: "SMUPublicBusStopList", withExtension: "json") else {
            print("Failed to find SMUPublicBusStopList.json in bundle")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([PublicBusStop].self, from: data)
            self.busStops = decoded
        } catch {
            print("Failed to load or decode bus stops: \(error)")
        }
    }
}
