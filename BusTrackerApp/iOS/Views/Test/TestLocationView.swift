//
//  TestLocationView.swift
//  BusTrackerApp
//
//  Created by Ava on 5/6/25.
//

import SwiftUI
import CoreLocation

struct TestLocationView: View {
    @StateObject private var locationService = LocationService.shared

    var body: some View {
        VStack(spacing: 20) {
            Text("📍 Location Tester")
                .font(.title2)
                .bold()

            if let location = locationService.currentLocation {
                Text("Latitude: \(location.coordinate.latitude)")
                Text("Longitude: \(location.coordinate.longitude)")
            } else {
                Text("Location not available")
                    .foregroundStyle(.red)
            }

            if let error = locationService.locationError {
                Text("Error: \(error.localizedDescription)")
                    .foregroundStyle(.red)
            }

            Button("Request Location Access") {
                locationService.requestLocationAccess()
            }

            Button("Refresh Location") {
                locationService.requestLocationUpdate()
            }

            Button("Open Location Settings") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        }
//        VStack(spacing: 20) {
//            Text("Auth: \(locationService.authorizationStatus.rawValue)")
//            Text("Lat: \(locationService.currentLocation?.coordinate.latitude ?? 0)")
//            Text("Long: \(locationService.currentLocation?.coordinate.longitude ?? 0)")
//            Button("Get Location") {
//                locationService.requestLocationUpdate()
//            }
//        }

        .padding()
        .onChange(of: locationService.authorizationStatus) { _, newStatus in
            if newStatus == .authorizedWhenInUse || newStatus == .authorizedAlways {
                locationService.requestLocationUpdate()
            }
        }
    }
}
