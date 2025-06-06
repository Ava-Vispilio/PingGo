//
//  GoogleGeocodingService.swift
//  BusTrackerApp
//
//  Created by Ava on 4/6/25.
//

import Foundation
import CoreLocation

func getAPIKey() -> String? {
    guard let path = Bundle.main.path(forResource: "GoogleAPIKey", ofType: "plist"),
          let xml = FileManager.default.contents(atPath: path),
          let apiKeyDict = try? PropertyListSerialization.propertyList(from: xml, options: [], format: nil) as? [String: Any] else {
        print("API Key file not found or unreadable")
        return nil
    }
    let key = apiKeyDict["API_KEY"] as? String
    print("Loaded API Key: \(String(describing: key))")
    return key
}

class GoogleGeocodingService {
    static let shared = GoogleGeocodingService()
    private init() {}

    private let apiKey = getAPIKey() // Get API Key

    func geocodeAddress(_ address: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? address
        guard let apiKey = apiKey else {
            completion(.failure(NSError(domain: "API Key missing", code: -2)))
            return
        }

        guard let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(encodedAddress)&key=\(apiKey)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        print("Geocoding URL: \(url.absoluteString)")

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data returned")
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            print("Raw Response:")
            print(String(data: data, encoding: .utf8) ?? "No string")

            do {
                let decoded = try JSONDecoder().decode(GeocodingResponse.self, from: data)
                if let location = decoded.results.first?.geoGeometry.location {
                    let coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
                    completion(.success(coordinate))
                } else {
                    let jsonString = String(data: data, encoding: .utf8) ?? "No data string"
                    print("Geocoding failed: \(jsonString)")
                    completion(.failure(NSError(domain: "No results found", code: -1)))
                }
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

struct GeocodingResponse: Codable {
    let results: [GeocodingResult]
}

struct GeocodingResult: Codable {
    let geoGeometry: GeoGeometry
}

struct GeoGeometry: Codable {
    let location: GeoLocation
}

struct GeoLocation: Codable {
    let lat: Double
    let lng: Double
}
