//
//  Model.swift
//  ArriveLah
//
//  Created by Ava on 8/6/25.
//

// Models/BusArrivalResponse.swift - structure to match JSON response from the API

import Foundation

struct BusArrivalResponse: Codable {
    let services: [BusService]
}

struct BusService: Codable {
    let no: String
    let next: BusTiming
    let subsequent: BusTiming?

    struct BusTiming: Codable {
        let duration_ms: Int?
        let lat: Double?
        let lng: Double?
        let type: String?
    }
}
