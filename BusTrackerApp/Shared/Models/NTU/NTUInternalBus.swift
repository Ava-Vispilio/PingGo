//
//  Bus.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//

import Foundation
import CoreLocation

struct NTUInternalBus: Identifiable, Codable {
    let id: Int
    let name: String
    let routeName: String
    let vehicles: [NTUBusVehicle]
}

extension NTUInternalBus {
    var isActive: Bool {
        !vehicles.isEmpty
    }
}

struct NTUBusVehicle: Codable, Identifiable {
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

    // Still allow encoding normally if needed
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("\(latitude)", forKey: .latitude)
        try container.encode("\(longitude)", forKey: .longitude)
    }
}
