//
//  BusArrivalViewModel.swift
//  NUSBusAPI
//
//  Created by Ava on 12/6/25.
//

// Logic to bridge data w UI
import Foundation

class BusArrivalViewModel: ObservableObject {
    @Published var arrivalInfo: ShuttleServiceResult?
    @Published var error: String?
    
    @Published var busStops: [BusStop] = []
    @Published var selectedStop: BusStop? = nil
    
    func loadArrival(for busStopName: String) {
        NUSNextBusService.shared.fetchArrivalInfo(busStopName: busStopName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let info):
                    self.arrivalInfo = info
                case .failure(let err):
                    self.error = err.localizedDescription
                }
            }
        }
    }

    func loadBusStops() {
        guard let url = Bundle.main.url(forResource: "NUSBusStops", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(BusStopsResponse.self, from: data) else {
            print("Failed to load or decode bus stops")
            self.error = "Failed to load bus stops."
            return
        }
        DispatchQueue.main.async {
                self.busStops = decoded.BusStopsResult.busstops

                // Set selected stop only if not already set
                if self.selectedStop == nil {
                    self.selectedStop = self.busStops.first
                }

                if self.busStops.isEmpty {
                    self.error = "No bus stops found."
                }
            }
    }

    func fetchArrival(for stop: BusStop) {
        loadArrival(for: stop.name)
    }
}
