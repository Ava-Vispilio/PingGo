//
//  NUSPublicBusArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Displays NUS's public bus arrival times (selected bus route and stop) and allows users to set notifications

import SwiftUI

struct NUSPublicBusArrivalView: View {
//    let stop: PublicBusStop
//    let busService: String

    @StateObject var viewModel: NUSPublicBusArrivalViewModel // edit here
    @State private var showPicker = false
    @State private var maxLeadTime = 9  // default max value until arrivals are fetched

//    init(stop: PublicBusStop, busService: String) {
//        self.stop = stop
//        self.busService = busService
//        _viewModel = StateObject(wrappedValue: NUSPublicBusArrivalViewModel(stop: stop, busService: busService))
//    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Fetching arrivals...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)").foregroundColor(.red)
            } else {
                List {
                    ForEach(viewModel.arrivals) { arrival in
                        VStack(alignment: .leading) {
                            Text("Bus \(arrival.serviceNo)")
                                .font(.headline)
                            HStack {
                                ForEach(arrival.minutesToArrivals.prefix(3), id: \.self) { min in
                                    Text("\(min) min")
                                        .padding(4)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(5)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    Section {
                        Toggle("Notify me before arrival", isOn: $viewModel.notifyEnabled)
                            .onChange(of: viewModel.notifyEnabled) { newValue in
                                if newValue {
                                    showPicker = true
                                } else {
                                    viewModel.cancelNotification()
                                    showPicker = false
                                }
                            }

                        if viewModel.notifyEnabled {
                            Button(action: {
                                withAnimation {
                                    showPicker.toggle()
                                }
                            }) {
                                HStack {
                                    Text("Notify \(viewModel.minutesBefore) minute\(viewModel.minutesBefore > 1 ? "s" : "") before")
                                    Spacer()
                                    Image(systemName: showPicker ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.gray)
                                }
                            }

                            if showPicker {
                                Picker("Minutes before", selection: $viewModel.minutesBefore) {
                                    ForEach(1...maxLeadTime, id: \.self) { minute in
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
        .navigationTitle("\(viewModel.stop.Description)")
        .task {
            await viewModel.fetchArrivals()

            // Clamp lead time after arrivals are fetched
            if let soonest = viewModel.arrivals.first?.minutesToArrivals.first, soonest > 0 {
                maxLeadTime = soonest
                if viewModel.minutesBefore > soonest {
                    viewModel.minutesBefore = soonest
                }
            }
        }
//        .onDisappear {
//            viewModel.notifyEnabled = false
//        }
    }
}
