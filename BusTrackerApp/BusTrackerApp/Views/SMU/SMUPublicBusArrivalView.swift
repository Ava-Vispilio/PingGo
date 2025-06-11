//
//  SMUPublicBusArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//

import SwiftUI

struct SMUPublicBusArrivalView: View {
    let stop: PublicBusStop
    @StateObject private var viewModel = SMUPublicBusArrivalViewModel()

    @State private var expandedServices: Set<String> = []
    @State private var notifyServices: [String: Bool] = [:]
    @State private var notifyMinutesBefore: [String: Int] = [:]

    var body: some View {
        VStack(alignment: .leading) {
            Text(stop.Description)
                .font(.title2)
                .padding(.top)

            if viewModel.isLoading {
                ProgressView("Loading bus arrivals…")
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.arrivals.isEmpty {
                Text("No upcoming buses at this stop.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(viewModel.arrivals) { arrival in
                        Section(header:
                            HStack {
                                Text("Bus \(arrival.serviceNo)")
                                    .font(.headline)
                                Spacer()
                                Button {
                                    toggleExpanded(arrival.serviceNo)
                                } label: {
                                    Image(systemName: expandedServices.contains(arrival.serviceNo) ? "chevron.down" : "chevron.right")
                                }.buttonStyle(.plain)
                            }
                        ) {
                            if expandedServices.contains(arrival.serviceNo) {
                                HStack {
                                    ForEach(arrival.minutesToArrivals, id: \.self) { mins in
                                        Text("\(mins) min")
                                            .padding(6)
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(6)
                                    }
                                }

                                Toggle("Notify me", isOn: Binding(
                                    get: { notifyServices[arrival.serviceNo] ?? false },
                                    set: {
                                        notifyServices[arrival.serviceNo] = $0
                                        let id = "bus-\(arrival.serviceNo)-\(stop.BusStopCode)"
                                        if !$0 {
                                            NotificationManager.shared.cancelNotification(id: id)
                                        }
                                    }
                                ))
                                .padding(.top, 4)

                                if notifyServices[arrival.serviceNo] ?? false {
                                    Picker("Notify me before (min):", selection: Binding(
                                        get: { notifyMinutesBefore[arrival.serviceNo, default: 2] },
                                        set: { notifyMinutesBefore[arrival.serviceNo] = $0 }
                                    )) {
                                        ForEach([1, 2, 3, 5, 10], id: \.self) { val in
                                            Text("\(val) min").tag(val)
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                    .onChange(of: notifyMinutesBefore[arrival.serviceNo, default: 2]) { newValue in
                                        if let firstArrival = arrival.minutesToArrivals.first {
                                            let notifyAfter = (firstArrival - newValue) * 60
                                            if notifyAfter > 0 {
                                                let id = "bus-\(arrival.serviceNo)-\(stop.BusStopCode)"
                                                NotificationManager.shared.scheduleNotification(
                                                    id: id,
                                                    title: "Bus \(arrival.serviceNo) arriving",
                                                    body: "Your bus is arriving in \(newValue) minutes at \(stop.Description).",
                                                    after: notifyAfter
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }

            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            Task {
                await viewModel.fetchArrivals(for: stop.BusStopCode)
            }
        }
    }

    private func toggleExpanded(_ serviceNo: String) {
        if expandedServices.contains(serviceNo) {
            expandedServices.remove(serviceNo)
        } else {
            expandedServices.insert(serviceNo)
        }
    }
}
