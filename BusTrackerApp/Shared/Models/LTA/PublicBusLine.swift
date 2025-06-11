//
//  PublicBusLine.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//


struct PublicBusLine: Identifiable, Codable {
    var id: String { lineName }
    let lineName: String
    let stops: [PublicBusStop]
}
