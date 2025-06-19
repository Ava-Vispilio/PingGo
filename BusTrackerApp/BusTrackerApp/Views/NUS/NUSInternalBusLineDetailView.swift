//
//  NUSInternalBusLineDetailView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 14/6/25.
//

import SwiftUI

struct NUSInternalBusLineDetailView: View {
    let line: NUSInternalBusRoute

    @StateObject private var viewModel = NUSInternalBusLineDetailViewModel()

    var body: some View {
        Group {
            if viewModel.isLoadingBus || viewModel.isLoadingStops {
                ProgressView("Loading data...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Info card for bus vehicles
                        if let bus = viewModel.bus {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Route: \(bus.name)")
                                    .font(.headline)

                                if bus.vehicles.isEmpty {
                                    Text("No active vehicles on this line.")
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("Active Vehicles:")
                                        .font(.headline)
                                    ForEach(bus.vehicles, id: \.vehplate) { vehicle in
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Vehicle Plate: \(vehicle.vehplate)")
                                            if let crowd = vehicle.loadInfo?.crowdLevel {
                                                Text("Crowd Level: \(crowd)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding(.bottom, 4)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }

                        // Stops list
                        if !viewModel.stops.isEmpty {
                            Text("Stops:")
                                .font(.headline)
                                .padding(.top)

                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(viewModel.stops) { stop in
                                    NavigationLink(destination: NUSInternalBusStopArrivalView(stop: stop, routeCode: line.code)) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(stop.name)
                                                    .font(.headline)
                                                Text("Stop ID: \(stop.name)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(UIColor.secondarySystemBackground))
                                        .cornerRadius(10)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
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
        .navigationTitle("\(line.code) Line")
        .task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await viewModel.fetchBus(for: line) }
                group.addTask { await viewModel.fetchStops(for: line) }
            }
        }
    }
}
