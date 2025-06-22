//
//  SMUPublicBusArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 22/6/25.
//

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
                            showingPickerSheet = true
                        }
                    }
            }
            .padding()
        }
        .onAppear {
            viewModel.configure(with: stop, arrival: arrival)
        }
        .sheet(isPresented: $showingPickerSheet) {
            if let soonest = viewModel.minutesToArrivals.first, soonest >= 1 {
                NotificationLeadTimePickerView(
                    maxLeadTime: soonest,
                    selectedMinutes: $viewModel.notifyMinutesBefore,
                    onSet: {
                        viewModel.notifyEnabled = true
                    }
                )
            } else {
                Text("No valid arrival to notify.")
                    .padding()
            }
        }
    }
}

