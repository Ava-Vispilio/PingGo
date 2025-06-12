//
//  NUSInternalBusRoute.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 13/6/25.
//
// Hardcoded bus route codes

import Foundation

struct BusRoute: Identifiable, Hashable {
    let id = UUID()
    let code: String   // e.g., "A1"
    let name: String   // e.g., "Kent Ridge A1"

    static let allRoutes: [BusRoute] = [
        BusRoute(code: "A1", name: "A1"),
        BusRoute(code: "A2", name: "A2"),
        BusRoute(code: "BTC", name: "BTC"),
        BusRoute(code: "D1", name: "D1"),
        BusRoute(code: "D2", name: "D2"),
        BusRoute(code: "E", name: "E"),
        BusRoute(code: "K", name: "K"),
        BusRoute(code: "L", name: "L")
    ]
}
