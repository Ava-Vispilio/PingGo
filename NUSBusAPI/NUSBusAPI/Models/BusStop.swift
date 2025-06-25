//
//  BusStop.swift
//  NUSBusAPI
//
//  Created by Ava on 12/6/25.
//

// model to parse NUSBusStops.json with
import Foundation

struct BusStopsResponse: Codable {
    let BusStopsResult: BusStopsResult
}

struct BusStopsResult: Codable {
    let busstops: [BusStop]
}

struct BusStop: Codable, Identifiable, Hashable {
    let caption: String
    let name: String
    let LongName: String
    let ShortName: String
    let latitude: Double
    let longitude: Double
    
    var id: String { name }
}
