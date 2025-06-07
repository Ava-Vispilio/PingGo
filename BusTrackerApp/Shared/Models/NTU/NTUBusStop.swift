//
//  BusStop.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//

import Foundation

struct NTUBusStop: Identifiable, Codable {
    let id: String       // `busStopId` from backend
    let name: String

    var displayName: String {
        return name
    }

    var shortId: String {
        return id
    }

    var route: BusRouteColor?

    enum CodingKeys: String, CodingKey {
        case id = "busStopId"
        case name
    }
}

enum BusRouteColor: String, Codable, CaseIterable {
    case blue, red, yellow, green, brown
}
