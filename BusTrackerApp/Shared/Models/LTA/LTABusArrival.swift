//
//  LTABusArrival.swift
//  BusTrackerApp
//
//  Created by Ava on 8/6/25.
//
// Models/BusArrivalResponse.swift - structure to match JSON response from the API

import Foundation

struct LTABusArrival: Codable {
    let services: [LTABusService]
}

struct LTABusService: Codable {
    let no: String
    let next: LTABusTiming
    let subsequent: LTABusTiming?

    struct LTABusTiming: Codable {
        let duration_ms: Int?
        let lat: Double?
        let lng: Double?
        let type: String?
    }
}
