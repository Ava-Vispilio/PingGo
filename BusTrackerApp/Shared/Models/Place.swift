//
//  Place.swift
//  BusTrackerApp
//
//  Created by Ava on 6/6/25.
//
import Foundation
import CoreLocation

struct PlacesResponse: Codable {
    let results: [Place]
}

struct Place: Codable, Identifiable {
    let place_id: String
    let name: String
    let geometry: PlaceGeometry

    var id: String { place_id }

    var coordinate: CLLocationCoordinate2D {
//        Coordinate(latitude: placeGeometry.location.lat, longitude: placeGeometry.location.lng)
        CLLocationCoordinate2D(latitude: geometry.location.lat, longitude: geometry.location.lng)

    }
}

struct PlaceGeometry: Codable {
    let location: PlaceLocation
}

struct PlaceLocation: Codable {
    let lat: Double
    let lng: Double
}
