//
//  NTUAPIResponseWrappers.swift
//  BusTrackerApp
//
//  Created by Ava on 2/6/25
//
// Provides wrapper structs matching the JSON structure of the API

import Foundation

// For endpoint /prod/[color]-bus
struct NTUBusLineResponse: Decodable {
    let bus: NTUInternalBus

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for key in container.allKeys {
            if key.stringValue.hasSuffix("Bus") {
                bus = try container.decode(NTUInternalBus.self, forKey: key)
                return
            }
        }
        throw DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: [],
                                  debugDescription: "No bus key found in response"))
    }

    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) { self.stringValue = stringValue }

        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }
}

// For endpoint /prod/bus-stop-details
struct NTUBusStopDetailsResponse: Codable {
    let message: String
    let busStopDetails: [String: [NTUInternalBusStop]]  // Keys like "blueBus", "redBus", etc.
}

// For endpoint /prod/bus-arrival
struct NTUBusArrivalResponse: Codable {
    let message: String
    let busArrival: NTUInternalBusArrival
}
