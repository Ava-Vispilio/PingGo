//
//  NTUInternalBusArrival.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//
// Model for NTU bus arrival times at a specific bus stop, including vehicle location

import Foundation
import CoreLocation

struct NTUInternalBusArrival: Identifiable, Codable {
    let id: String       // Typically the bus stop ID
    let name: String     // Human-readable stop name
    let forecasts: [NTUInternalBusArrivalTime]
    let geometries: [NTUBusVehicleLocation]
}

struct NTUInternalBusArrivalTime: Codable, Identifiable {
    let id = UUID()     // Removing identifiable and commenting this line wld make it work with the edited (commented) viewmodel; also removes the warning
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
