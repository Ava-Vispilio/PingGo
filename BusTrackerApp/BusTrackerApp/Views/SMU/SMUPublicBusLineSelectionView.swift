//
//  SMUPublicBusLineSelectionView.swift
//  BusTrackerApp
//
//  Created by Ava on 16/6/25.
//
// Displays bus services for a selected bus stop
// Just a note that for SMU, bus stop selection view comes before bus line selection view

import SwiftUI

struct SMUPublicBusLineSelectionView: View {
    let stop: PublicBusStop
    @StateObject private var viewModel = SMUPublicBusLineSelectionViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading bus services…")
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.services.isEmpty {
                Text("No upcoming buses at this stop.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    Section(header:
                        Text("Bus Stop: \(stop.Description)")
                    ) {
                        ForEach(viewModel.services, id: \.serviceNo) { service in
                            NavigationLink(destination: SMUPublicBusArrivalView(
                                stop: stop,
                                arrival: service,
                                viewModel: SMUPublicBusArrivalViewModel()
                            )) {
                                Text("\(service.serviceNo)")
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Operating Bus Lines")
        .onAppear {
            Task {
                await viewModel.fetchServices(for: stop.BusStopCode)
            }
        }
    }
}
