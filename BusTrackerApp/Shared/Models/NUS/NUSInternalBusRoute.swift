//
//  NUSInternalBusRoute.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 13/6/25.
//
// Hardcoded bus route codes

import Foundation

struct NUSInternalBusRoute: Identifiable, Hashable {
    let id = UUID()
    let code: String   // e.g., "A1"
    let name: String   // e.g., "Kent Ridge A1"
    var vehicles: [NUSInternalActiveBus] = []

    static let allRoutes: [NUSInternalBusRoute] = [
        NUSInternalBusRoute(code: "A1", name: "A1"),
        NUSInternalBusRoute(code: "A2", name: "A2"),
        NUSInternalBusRoute(code: "BTC", name: "BTC"),
        NUSInternalBusRoute(code: "D1", name: "D1"),
        NUSInternalBusRoute(code: "D2", name: "D2"),
        NUSInternalBusRoute(code: "E", name: "E"),
        NUSInternalBusRoute(code: "K", name: "K"),
        NUSInternalBusRoute(code: "L", name: "L")
    ]
}
