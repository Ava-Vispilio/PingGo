//
//  NUSInternalBusLineDetailView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 23/6/25.
//

import SwiftUI

struct NUSInternalBusLineDetailView: View {
    let line: NUSInternalBusRoute

    @StateObject private var viewModel = NUSInternalBusLineDetailViewModel()
    @StateObject private var stopViewModelsHolder = InternalViewModelCache()

    class InternalViewModelCache: ObservableObject {
        @Published var cache: [String: NUSInternalBusStopArrivalViewModel] = [:]
    }

    var body: some View {
        List {
            if viewModel.isLoadingBus || viewModel.isLoadingStops {
                ProgressView("Loading data...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
//                // Show bus info (not needed here)
//                if let bus = viewModel.bus {
//                    Section(header: Text("Bus Info")) {
//                        if bus.vehicles.isEmpty {
//                            Text("No active vehicles.")
//                                .foregroundColor(.secondary)
//                        } else {
//                            ForEach(bus.vehicles, id: \.vehplate) { vehicle in
//                                VStack(alignment: .leading, spacing: 2) {
//                                    Text("Plate: \(vehicle.vehplate)")
//                                    if let crowd = vehicle.loadInfo?.crowdLevel {
//                                        Text("Crowd: \(crowd)")
//                                            .font(.caption)
//                                            .foregroundColor(.gray)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }

                // Show stops
                if !viewModel.stops.isEmpty {
                    Section(header: Text("Stops")) {
                        ForEach(viewModel.stops) { stop in
                            NavigationLink(destination: NUSInternalBusStopArrivalView(
                                stop: stop,
                                routeCode: line.code,
                                viewModel: getOrCreateInternalViewModel(for: stop))
                            ) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(stop.name)
                                        .font(.system(size: 14, weight: .medium))
                                    Text("Stop ID: \(stop.name)")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                } else {
                    Text("No stops available.")
                        .foregroundColor(.secondary)
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

    private func getOrCreateInternalViewModel(for stop: NUSInternalBusStop) -> NUSInternalBusStopArrivalViewModel {
        let key = "\(stop.name)_\(line.code)"
        if let existing = stopViewModelsHolder.cache[key] {
            return existing
        } else {
            let newVM = NUSInternalBusStopArrivalViewModel(stop: stop, routeCode: line.code)
            stopViewModelsHolder.cache[key] = newVM
            return newVM
        }
    }
}
