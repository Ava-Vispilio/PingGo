//
//  LineActivityWrapper.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 12/6/25.
//
// Checks for active LTA bus services

import Foundation

// Minimal response from ArriveLah used for just checking if any bus service is active
struct ServicesWrapper: Decodable {
    let services: [BusService]
}

struct BusService: Decodable {
    let no: String
}
