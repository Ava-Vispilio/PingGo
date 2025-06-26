//
//  SMUPublicBusStopSelectionView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 22/6/25.
//
// Displays a list of SMU bus stops allowing users to select a stop and view available bus lines at that stop

import SwiftUI

struct SMUPublicBusStopSelectionView: View {
    @StateObject private var viewModel = SMUPublicBusStopListViewModel()

    var body: some View {
        NavigationStack {
            if viewModel.busStops.isEmpty {
                ProgressView("Loading stops…")
            } else {
                List(viewModel.busStops) { stop in
                    NavigationLink(destination: SMUPublicBusLineSelectionView(stop: stop)) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(stop.Description)
                                .font(.system(.body, design: .default).weight(.medium))

                            Text(stop.RoadName)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 2)
                    }
                }
                .navigationTitle("SMU Stops")
            }
        }
    }
}
