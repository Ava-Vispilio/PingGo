//
//  NTUPublicBusLineDetailView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Displays a list of NTU's public bus stops (to choose from) for a selected bus route

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
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationTitle("\(lineName) Stops")
        .onAppear {
            viewModel.loadStops(for: lineName)
        }
    }
}

//import SwiftUI
//
//struct NTUPublicBusLineDetailView: View {
//    let line: PublicBusLine
//    @StateObject private var viewModel = NTUPublicBusLineDetailViewModel()
//
//    var body: some View {
//        List {
//            if viewModel.isLoading {
//                ProgressView("Loading stops...")
//            } else if let error = viewModel.errorMessage {
//                Text("Error: \(error)")
//                    .foregroundColor(.red)
//                    .multilineTextAlignment(.center)
//            } else if viewModel.stops.isEmpty {
//                Text("No stops found for this route.")
//                    .foregroundColor(.gray)
//                    .multilineTextAlignment(.center)
//            } else {
//                ForEach(viewModel.stops) { stop in
//                    NavigationLink(destination: NTUPublicBusStopArrivalView(stop: stop)) {
//                        VStack(alignment: .leading) {
//                            Text(stop.Description)
//                                .font(.headline)
//                            Text(stop.RoadName)
//                                .font(.subheadline)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                }
//            }
//        }
//        .navigationTitle("\(line.lineName) Stops")
//        .onAppear {
//            viewModel.loadStops(for: lineName)
//        }
//    }
//}
