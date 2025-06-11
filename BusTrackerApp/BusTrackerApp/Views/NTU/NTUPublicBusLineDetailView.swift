//
//  NTUPublicBusLineDetailView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//


import SwiftUI

struct NTUPublicBusLineDetailView: View {
    let line: PublicBusLine
    @StateObject private var viewModel: NTUPublicBusLineDetailViewModel

    init(line: PublicBusLine) {
        self.line = line
        _viewModel = StateObject(wrappedValue: NTUPublicBusLineDetailViewModel(line: line))
    }

    var body: some View {
        List(viewModel.stops) { stop in
            NavigationLink(destination: NTUPublicBusStopArrivalView(stop: stop)) {
                VStack(alignment: .leading) {
                    Text(stop.Description)
                        .font(.headline)
                    Text(stop.RoadName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Stops for \(line.lineName)")
    }
}
