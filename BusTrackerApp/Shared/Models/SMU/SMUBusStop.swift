//
//  SMUBusStop.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Model for SMU (public) bus stops

struct SMUPublicBusStop: Codable, Identifiable {
    var id: String { BusStopCode }
    let BusStopCode: String
    let RoadName: String
    let Description: String
    let Latitude: Double
    let Longitude: Double
}
