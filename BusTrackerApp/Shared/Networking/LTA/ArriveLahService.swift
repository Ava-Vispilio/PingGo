//
//  Service.swift
//  ArriveLah
//
//  Created by Ava on 8/6/25.
//
//  Services/ArriveLahService.swift - makes API call to local host server

import Foundation

class ArriveLahService {
    func fetchBusArrivals(for LTAbusStopCode: String, completion: @escaping (Result < LTABusArrival, Error>) -> Void) {
        guard let url = URL(string: "http://<IP Address>:3000/?id=\(LTAbusStopCode)") else {
            print("Invalid URL for LTA API")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error for LTA API: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code for LTA API: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print("No data received from LTA API")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(LTABusArrival.self, from: data)
                print("Successfully decoded bus arrivals for LTA stop \(LTAbusStopCode)")
                completion(.success(decodedResponse))
            } catch {
                print("Decoding error for LTA stop \(LTAbusStopCode): \(error.localizedDescription)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON for LTA stop \(LTAbusStopCode):\n\(jsonString)")
                }
                completion(.failure(error))
            }
        }.resume()
    }
}

