//
//  NUSPublicBusStopListView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
// Displays a list of NUS's public bus stops for a selected bus route

import SwiftUI

struct NUSPublicBusStopListView: View {
    let line: PublicBusLine
    @StateObject private var viewModel = NUSPublicBusStopListViewModel()

    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView("Loading stops...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                ForEach(viewModel.stops) { stop in
                    NavigationLink(destination: NUSPublicBusArrivalView(stop: stop, busService: line.lineName)) {
                        VStack(alignment: .leading) {
                            Text(stop.Description)
                                .font(.headline)
                            Text(stop.RoadName)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationTitle("\(line.lineName) Stops")
        .onAppear {
            viewModel.loadStops(for: line)
        }
    }
}
