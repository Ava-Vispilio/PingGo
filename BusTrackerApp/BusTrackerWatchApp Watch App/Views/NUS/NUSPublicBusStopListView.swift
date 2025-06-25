//
//  NUSPublicBusStopListView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 23/6/25.
//


import SwiftUI

struct NUSPublicBusStopListView: View {
    let line: PublicBusLine
    @StateObject private var viewModel = NUSPublicBusStopListViewModel()
    @StateObject private var stopViewModelsHolder = ViewModelCache()

    class ViewModelCache: ObservableObject {
        @Published var cache: [String: NUSPublicBusArrivalViewModel] = [:]
    }

    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView("Loading stops...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                ForEach(viewModel.stops) { stop in
                    NavigationLink(destination: NUSPublicBusArrivalView(viewModel: getOrCreateViewModel(for: stop))) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(stop.Description)
                                .font(.system(size: 14, weight: .medium))
                            Text(stop.RoadName)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
        }
        .navigationTitle("Bus \(line.lineName)")
        .onAppear {
            viewModel.loadStops(for: line)
        }
    }

    private func getOrCreateViewModel(for stop: PublicBusStop) -> NUSPublicBusArrivalViewModel {
        let key = "\(stop.BusStopCode)_\(line.lineName)"
        if let existing = stopViewModelsHolder.cache[key] {
            return existing
        } else {
            let newVM = NUSPublicBusArrivalViewModel(stop: stop, busService: line.lineName)
            stopViewModelsHolder.cache[key] = newVM
            return newVM
        }
    }
}
