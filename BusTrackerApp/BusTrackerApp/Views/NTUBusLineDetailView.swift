//
//  NTUBusLineDetailView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//  Updated for NTU-specific logic
//

import SwiftUI

struct NTUBusLineDetailView: View {
    let line: BusRouteColor
    
    @StateObject private var viewModel = NTUBusLineDetailViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoadingBus || viewModel.isLoadingStops {
                ProgressView("Loading data...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if let bus = viewModel.bus {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Route: \(bus.routeName)")
                                    .font(.headline)
                                
                                if bus.vehicles.isEmpty {
                                    Text("No active vehicles on this line.")
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("Active Vehicles:")
                                        .font(.headline)
                                    ForEach(bus.vehicles) { vehicle in
                                        Text("Vehicle ID: \(vehicle.id.uuidString.prefix(8))")
                                            .padding(.bottom, 4)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                        
                        if !viewModel.stops.isEmpty {
                            Text("Stops:")
                                .font(.headline)
                                .padding(.top)
                            
                            List(viewModel.stops) { stop in
                                NavigationLink(destination: NTUBusStopArrivalView(busStopId: stop.id)) {
                                    Text(stop.name)
                                }
                            }
                            .frame(height: 300)
                        } else {
                            Text("No stops available.")
                                .foregroundColor(.secondary)
                                .padding()
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("\(line.rawValue.capitalized) Line")
        .task {
            async let busFetch = viewModel.fetchBus(for: line)
            async let stopsFetch = viewModel.fetchStops(for: line)
            _ = await (busFetch, stopsFetch)
        }
    }
}
