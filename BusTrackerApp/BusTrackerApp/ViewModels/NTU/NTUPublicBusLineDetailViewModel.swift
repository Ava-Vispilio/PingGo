//
//  NTUPublicBusLineDetailViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//


import Foundation

class NTUPublicBusLineDetailViewModel: ObservableObject {
    @Published var stops: [PublicBusStop] = []
    private let line: PublicBusLine

    init(line: PublicBusLine) {
        self.line = line
        self.stops = line.stops
    }
}
