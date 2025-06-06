//
//  PlacesAPIService.swift
//  BusTrackerApp
//
//  Created by Ava on 4/6/25.
//


import Foundation
import CoreLocation

class PlacesAPIService {
    static let shared = PlacesAPIService()
    private init() {}

    private let apiKey = getAPIKey() // Reuses getAPIKey() function

    func fetchNearbyBusStops(location: CLLocationCoordinate2D, radius: Double = 250, completion: @escaping (Result<[Place], Error>) -> Void) { //250m search radius
        guard let apiKey = apiKey else {
            completion(.failure(NSError(domain: "API key missing", code: -1)))
            return
        }

        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.latitude),\(location.longitude)&radius=\(radius)&keyword=bus+stop&type=transit_station&key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(PlacesResponse.self, from: data)
                completion(.success(decoded.results))
            } catch {
                print("Decoding error: \(error)")
                let jsonString = String(data: data, encoding: .utf8) ?? "No data string"
                print("Full JSON: \(jsonString)")
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
