//
//  BusArrivalTestView.swift
//  NUSBusAPI
//
//  Created by Ava on 12/6/25.
//

import SwiftUI

struct BusArrivalTestView: View {
    @StateObject private var viewModel = BusArrivalViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            if !viewModel.busStops.isEmpty {
                Picker("Select Bus Stop", selection: $viewModel.selectedStop) {
                    ForEach(viewModel.busStops) { stop in
                        Text(stop.caption).tag(Optional(stop)) // Optional because selectedStop is optional
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Button("Fetch Arrival Timings") {
                    if let stop = viewModel.selectedStop {
                        viewModel.fetchArrival(for: stop)
                    }
                }
            } else {
                ProgressView("Loading bus stops...")
            }
            
            if let arrivals = viewModel.arrivalInfo {
                List(arrivals.shuttles, id: \.routeid) { shuttle in
                    VStack(alignment: .leading) {
                        Text("Service: \(shuttle.name)")
                        Text("Arrival: \(shuttle.arrivalTime)")
                        Text("Next: \(shuttle.nextArrivalTime)")
                    }
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.loadBusStops()
        }
    }
}
