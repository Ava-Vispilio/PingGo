//
//  BusArrival.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//

import Foundation
import CoreLocation

struct NTUBusArrival: Identifiable, Codable {
    let id: String       // Typically the bus stop ID
    let name: String     // Human-readable stop name
    let forecasts: [NTUBusArrivalTime]
    let geometries: [NTUBusVehicleLocation]
}

struct NTUBusArrivalTime: Codable, Identifiable {
    let id = UUID()
    let minutes: Int     // ETA in minutes
}

struct NTUBusVehicleLocation: Codable, Identifiable {
    let id = UUID()
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latString = try container.decode(String.self, forKey: .latitude)
        let lonString = try container.decode(String.self, forKey: .longitude)

        guard let lat = CLLocationDegrees(latString),
              let lon = CLLocationDegrees(lonString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .latitude,
                in: container,
                debugDescription: "Latitude or longitude string is not convertible to Double"
            )
        }

        self.latitude = lat
        self.longitude = lon
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("\(latitude)", forKey: .latitude)
        try container.encode("\(longitude)", forKey: .longitude)
    }
}
