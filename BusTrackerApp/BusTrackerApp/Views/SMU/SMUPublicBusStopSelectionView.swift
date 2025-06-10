//
//  SMUBusStopSelectionView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//


import SwiftUI

struct SMUPublicBusStopSelectionView: View {
    @StateObject private var viewModel = SMUPublicBusStopListViewModel()
    var onSelect: (SMUPublicBusStop) -> Void

    var body: some View {
        NavigationView {
            List(viewModel.busStops) { stop in
                Button(action: {
                    onSelect(stop)
                }) {
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
