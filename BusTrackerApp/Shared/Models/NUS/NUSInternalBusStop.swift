//
//  NUSInternalBusStop.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 13/6/25.
//
// Model to parse NUSBusStops.json with

import Foundation

struct NUSInternalBusStopsResponse: Codable {
    let BusStopsResult: NUSInternalBusStopsResult
}

struct NUSInternalBusStopsResult: Codable {
    let busstops: [NUSInternalBusStop]
}

struct NUSInternalBusStop: Codable, Identifiable, Hashable {
    let caption: String
    let name: String
    let LongName: String
    let ShortName: String
    let latitude: Double
    let longitude: Double
    
    var id: String { name }
}
