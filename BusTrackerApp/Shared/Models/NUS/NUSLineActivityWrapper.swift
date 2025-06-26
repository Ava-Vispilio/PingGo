//
//  LineActivityWrapper.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 13/6/25.
//
// Model to parse active bus lines response from API

import Foundation

struct NUSInternalActiveBusResponseWrapper: Decodable {
    let ActiveBusResult: NUSInternalActiveBusResponse
}

struct NUSInternalActiveBusResponse: Decodable {
    let TimeStamp: String
    let ActiveBusCount: String
    let activebus: [NUSInternalActiveBus]
}

struct NUSInternalActiveBus: Codable, Hashable {
    let vehplate: String
    let lat: Double?
    let lng: Double?
    let speed: Double?
    let direction: Double?
    let loadInfo: NUSInternalLoadInfo?
}

struct NUSInternalLoadInfo: Codable, Hashable {
    let occupancy: Double?
    let crowdLevel: String?
    let capacity: Int?
    let ridership: Int?
}
