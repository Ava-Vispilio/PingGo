//
//  NUSInternalBusArrival.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 13/6/25.
//
// model to parse arrival response from API

import Foundation

struct NUSInternalShuttleServiceResponse: Codable {
    let ShuttleServiceResult: NUSInternalShuttleServiceResult
}

struct NUSInternalShuttleServiceResult: Codable {
    let TimeStamp: String
    let name: String
    let caption: String
    let shuttles: [NUSInternalBus]
}

struct NUSInternalBus: Codable, Identifiable {
    let name: String
    let nextArrivalTime: String
    let arrivalTime: String
    let arrivalTime_veh_plate: String
    let _etas: [ETA]
    
    let passengers: String
    let routeid: Int
    let busstopcode: String
    let nextPassengers: String
    let nextArrivalTime_veh_plate: String

    var id: Int { routeid } // Enables use in `List(shuttles)`
}

struct ETA: Codable {
    let plate: String
    let ts: String
    let eta: Int
}
