//
//  Service.swift
//  ArriveLah
//
//  Created by Ava on 8/6/25.
//

// Services/ArriveLahService.swift - makes API call to local host server

import Foundation

class ArriveLahService {
    func fetchBusArrivals(for busStopCode: String, completion: @escaping (Result<BusArrivalResponse, Error>) -> Void) {
        guard let url = URL(string: "http://<IP Address>:3000/?id=\(busStopCode)") else {   // Enter IP Address here!
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(BusArrivalResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
