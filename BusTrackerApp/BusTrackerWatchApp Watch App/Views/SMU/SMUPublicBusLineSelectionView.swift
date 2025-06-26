//
//  SMUPublicBusLineSelectionView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 22/6/25.
//
// Lists all upcoming SMU bus services for a selected stop and allows navigation to individual bus arrival details

import SwiftUI

struct SMUPublicBusLineSelectionView: View {
    let stop: PublicBusStop
    @StateObject private var viewModel = SMUPublicBusLineSelectionViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading…")
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            } else if viewModel.services.isEmpty {
                Text("No upcoming buses at this stop.")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            } else {
                List {
                    Section(header: Text(stop.Description)) {
                        ForEach(viewModel.services, id: \.serviceNo) { service in
                            NavigationLink(destination: SMUPublicBusArrivalView(
                                stop: stop,
                                arrival: service,
                                viewModel: SMUPublicBusArrivalViewModel()
                            )) {
                                Text("Bus \(service.serviceNo)")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Bus Lines")
        .onAppear {
            Task {
                await viewModel.fetchServices(for: stop.BusStopCode)
            }
        }
    }
}
