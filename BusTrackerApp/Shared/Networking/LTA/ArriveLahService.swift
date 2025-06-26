//
//  ArriveLahService.swift
//  BusTrackerApp
//
//  Created by Ava on 8/6/25.
//
// Handles API calls to localhost server

import Foundation

class ArriveLahService {
    func fetchArrivals<T: Decodable>(for stopCode: String, as type: T.Type) async throws -> T {
        guard let url = URL(string: "\(APIConstants.arriveLahBaseURL)/?id=\(stopCode)") else {
            print("Invalid URL for ArriveLah API: \(APIConstants.arriveLahBaseURL)/?id=\(stopCode)")
            throw NetworkError.badURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code for ArriveLah API: \(httpResponse.statusCode)")
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                print("Successfully decoded arrivals for stop \(stopCode)")
                return decoded
            } catch {
                print("Decoding error for stop \(stopCode): \(error.localizedDescription)")
                if let rawJSON = String(data: data, encoding: .utf8) {
                    print("Raw JSON Response:\n\(rawJSON)")
                }
                throw NetworkError.decodingFailed(error)
            }
        } catch {
            print("Network request failed for stop \(stopCode): \(error.localizedDescription)")
            throw NetworkError.requestFailed(error)
        }
    }
}
