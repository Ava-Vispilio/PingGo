//
//  Coordinate.swift
//  BusTrackerApp
//
//  Created by Ava on 4/6/25.
//

import Foundation
import CoreLocation

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double

    var clLocationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(from clLocation: CLLocationCoordinate2D) {
        self.latitude = clLocation.latitude
        self.longitude = clLocation.longitude
    }
}
