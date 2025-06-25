//
//  NUSInternalBusStopArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 23/6/25.
//


import SwiftUI

struct NUSInternalBusStopArrivalView: View {
    let stop: NUSInternalBusStop
    let routeCode: String
    @StateObject var viewModel: NUSInternalBusStopArrivalViewModel
    @State private var showingPickerSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Bus \(routeCode)")
                    .font(.headline)

                Text(stop.caption)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Divider()

                if viewModel.minutesToArrivals.isEmpty {
                    Text("No arrival data.")
                        .foregroundColor(.gray)
                } else {
                    HStack {
                        ForEach(viewModel.minutesToArrivals.prefix(3), id: \.self) { min in
                            Text("\(min) min")
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
            Task {
                await viewModel.fetchArrivals()
            }
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
