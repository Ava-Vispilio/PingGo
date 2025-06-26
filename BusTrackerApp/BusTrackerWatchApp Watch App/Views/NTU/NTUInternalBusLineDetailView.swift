//
//  NTUInternalBusLineDetailView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 24/6/25.
//
// Displays a list of stops for a selected NTU internal shuttle line, and loads arrival and route data via its ViewModel while handling loading and error states

import SwiftUI

struct NTUInternalBusLineDetailView: View {
    let line: BusRouteColor
    @StateObject private var viewModel = NTUInternalBusLineDetailViewModel()

    var body: some View {
        List {
            if viewModel.isLoadingBus || viewModel.isLoadingStops {
                ProgressView("Loading...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
//                // Active Vehicles Section
//                if let bus = viewModel.bus {
//                    Section(header: Text("Active Vehicles")) {
//                        if bus.vehicles.isEmpty {
//                            Text("No active vehicles.")
//                                .foregroundColor(.secondary)
//                        } else {
//                            ForEach(bus.vehicles) { vehicle in
//                                Text("ID: \(vehicle.id.uuidString.prefix(6))")
//                            }
//                        }
//                    }
//                }

                // Stops Section
                if !viewModel.stops.isEmpty {
                    Section(header: Text("Stops")) {
                        ForEach(viewModel.stops) { stop in
                            NavigationLink(destination: NTUInternalBusStopArrivalView(busStopId: stop.id, stopName: stop.name)) {
                                VStack(alignment: .leading) {
                                    Text(stop.name)
                                    Text("Stop ID: \(stop.id)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                } else {
                    Text("No stops found.")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("\(line.rawValue.capitalized)")
        .task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await viewModel.fetchBus(for: line) }
                group.addTask { await viewModel.fetchStops(for: line) }
            }
        }
    }
}
