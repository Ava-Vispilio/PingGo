//
//  NTUPublicBusStopArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 24/6/25.
//
// Displays upcoming arrival times for a selected NTU public bus stop

import SwiftUI

struct NTUPublicBusStopArrivalView: View {
    @StateObject private var viewModel: NTUPublicBusStopArrivalViewModel
    @State private var maxLeadTime: Int = 10
    @State private var showingPickerSheet = false

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
                .listStyle(.plain)
            } else {
                List {
                    // Arrival info
                    ForEach(viewModel.arrivals) { arrival in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bus \(arrival.serviceNo)")
                                .font(.headline)
                            HStack {
                                ForEach(arrival.minutesToArrivals.prefix(3), id: \.self) { minutes in
                                    Text("\(minutes) min")
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(6)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    // Notification toggle
                    Section {
                        Toggle("Notify before arrival", isOn: $viewModel.notificationsEnabled)
                            .onChange(of: viewModel.notificationsEnabled) { enabled in
                                if enabled {
                                    if !viewModel.notificationWasScheduled {
                                        showingPickerSheet = true
                                    }
                                } else {
                                    viewModel.handleNotificationToggle()
                                }
                            }

                        if viewModel.notificationsEnabled && viewModel.notificationWasScheduled {
                            Button(action: {
                                showingPickerSheet = true
                            }) {
                                HStack {
                                    Text("Notify \(viewModel.notificationLeadTime) min before")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.stop.Description)
        .task {
            await viewModel.fetchArrivals()

            if let soonest = viewModel.arrivals
                .flatMap({ $0.minutesToArrivals })
                .filter({ $0 > 0 })
                .min()
            {
                maxLeadTime = soonest
                if viewModel.notificationLeadTime > soonest {
                    viewModel.notificationLeadTime = soonest
                }
            }
        }
        .sheet(isPresented: $showingPickerSheet, onDismiss: {
            if !viewModel.notificationWasScheduled {
                viewModel.notificationsEnabled = false
            }
        }) {
            if let soonest = viewModel.arrivals
                .flatMap({ $0.minutesToArrivals })
                .filter({ $0 > 1 })
                .min()
            {
                NotificationLeadTimePickerView(
                    maxLeadTime: soonest - 1,
                    selectedMinutes: $viewModel.notificationLeadTime,
                    onSet: {
                        viewModel.notificationWasScheduled = true
                        viewModel.notificationsEnabled = true
                        viewModel.handleNotificationToggle()
                    }
                )
            } else {
                Text("No valid arrival to notify.")
                    .padding()
            }
        }
    }
}
