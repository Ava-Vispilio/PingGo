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

