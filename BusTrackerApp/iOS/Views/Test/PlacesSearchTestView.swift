//
//  PlacesSearchTestView.swift
//  BusTrackerApp
//
//  Created by Ava on 6/6/25.
//

import SwiftUI
import CoreLocation

struct PlacesSearchTestView: View {
    @State private var coordinate = CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198) // Singapore default
    @State private var radius: Double = 250
    @State private var keyword: String = "bus stop"
    @State private var places: [Place] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Coordinate Inputs
                TextField("Latitude", value: $coordinate.latitude, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Longitude", value: $coordinate.longitude, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // Keyword Input
                TextField("Keyword", text: $keyword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // Search Button
                Button("Search Nearby Places") {
                    PlacesAPIService.shared.fetchNearbyBusStops(location: coordinate, radius: radius) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let fetchedPlaces):
                                self.places = fetchedPlaces
                                self.errorMessage = nil
                            case .failure(let error):
                                self.errorMessage = error.localizedDescription
                                self.places = []
                            }
                        }
                    }
                }

                // Show error if any
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }

                // Buggy Results List -> so I can't build/test that this API is working
                List {
                    ForEach(places, id: \.place_id) { place in // I have no idea why there's an error here
                        VStack(alignment: .leading) {
                            Text(place.name)    // and another 2 here,, and chatgpt can't seem to get it either
                                .font(.headline)
                            Text("Lat: \(place.geometry.location.lat), Lng: \(place.geometry.location.lng)")
                                .font(.subheadline)
                        }
                    }
                }

            }
            .padding()
            .navigationTitle("Nearby Places")
        }
    }
}
