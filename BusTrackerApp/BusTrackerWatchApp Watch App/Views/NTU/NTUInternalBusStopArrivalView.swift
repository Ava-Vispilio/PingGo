//
//  NTUInternalBusStopArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 24/6/25.
//

import SwiftUI

struct NTUInternalBusStopArrivalView: View {
    let busStopId: String

    @StateObject var viewModel: NTUInternalBusStopArrivalViewModel
    @State private var showingPickerSheet = false

    init(busStopId: String, stopName: String) {
        self.busStopId = busStopId
        _viewModel = StateObject(wrappedValue: NTUInternalBusStopArrivalViewModel(busStopId: busStopId, stopName: stopName))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading arrival times...")
                    .frame(maxHeight: .infinity, alignment: .center)
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .frame(maxHeight: .infinity, alignment: .center)
            } else {
                List {
                    // Top section: stop name and arrivals
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.stopName)
                            .font(.headline)
                        if viewModel.arrivalTimes.isEmpty {
                            Text("No upcoming arrivals.")
                                .foregroundColor(.gray)
                        } else {
                            HStack {
                                ForEach(Array(viewModel.arrivalTimes.prefix(3).enumerated()), id: \.offset) { _, time in
                                    Text("\(time.minutes) min")
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.green.opacity(0.2))
                                        .cornerRadius(6)
                                }

                            }
                        }
                    }
                    .padding(.vertical, 4)

                    // Notification Section
                    Section {
                        Toggle("Notify me before arrival", isOn: $viewModel.notifyEnabled)
                            .onChange(of: viewModel.notifyEnabled) { enabled in
                                if enabled {
                                    if !viewModel.notificationWasScheduled {
                                        showingPickerSheet = true
                                    }
                                } else {
                                    viewModel.handleNotificationToggle()
                                }
                            }

                        if viewModel.notifyEnabled && viewModel.notificationWasScheduled {
                            Button(action: {
                                showingPickerSheet = true
                            }) {
                                HStack {
                                    Text("Notify \(viewModel.notifyMinutesBefore) min before arrival")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Bus Arrivals")
        .onAppear {
            viewModel.restoreSavedSettings()
            Task {
                await viewModel.fetchArrivalTimes(for: busStopId)
            }
        }
        .sheet(isPresented: $showingPickerSheet, onDismiss: {
            if !viewModel.notificationWasScheduled {
                viewModel.notifyEnabled = false
            }
        }) {
            if let soonest = viewModel.arrivalTimes.first?.minutes, soonest >= 2 {
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
