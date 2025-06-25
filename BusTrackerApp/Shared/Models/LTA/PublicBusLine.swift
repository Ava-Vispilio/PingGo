//
//  PublicBusLine.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Model for public (LTA) bus lines


struct PublicBusLine: Identifiable, Codable {
    var id: String { lineName }
    let lineName: String
    let stops: [PublicBusStop]
}
