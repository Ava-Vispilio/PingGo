//
//  NUSInternalBusStopArrivalView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 14/6/25.
//


import SwiftUI

struct NUSInternalBusStopArrivalView: View {
    let stop: NUSInternalBusStop
    let routeCode: String

    @StateObject private var viewModel: NUSInternalBusStopArrivalViewModel
    
    init(stop: NUSInternalBusStop, routeCode: String) {
        self.stop = stop
        self.routeCode = routeCode
        _viewModel = StateObject(wrappedValue: NUSInternalBusStopArrivalViewModel(stop: stop, routeCode: routeCode))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Fetching arrivals...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)").foregroundColor(.red)
            } else {
                List {
                    ForEach(viewModel.arrivals, id: \.self) { arrival in
                        Text("\(arrival) min")
                            .padding(6)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(6)
                    }

                    Section {
                        Toggle("Notify me before arrival", isOn: $viewModel.notifyEnabled)
                        if viewModel.notifyEnabled {
                            Picker("Minutes before", selection: $viewModel.minutesBefore) {
                                ForEach(1..<10) { minute in
                                    Text("\(minute) minute\(minute > 1 ? "s" : "")").tag(minute)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 120)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle(stop.name)
        .task {
            await viewModel.fetchArrivals()
        }
        .onDisappear {
            viewModel.notifyEnabled = false
        }
    }
}
