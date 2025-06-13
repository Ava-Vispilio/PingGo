//
//  NUSBusAPIClient.swift
//  BusTrackerApp
//
//  Created by Ava on 12/6/25.
//
// Handles API authentication and calls

// functions to authenticate and query the API with
import Foundation

class NUSNextBusService {
    static let shared = NUSNextBusService()
    
    private func makeRequest(endpoint: String) -> URLRequest? {
        guard let url = URL(string: "\(APIConstants.NUSAPIBaseURL)\(endpoint)") else { return nil }
        var request = URLRequest(url: url)
        let authString = "\(APIConstants.NUSAPIUsername):\(APIConstants.NUSAPIPassword)"    // authentication
        let authData = Data(authString.utf8).base64EncodedString()
        request.setValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchArrivalInfo(busStopName: String, completion: @escaping (Result<ShuttleServiceResult, Error>) -> Void) {
        guard let request = makeRequest(endpoint: "/ShuttleService?busstopname=\(busStopName)") else { return }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { return completion(.failure(error)) }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(ShuttleServiceResponse.self, from: data)
                completion(.success(decoded.ShuttleServiceResult))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchActiveBuses(routeCode: String, completion: @escaping (Result<ActiveBusResponse, Error>) -> Void) {
        guard let request = makeRequest(endpoint: "/ActiveBus?route_code=\(routeCode)") else {
            completion(.failure(NSError(domain: "NUS API Invalid URL", code: -1)))
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let data = data else {
                return completion(.failure(NSError(domain: "No data", code: -1)))
            }

            // Check for plain text error like "Service not found!"
            if let rawString = String(data: data, encoding: .utf8), rawString.contains("Service not found") {
                return completion(.failure(NSError(domain: "Service not found!", code: 404)))
            }

            do {
                let decoded = try JSONDecoder().decode(ActiveBusResponseWrapper.self, from: data)
                completion(.success(decoded.ActiveBusResult))
            } catch {
                print("Decoding failed with error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
