//
//  SMUPublicBusArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Displays SMU's bus arrival times (selected stop and service) and allows user to set notifications

import SwiftUI

struct SMUPublicBusArrivalView: View {
    let stop: PublicBusStop
    let arrival: PublicBusArrival
    @StateObject private var viewModel = SMUPublicBusArrivalViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Bus \(arrival.serviceNo)")
                .font(.title2)
                .padding(.top)

            if viewModel.minutesToArrivals.isEmpty {
                Text("No arrival data.")
                    .foregroundColor(.gray)
            } else {
                // Display arrival timings
                HStack {
                    ForEach(viewModel.minutesToArrivals.prefix(3), id: \.self) { mins in
                        Text("\(mins) min")
                            .padding(6)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(6)
                    }
                }

                // Notification toggle and picker
                Toggle("Notify me before arrival", isOn: $viewModel.notifyEnabled)
                    .padding(.top, 4)

                if viewModel.notifyEnabled {
                    if let soonest = viewModel.minutesToArrivals.first, soonest > 1 {
                        Picker("Minutes before", selection: $viewModel.notifyMinutesBefore) {
                            ForEach(1..<soonest, id: \.self) { minute in
                                Text("\(minute) minute\(minute > 1 ? "s" : "")").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 120)
                    } else {
                        Text("Bus is arriving too soon. Cannot set a notification.")
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.configure(with: stop, arrival: arrival)
        }
        .onDisappear {
            viewModel.notifyEnabled = false
        }
    }
}

//import SwiftUI
//
//struct SMUPublicBusArrivalView: View {
//    let stop: PublicBusStop
//    let arrival: PublicBusArrival
//    @StateObject private var viewModel = SMUPublicBusArrivalViewModel()
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Bus \(arrival.serviceNo)")
//                .font(.title2)
//                .padding(.top)
//
//            if viewModel.minutesToArrivals.isEmpty {
//                Text("No arrival data.")
//                    .foregroundColor(.gray)
//            } else {
//                HStack {
//                    ForEach(viewModel.minutesToArrivals.prefix(3), id: \.self) { mins in
//                        Text("\(mins) min")
//                            .padding(6)
//                            .background(Color.blue.opacity(0.2))
//                            .cornerRadius(6)
//                    }
//                }
//
//                Section {
//                    Toggle("Notify me before arrival", isOn: $viewModel.notifyEnabled)
//
//                    if viewModel.notifyEnabled {
//                        Picker("Minutes before", selection: $viewModel.notifyMinutesBefore) {
//                            ForEach(validNotifyMinutes(), id: \.self) { minute in
//                                Text("\(minute) minute\(minute > 1 ? "s" : "")").tag(minute)
//                            }
//                        }
//                        .pickerStyle(.wheel)
//                        .frame(height: 120)
//                    }
//                }
//            }
//
//            Spacer()
//        }
//        .padding()
//        .onAppear {
//            viewModel.configure(with: stop, arrival: arrival)
//        }
//        .onDisappear {
//            viewModel.notifyEnabled = false
//        }
//    }
//
//    private func validNotifyMinutes() -> [Int] {
//        guard let soonest = viewModel.minutesToArrivals.first, soonest > 1 else {
//            return [] // No valid times if arrival in 0 or 1 minutes
//        }
//
//        return (1..<soonest).map { $0 }
//    }
//}
