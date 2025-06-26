//
//  SMUPublicBusArrivalViewModel.swift
//  BusTrackerApp
//
//  Created by Ava on 22/6/25.
//
// Displays bus arrival times for an SMU public bus stop with a toggle and picker for notification lead time settings

import SwiftUI

struct SMUPublicBusArrivalView: View {
    let stop: PublicBusStop
    let arrival: PublicBusArrival
    @StateObject var viewModel: SMUPublicBusArrivalViewModel
    @State private var showingPickerSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Bus \(arrival.serviceNo)")
                    .font(.headline)
                Text(stop.Description)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Divider()

                if viewModel.minutesToArrivals.isEmpty {
                    Text("No arrival data.")
                        .foregroundColor(.gray)
                } else {
                    HStack {
                        ForEach(viewModel.minutesToArrivals.prefix(3), id: \.self) { mins in
                            Text("\(mins) min")
                                .padding(6)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(6)
                        }
                    }
                }

                Divider()

                Toggle("Notify me", isOn: $viewModel.notifyEnabled)
                    .onChange(of: viewModel.notifyEnabled) { enabled in
                        if enabled {
                            if !viewModel.notificationWasScheduled {
                                showingPickerSheet = true
                            }
                        } else {
                            viewModel.handleNotificationToggle()
                        }
                    }
            }
            .padding()
        }
        .onAppear {
            viewModel.configure(with: stop, arrival: arrival)
        }
        .sheet(isPresented: $showingPickerSheet, onDismiss: {
            if !viewModel.notificationWasScheduled {
                viewModel.notifyEnabled = false
            }
        }) {
            if let soonest = viewModel.minutesToArrivals.first, soonest >= 2 {
                NotificationLeadTimePickerView(
                    maxLeadTime: soonest - 1,
                    selectedMinutes: $viewModel.notifyMinutesBefore,
                    onSet: {
                        viewModel.notificationWasScheduled = true
                        viewModel.notifyEnabled = true
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
