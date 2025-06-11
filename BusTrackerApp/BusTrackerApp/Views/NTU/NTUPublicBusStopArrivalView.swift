//
//  NTUPublicBusStopArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//


import SwiftUI

struct NTUPublicBusStopArrivalView: View {
    @StateObject private var viewModel: NTUPublicBusStopArrivalViewModel

    init(stop: PublicBusStop) {
        _viewModel = StateObject(wrappedValue: NTUPublicBusStopArrivalViewModel(stop: stop))
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Arrivals for \(viewModel.stop.Description)")
                .font(.title3)
                .padding(.bottom)

            if viewModel.isLoading {
                ProgressView("Fetching arrivals...")
            } else if viewModel.arrivals.isEmpty {
                Text("No arrivals available.")
                    .foregroundColor(.secondary)
            } else {
                List(viewModel.arrivals) { arrival in
                    VStack(alignment: .leading) {
                        Text("Bus \(arrival.serviceNo)")
                            .font(.headline)
                        HStack {
                            ForEach(arrival.minutesToArrivals.prefix(3), id: \.self) { minutes in
                                Text("\(minutes) min")
                                    .padding(4)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
            }

            Section {
                Toggle("Notify before next bus", isOn: $viewModel.notificationsEnabled)
                if viewModel.notificationsEnabled {
                    Stepper("Notify me \(viewModel.notificationLeadTime) min before",
                            value: $viewModel.notificationLeadTime, in: 1...10)
                }
            }
            .padding()
        }
        .padding()
        .navigationTitle("Bus Stop")
        .task {
            await viewModel.fetchArrivals()
        }
    }
}
