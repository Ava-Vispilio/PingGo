//
//  NTUPublicBusLineDetailViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Loads a list of NTU's public bus stops for a selected bus line


import Foundation

class NTUPublicBusLineDetailViewModel: ObservableObject {
    @Published var stops: [PublicBusStop] = []
    private let line: PublicBusLine

    init(line: PublicBusLine) {
        self.line = line
        self.stops = line.stops
    }
}
