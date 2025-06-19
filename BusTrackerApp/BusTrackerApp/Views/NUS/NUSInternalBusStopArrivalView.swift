//
//  NUSInternalBusStopArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 14/6/25.
//


import SwiftUI

struct NUSInternalBusStopArrivalView: View {
    let stop: NUSInternalBusStop
    let routeCode: String

    @StateObject private var viewModel: NUSInternalBusStopArrivalViewModel

    init(stop: NUSInternalBusStop, routeCode: String) {
        self.stop = stop
        self.routeCode = routeCode
        _viewModel = StateObject(wrappedValue: NUSInternalBusStopArrivalViewModel(stop: stop, routeCode: routeCode))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Fetching arrivals...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)").foregroundColor(.red)
            } else {
                List {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bus \(routeCode)")
                            .font(.headline)
                        HStack {
                            ForEach(viewModel.arrivals.prefix(3), id: \.self) { minutes in
                                Text("\(minutes) min")
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(6)
                            }
                        }
                    }
                    .padding(.vertical, 4)

                    // Notification toggle and picker section
                    Section {
                        Toggle("Notify me before arrival", isOn: $viewModel.notifyEnabled)
                        if viewModel.notifyEnabled {
                            Button(action: {
                                withAnimation {
                                    viewModel.showScrollWheel.toggle()
                                }
                            }) {
                                HStack {
                                    Text("Minutes before: \(viewModel.minutesBefore)")
                                    Spacer()
                                    Image(systemName: viewModel.showScrollWheel ? "chevron.up" : "chevron.down")
                                }
                            }

                            if viewModel.showScrollWheel {
                                let maxMinutes = (viewModel.arrivals.first ?? 10) + 1

                                Picker("Minutes before", selection: $viewModel.minutesBefore) {
                                    ForEach(1..<maxMinutes, id: \.self) { minute in
                                        Text("\(minute) minute\(minute > 1 ? "s" : "")").tag(minute)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 120)
                            }
                        }
                    }
                    .listRowSeparator(.visible)
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Bus Arrivals")
        .task {
            await viewModel.fetchArrivals()
        }
        .onDisappear {
            viewModel.notifyEnabled = false
        }
    }
}

