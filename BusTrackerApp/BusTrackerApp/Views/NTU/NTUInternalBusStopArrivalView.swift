//
//  NTUInternalBusStopArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//  Updated layout to separate top/bottom sections
//
// Displays a list of NTU's internal bus arrival times (selected bus route & stop) and allows notifications to be set

import SwiftUI

struct NTUInternalBusStopArrivalView: View {
    let busStopId: String

    @StateObject var viewModel: NTUInternalBusStopArrivalViewModel
    
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
                    // Arrival display section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bus \(viewModel.stopName)")
                            .font(.headline)
                        HStack {
                            ForEach(viewModel.arrivalTimes.prefix(3), id: \.self) { time in
                                Text("\(time.minutes) min")
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(6)
                            }
                        }
                    }
                    .padding(.vertical, 4)

                    // Notification toggle and scroll wheel picker
                    Section {
                        Toggle("Notify me before arrival", isOn: $viewModel.notifyWhenSoon)
                            .onChange(of: viewModel.notifyWhenSoon) { enabled in
                                viewModel.toggleNotification(enabled)
                            }

                        if viewModel.notifyWhenSoon {
                            Button(action: {
                                withAnimation {
                                    viewModel.showScrollWheel.toggle()
                                }
                            }) {
                                HStack {
                                    Text("Notify \(viewModel.notificationLeadTime) min before arrival")
                                    Spacer()
                                    Image(systemName: viewModel.showScrollWheel ? "chevron.up" : "chevron.down")
                                }
                            }

                            if viewModel.showScrollWheel {
                                let maxMinutes = (viewModel.arrivalTimes.first?.minutes ?? 10) + 1
                                Picker("Notify me", selection: $viewModel.notificationLeadTime) {
                                    ForEach(1..<maxMinutes, id: \.self) { minute in
                                        Text("\(minute) minute\(minute > 1 ? "s" : "")").tag(minute)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 120)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Bus Arrivals")
        .task {
            viewModel.restoreSavedSettings()
            await viewModel.fetchArrivalTimes(for: busStopId)
        }
//        .onDisappear {
//            viewModel.onDisappear()
//        }
    }
}
