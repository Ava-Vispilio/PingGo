//
//  NTUInternalBusStopArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//  Updated layout to separate top/bottom sections
//
// Displays a list of NTU's internal bus arrival times (selected bus route & stop) and allows notifications to be set

import SwiftUI

struct NTUInternalBusStopArrivalView: View {
    let busStopId: String
    
    @StateObject private var viewModel = NTUInternalBusStopArrivalViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading arrival times...")
                    .frame(maxHeight: .infinity, alignment: .center)
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .frame(maxHeight: .infinity, alignment: .center)
            } else {
                List {
                    if viewModel.arrivalTimes.isEmpty {
                        Text("No upcoming arrivals.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(viewModel.arrivalTimes, id: \.id) { arrival in  // something wrong with this that could require editing the whole MVVM
                            VStack(alignment: .leading) {
                                Text("Service \(arrival.service)")
                                    .font(.headline)
                                
                                Text("\(arrival.minutes) min")
                                    .padding(4)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(5)
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    Section {
                        Toggle("Notify me before arrival", isOn: $viewModel.notifyWhenSoon)
                        if viewModel.notifyWhenSoon {
                            Picker("Minutes before", selection: $viewModel.notificationLeadTime) {
                                ForEach(1..<10) { min in
                                    Text("\(min) minute\(min > 1 ? "s" : "")").tag(min)
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(viewModel.stopName.isEmpty ? "Bus Arrivals" : viewModel.stopName)
        .task {
            await viewModel.fetchArrivalTimes(for: busStopId)
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

//import SwiftUI
//
//struct NTUInternalBusStopArrivalView: View {
//    let busStopId: String
//    
//    @StateObject private var viewModel = NTUInternalBusStopArrivalViewModel()
//    
//    private var arrivalMinutes: [Int] {
//        viewModel.arrivalTimes.map { $0.minutes }
//    }
//    
//    var body: some View {
//        VStack {
//            if viewModel.isLoading {
//                ProgressView("Loading arrival times...")
//                    .frame(maxHeight: .infinity, alignment: .center)
//            } else if let errorMessage = viewModel.errorMessage {
//                Text("Error: \(errorMessage)")
//                    .foregroundColor(.red)
//                    .frame(maxHeight: .infinity, alignment: .center)
//            } else {
//                VStack(alignment: .leading, spacing: 16) {
//                    // Top section: title and arrival times
//                    Text("Bus Stop: \(viewModel.stopName)")
//                        .font(.headline)
//                        .padding(.horizontal)
//                    
//                    if arrivalMinutes.isEmpty {
//                        Text("No upcoming arrivals.")
//                            .foregroundColor(.secondary)
//                            .padding(.horizontal)
//                    } else {
//                        VStack(alignment: .leading, spacing: 0) {
//                            ForEach(arrivalMinutes, id: \.self) { minutes in
//                                Text("\(minutes) min")
//                                    .padding()
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .background(Color.white)
//                                    .overlay(
//                                        Rectangle()
//                                            .frame(height: 1)
//                                            .foregroundColor(Color.gray.opacity(0.2)),
//                                        alignment: .bottom
//                                    )
//                            }
//                        }
//                        .cornerRadius(12)
//                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
//                        .padding(.horizontal)
//                    }
//                    
//                    // Notification not at the bottom
//                    VStack(alignment: .leading, spacing: 12) {
//                        Toggle("Notify me when bus is coming soon", isOn: $viewModel.notifyWhenSoon)
//                        if viewModel.notifyWhenSoon {
//                            Picker("Minutes before", selection: $viewModel.notificationLeadTime) {
//                                ForEach(1..<10) { minute in
//                                    Text("\(minute) minute\(minute > 1 ? "s" : "")").tag(minute)
//                                }
//                            }
//                            .pickerStyle(.wheel)
//                        }
//                    .padding(.horizontal)
//                }
//                .padding(.vertical)
//                .frame(maxHeight: .infinity, alignment: .top)
//            }
//        }
//        .padding()
//        .navigationTitle("Bus Arrivals")
//        .task {
//            await viewModel.fetchArrivalTimes(for: busStopId)
//        }
//        .onDisappear {
//            viewModel.onDisappear()
//        }
//    }
//}
