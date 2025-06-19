//
//  NTUPublicBusStopArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Displays a list of NTU's public bus arrival times (selected bus route and stop) and allows users to set notifications

import SwiftUI

struct NTUPublicBusStopArrivalView: View {
    @StateObject private var viewModel: NTUPublicBusStopArrivalViewModel

    init(stop: PublicBusStop) {
        _viewModel = StateObject(wrappedValue: NTUPublicBusStopArrivalViewModel(stop: stop))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Fetching arrivals...")
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if viewModel.arrivals.isEmpty {
                List {
                    Text("No arrivals available.")
                        .foregroundColor(.secondary)
                }
                .listStyle(.insetGrouped)
            } else {
                List {
                    ForEach(viewModel.arrivals) { arrival in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bus \(arrival.serviceNo)")
                                .font(.headline)
                            HStack {
                                ForEach(arrival.minutesToArrivals.prefix(3), id: \.self) { minutes in
                                    Text("\(minutes) min")
                                        .padding(.horizontal, 8)    // why is this introduced?
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(6)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    Section {
                        Toggle("Notify before arrival", isOn: $viewModel.notificationsEnabled)
                        if viewModel.notificationsEnabled {
                            Picker("Notify me", selection: $viewModel.notificationLeadTime) {
                                ForEach(1..<11) { minute in
                                    Text("\(minute) minute\(minute > 1 ? "s" : "")").tag(minute)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 120)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle(viewModel.stop.Description)
        .task {
            await viewModel.fetchArrivals()
        }
        .onDisappear {
            viewModel.notificationsEnabled = false
        }
    }
}
