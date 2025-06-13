//
//  PublicBusArrival.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Model for public (LTA) bus arrival times

import Foundation

// Raw decoded response from the ArriveLah API
struct PublicBusArrivalResponse: Codable {
    let services: [Service]

    struct Service: Codable, Identifiable {
        var id: String { "\(no)-\(originCode ?? "")-\(destinationCode ?? "")" }
        let no: String
        let operatorID: String  // renamed from `operator`, as it's a Swift keyword
        let next: Arrival?
        let next2: Arrival?
        let next3: Arrival?
        let subsequent: Arrival?

        var originCode: String? {
            next?.originCode ?? next2?.originCode ?? subsequent?.originCode
        }

        var destinationCode: String? {
            next?.destinationCode ?? next2?.destinationCode ?? subsequent?.destinationCode
        }

        enum CodingKeys: String, CodingKey {
            case no
            case operatorID = "operator"
            case next, next2, next3, subsequent
        }
    }

    struct Arrival: Codable {
        let time: String
        let durationMs: Int
        let lat: Double
        let lng: Double
        let load: String
        let feature: String
        let type: String
        let visitNumber: Int
        let originCode: String
        let destinationCode: String

        enum CodingKeys: String, CodingKey {
            case time
            case durationMs = "duration_ms"
            case lat, lng, load, feature, type
            case visitNumber = "visit_number"
            case originCode = "origin_code"
            case destinationCode = "destination_code"
        }
    }
}

// UI-ready arrival information for a single bus service
struct PublicBusArrival: Identifiable {
    let id = UUID()
    let serviceNo: String
    let minutesToArrivals: [Int] // [3, 7, 15]

    init(from service: PublicBusArrivalResponse.Service) {
        self.serviceNo = service.no
        self.minutesToArrivals = [service.next, service.next2, service.next3]
            .compactMap { $0?.durationMs }
            .map { Int($0 / 60000) } // Convert milliseconds to minutes
    }
}
