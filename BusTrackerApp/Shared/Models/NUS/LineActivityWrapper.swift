//
//  LineActivityWrapper.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 13/6/25.
//
// model to parse active bus lines response from API

import Foundation

struct ActiveBusResponseWrapper: Decodable {
    let ActiveBusResult: ActiveBusResponse
}

struct ActiveBusResponse: Decodable {
    let TimeStamp: String
    let ActiveBusCount: String
    let activebus: [ActiveBus]
}

struct ActiveBus: Codable {
    let vehplate: String
    let lat: Double?
    let lng: Double?
    let speed: Double?
    let direction: Double?
    let loadInfo: LoadInfo?
}

struct LoadInfo: Codable {
    let occupancy: Double?
    let crowdLevel: String?
    let capacity: Int?
    let ridership: Int?
}
