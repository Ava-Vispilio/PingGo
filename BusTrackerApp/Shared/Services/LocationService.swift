//
//  LocationService.swift
//  BusTrackerApp
//
//  Created by Ava on 4/6/25.
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: Error?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
    }

//    /// Only called manually by user tap (e.g. "Refresh Location" button)
//    func requestLocationUpdate() {
//        print("Requesting location update.")
//        switch authorizationStatus {
//        case .authorizedAlways, .authorizedWhenInUse:
//            print("Permission granted. Requesting location.")
//            locationManager.requestLocation()
//        case .notDetermined:
//            print("Permission not determined. Requesting access.")
//            requestLocationAccess()
//        default:
//            print("Location access denied or restricted.")
//        }
//    }
    func requestLocationUpdate() {
        print("Requesting location update.")
        
        let status = locationManager.authorizationStatus // <-- use this instead
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Permission granted. Requesting location.")
            locationManager.requestLocation()
        case .notDetermined:
            print("Permission not determined. Requesting access.")
            requestLocationAccess()
        default:
            print("Location access denied or restricted.")
        }
    }


    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        authorizationStatus = status
        print("Authorization changed to: \(status.rawValue)")
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        authorizationStatus = status
//        // Do NOT automatically start updating here
//        print("Authorization changed to: \(status.rawValue)t")
//    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            currentLocation = location
        } else {
            print("No location found.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error
        print("Location update failed: \(error.localizedDescription)")
    }
}
