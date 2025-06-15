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
    
    private var arrivalMinutes: [Int] {
        viewModel.arrivalTimes.map { $0.minutes }
    }
    
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
                VStack(alignment: .leading, spacing: 16) {
                    // Top section: title and arrival times
                    Text("Bus Stop: \(viewModel.stopName)")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if arrivalMinutes.isEmpty {
                        Text("No upcoming arrivals.")
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    } else {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(arrivalMinutes, id: \.self) { minutes in
                                Text("\(minutes) min")
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(Color.gray.opacity(0.2)),
                                        alignment: .bottom
                                    )
                            }
                        }
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Bottom section: notification toggle and lead time
                    VStack(spacing: 12) {
                        Toggle("Notify me when bus is coming soon", isOn: $viewModel.notifyWhenSoon)
                            .onChange(of: viewModel.notifyWhenSoon) { enabled in
                                viewModel.toggleNotification(enabled)
                            }
                        
                        if viewModel.notifyWhenSoon {
                            Stepper(value: $viewModel.notificationLeadTime, in: 1...30, step: 1) {
                                Text("Notify \(viewModel.notificationLeadTime) min before arrival")
                            }
                            .onChange(of: viewModel.notificationLeadTime) { _ in
                                viewModel.rescheduleNotificationIfNeeded()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .padding()
        .navigationTitle("Bus Arrivals")
        .task {
            await viewModel.fetchArrivalTimes(for: busStopId)
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

// couldn't get this to work; when it did, it didn't look like NUS's one
//import SwiftUI
//
//struct NTUInternalBusStopArrivalView: View {
//    let busStopId: String
//    
//    @StateObject private var viewModel = NTUInternalBusStopArrivalViewModel()
//    
//    var body: some View {
//        VStack {
//            if viewModel.isLoading {
//                ProgressView("Loading arrival times...")
//                    .frame(maxHeight: .infinity, alignment: .center)
//            } else if let errorMessage = viewModel.errorMessage {
//                ErrorView(message: errorMessage)
//            } else {
//                ArrivalListView(
//                    arrivalTimes: viewModel.arrivalTimes,
//                    notifyWhenSoon: $viewModel.notifyWhenSoon,
//                    notificationLeadTime: $viewModel.notificationLeadTime
//                )
//            }
//        }
//        .navigationTitle(viewModel.stopName.isEmpty ? "Bus Arrivals" : viewModel.stopName)
//        .task { await viewModel.fetchArrivalTimes(for: busStopId) }
//        .onDisappear { viewModel.onDisappear() }
//        .background(Color.gray.opacity(0.1))
//    }
//}
//
//private struct ErrorView: View {
//    let message: String
//    
//    var body: some View {
//        Text("Error: \(message)")
//            .foregroundColor(.red)
//            .frame(maxHeight: .infinity, alignment: .center)
//    }
//}
//
//private struct ArrivalListView: View {
//    let arrivalTimes: [NTUInternalBusStopArrivalViewModel.BusArrivalDisplayItem]
//    @Binding var notifyWhenSoon: Bool
//    @Binding var notificationLeadTime: Int
//    
//    var body: some View {
//        List {
//            ArrivalTimesSection(arrivalTimes: arrivalTimes)
//            NotificationSection(
//                notifyWhenSoon: $notifyWhenSoon,
//                notificationLeadTime: $notificationLeadTime
//            )
//        }
//        .listStyle(.insetGrouped)
//    }
//}
//
//private struct ArrivalTimesSection: View {
//    let arrivalTimes: [NTUInternalBusStopArrivalViewModel.BusArrivalDisplayItem]
//    
//    var body: some View {
//        if !arrivalTimes.isEmpty {
//            Section {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 8) {
//                        ForEach(arrivalTimes.sorted(by: { $0.minutes < $1.minutes })) { arrival in
//                            ArrivalTimeBadge(minutes: arrival.minutes)
//                        }
//                    }
//                    .padding(.vertical, 4)
//                }.listRowBackground(Color.white)
//            }
//        } else {
//            Section {
//                NoArrivalsView()
//            }.listRowBackground(Color.white)
//        }
//    }
//}
//
//private struct NoArrivalsView: View {
//    var body: some View {
//        Text("No upcoming arrivals.")
//            .foregroundColor(.secondary)
//    }
//}
//
//private struct ArrivalTimeBadge: View {
//    let minutes: Int
//    
//    var body: some View {
//        Text("\(minutes) min")
//            .padding(4)
//            .background(Color.blue.opacity(0.2))
//            .cornerRadius(5)
//    }
//}
//
//private struct NotificationSection: View {
//    @Binding var notifyWhenSoon: Bool
//    @Binding var notificationLeadTime: Int
//    
//    var body: some View {
//        Section {
//            Toggle("Notify me before arrival", isOn: $notifyWhenSoon)
//            
//            if notifyWhenSoon {
//                Picker("Minutes before", selection: $notificationLeadTime) {
//                    ForEach(1..<10) { min in
//                        Text("\(min) minute\(min > 1 ? "s" : "")").tag(min)
//                    }
//                }
//                .pickerStyle(.wheel)
//            }
//        }
//        .listRowBackground(Color.white)
//    }
//}
