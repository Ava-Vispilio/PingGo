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
            ZStack {
                Color.white.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 16) {
                    contentView()
                }
                .padding(.top)
                .navigationTitle("SMU Bus Stops")
            }
        }
    }

    @ViewBuilder
    private func contentView() -> some View {
        if viewModel.busStops.isEmpty {
            ProgressView("Loading stops…")
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.busStops) { stop in
                        busStopRow(stop)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func busStopRow(_ stop: PublicBusStop) -> some View {
        NavigationLink(destination: SMUPublicBusLineSelectionView(stop: stop)) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(stop.Description)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(stop.RoadName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
