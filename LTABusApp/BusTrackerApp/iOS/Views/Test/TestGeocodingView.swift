//
//  TestGeocodingView.swift
//  BusTrackerApp
//
//  Created by Ava on 5/6/25.
//

import SwiftUI
import CoreLocation

struct GeocodeTestView: View {
    @State private var address: String = ""
    @State private var resultText: String = "Enter an address"

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter address", text: $address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit {
                    geocode()
                }

            Button("Geocode Address") {
                geocode()
            }

            Text(resultText)
                .padding()
        }
        .padding()
    }

    func geocode() {
        resultText = "Geocoding..."
        GoogleGeocodingService.shared.geocodeAddress(address) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coordinate):
                    resultText = "Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)"
                case .failure(let error):
                    resultText = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}
