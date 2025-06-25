//
//  ActiveBusTestView.swift
//  NUSBusAPI
//
//  Created by Ava on 12/6/25.
//

import SwiftUI

struct ActiveBusTestView: View {
    @StateObject private var viewModel = ActiveBusViewModel()

    private let routes = BusRoute.allRoutes
    @State private var selectedRoute: BusRoute = BusRoute.allRoutes.first!

    var body: some View {
        VStack(spacing: 20) {
            // Route picker
            Picker("Select Bus Route", selection: $selectedRoute) {
                ForEach(routes) { route in
                    Text(route.name).tag(route)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            // Fetch button
            Button("Fetch Active Buses") {
                viewModel.fetchActiveBuses(for: selectedRoute.code)
            }

            // Error message
            if let error = viewModel.error {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }

            // Active buses
            if viewModel.activeBuses.isEmpty {
                Text("No active buses found.")
            } else {
                List(viewModel.activeBuses, id: \.vehplate) { bus in
                    VStack(alignment: .leading) {
                        Text("Plate: \(bus.vehplate)")
                        Text("Speed: \((bus.speed ?? 0.0), specifier: "%.1f") km/h")
//                        Text("Occupancy: \((bus.loadInfo?.occupancy ?? 0.0), specifier: "%.1f")")
//                        Text("Crowd Level: \(bus.loadInfo?.crowdLevel ?? "Unknown")")
                        if let load = bus.loadInfo {
                            Text("Occupancy: \(load.occupancy ?? 0.0, specifier: "%.1f")")
                            Text("Crowd Level: \(load.crowdLevel ?? "Unkown")")
                        } else {
                            Text("Load info not available")
                        }
                    }
                }
            }
        }
        .padding()
    }
}
