//
//  NTUPublicBusLineDetailView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 24/6/25.
//


import SwiftUI

struct NTUPublicBusLineDetailView: View {
    let lineName: String
    @StateObject private var viewModel = NTUPublicBusLineDetailViewModel()

    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView("Loading stops...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else if viewModel.stops.isEmpty {
                Text("No stops found for this route.")
                    .foregroundColor(.gray)
            } else {
                ForEach(viewModel.stops) { stop in
                    NavigationLink(destination: NTUPublicBusStopArrivalView(stop: stop)) {
                        VStack(alignment: .leading) {
                            Text(stop.Description)
                                .font(.headline)
                            Text(stop.RoadName)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationTitle("Bus \(lineName)")
        .onAppear {
            print("Loading stops for NTU public line: \(lineName)")
            viewModel.loadStops(for: lineName)
        }
    }
}
