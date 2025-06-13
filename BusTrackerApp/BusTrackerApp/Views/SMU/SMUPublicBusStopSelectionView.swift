//
//  SMUPublicBusStopSelectionView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Displays list of bus stops (users to select bus stop)

import SwiftUI

struct SMUPublicBusStopSelectionView: View {
    @StateObject private var viewModel = SMUPublicBusStopListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.busStops) { stop in
                NavigationLink(destination: SMUPublicBusArrivalView(stop: stop)) {
                    VStack(alignment: .leading) {
                        Text(stop.Description)
                            .font(.headline)
                        Text(stop.RoadName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Select SMU Bus Stop")
        }
    }
}
