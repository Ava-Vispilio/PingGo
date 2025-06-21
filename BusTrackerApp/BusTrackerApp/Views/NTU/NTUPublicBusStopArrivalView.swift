//
//  NTUPublicBusStopArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Displays a list of NTU's public bus arrival times (selected bus route and stop) and allows users to set notifications

import SwiftUI

struct NTUPublicBusStopArrivalView: View {
    @StateObject var viewModel: NTUPublicBusStopArrivalViewModel
    @State private var maxLeadTime: Int = 10

    init(stop: PublicBusStop) {
        _viewModel = StateObject(wrappedValue: NTUPublicBusStopArrivalViewModel(stop: stop))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Fetching arrivals...")
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if viewModel.arrivals.isEmpty {
                List {
                    Text("No arrivals available.")
                        .foregroundColor(.secondary)
                }
                .listStyle(.insetGrouped)
            } else {
                List {
                    ForEach(viewModel.arrivals) { arrival in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bus \(arrival.serviceNo)")
                                .font(.headline)
                            HStack {
                                ForEach(arrival.minutesToArrivals.prefix(3), id: \.self) { minutes in
                                    Text("\(minutes) min")
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(6)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    Section {
                        Toggle("Notify before arrival", isOn: $viewModel.notificationsEnabled)
                            .onChange(of: viewModel.notificationsEnabled) { newValue in
                                if !newValue {
                                    viewModel.showScrollWheel = false
                                }
                            }

                        if viewModel.notificationsEnabled {
                            Button(action: {
                                withAnimation {
                                    viewModel.showScrollWheel.toggle()
                                }
                            }) {
                                HStack {
                                    Text("Notify \(viewModel.notificationLeadTime) min before")
                                    Spacer()
                                    Image(systemName: viewModel.showScrollWheel ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.gray)
                                }
                            }

                            if viewModel.showScrollWheel {
                                Picker("Notify me", selection: $viewModel.notificationLeadTime) {
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
        .navigationTitle(viewModel.stop.Description)
        .task {
            await viewModel.fetchArrivals()

            if let soonest = viewModel.arrivals
                .flatMap({ $0.minutesToArrivals })
                .filter({ $0 > 0 })
                .min()
            {
                maxLeadTime = soonest
                if viewModel.notificationLeadTime > soonest {
                    viewModel.notificationLeadTime = soonest
                }
            }
        }
//        .onDisappear {
//            viewModel.notificationsEnabled = false
//        }
    }
}

