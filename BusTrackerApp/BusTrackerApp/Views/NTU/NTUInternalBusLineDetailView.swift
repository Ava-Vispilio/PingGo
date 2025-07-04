//
//  NTUInternalBusLineDetailView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//
// Displays a list of NTU's internal bus stops and active buses for a selected route

import SwiftUI

struct NTUInternalBusLineDetailView: View {
    let line: BusRouteColor

    @StateObject private var viewModel = NTUInternalBusLineDetailViewModel()

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
                VStack(alignment: .leading, spacing: 16) {
                    // Info card at top
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

                    // Scrollable list of stops taking up remaining space
                    if !viewModel.stops.isEmpty {
                        Text("Stops:")
                            .font(.headline)
                            .padding(.top)

                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(viewModel.stops) { stop in
                                    NavigationLink(destination: NTUInternalBusStopArrivalView(busStopId: stop.id, stopName: stop.name)) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(stop.name)
                                                    .font(.headline)
                                                Text("Stop ID: \(stop.id)")
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
        .navigationTitle("\(line.rawValue.capitalized) Line")
//        .task {
//            async let busFetch = viewModel.fetchBus(for: line)  // Constant 'busFetch' inferred to have type '()', which may be unexpected
//            async let stopsFetch = viewModel.fetchStops(for: line)  // Constant 'busFetch' inferred to have type '()', which may be unexpected
//            _ = await (busFetch, stopsFetch)
//        }
        // got rid of the warnings
        .task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await viewModel.fetchBus(for: line) }
                group.addTask { await viewModel.fetchStops(for: line) }
            }
        }
    }
}
