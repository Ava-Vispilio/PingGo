//
//  NUSPublicBusArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Displays NUS's public bus arrival times (selected bus route and stop) and allows users to set notifications


// BusTrackerApp/Views/NUS/NUSBusArrivalView.swift

import SwiftUI

struct NUSPublicBusArrivalView: View {
    let stop: PublicBusStop
    let busService: String

    @StateObject private var viewModel = NUSPublicBusArrivalViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Fetching arrival times...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)").foregroundColor(.red)
            } else {
                List {
                    ForEach(viewModel.arrivals) { arrival in
                        VStack(alignment: .leading) {
                            Text("Service \(arrival.serviceNo)")
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
                        if viewModel.notifyEnabled {
                            Picker("Minutes before", selection: $viewModel.minutesBefore) {
                                ForEach(1..<10) { minute in
                                    Text("\(minute) minute\(minute > 1 ? "s" : "")").tag(minute)
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Stop: \(stop.Description)")
        .task {
            viewModel.configure(stopCode: stop.BusStopCode, busService: busService)
            await viewModel.fetchArrivals()
        }
        .onDisappear {
            viewModel.notifyEnabled = false
        }
    }
}
