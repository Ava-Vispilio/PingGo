//
//  NUSNextBusService.swift
//  BusTrackerApp
//
//  Created by Ava on 12/6/25.
//
// Handles API authentication and calls

// Functions to authenticate and query the API with

//import Foundation
//
//class NUSNextBusService {
//    static let shared = NUSNextBusService()
//    
//    private func makeRequest(endpoint: String) -> URLRequest? {
//        guard let url = URL(string: "\(APIConstants.NUSAPIBaseURL)\(endpoint)") else { return nil }
//        var request = URLRequest(url: url)
//        let authString = "\(APIConstants.NUSAPIUsername):\(APIConstants.NUSAPIPassword)"    // authentication
//        let authData = Data(authString.utf8).base64EncodedString()
//        request.setValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
//        return request
//    }
//    
//    func fetchArrivalInfo(busStopName: String, completion: @escaping (Result<NUSInternalShuttleServiceResult, Error>) -> Void) {
//        guard let request = makeRequest(endpoint: "/ShuttleService?busstopname=\(busStopName)") else { return }
//        
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            if let error = error { return completion(.failure(error)) }
//            guard let data = data else { return }
//            do {
//                let decoded = try JSONDecoder().decode(NUSInternalShuttleServiceResponse.self, from: data)
//                completion(.success(decoded.ShuttleServiceResult))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//    
//    func fetchActiveBuses(routeCode: String, completion: @escaping (Result<NUSInternalActiveBusResponse, Error>) -> Void) {
//        guard let request = makeRequest(endpoint: "/ActiveBus?route_code=\(routeCode)") else {
//            completion(.failure(NSError(domain: "NUS API Invalid URL", code: -1)))
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            if let error = error {
//                return completion(.failure(error))
//            }
//
//            guard let data = data else {
//                return completion(.failure(NSError(domain: "No data", code: -1)))
//            }
//
//            // Check for plain text error like "Service not found!"
//            if let rawString = String(data: data, encoding: .utf8), rawString.contains("Service not found") {
//                return completion(.failure(NSError(domain: "Service not found!", code: 404)))
//            }
//
//            do {
//                let decoded = try JSONDecoder().decode(NUSInternalActiveBusResponseWrapper.self, from: data)
//                completion(.success(decoded.ActiveBusResult))
//            } catch {
//                print("Decoding failed with error: \(error)")
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}

import Foundation

class NUSNextBusService {
    static let shared = NUSNextBusService()
    
    private func makeRequest(endpoint: String) -> URLRequest? {
        guard let url = URL(string: "\(APIConstants.NUSAPIBaseURL)\(endpoint)") else {
            print("Invalid URL for endpoint: \(endpoint)")
            return nil
        }
        var request = URLRequest(url: url)
        let authString = "\(APIConstants.NUSAPIUsername):\(APIConstants.NUSAPIPassword)"
        let authData = Data(authString.utf8).base64EncodedString()
        request.setValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    // Async version for fetching shuttle arrival info
    func fetchArrivalInfo(busStopName: String) async throws -> NUSInternalShuttleServiceResult {
        let endpoint = "/ShuttleService?busstopname=\(busStopName)"
        print("Fetching shuttle arrival info from endpoint: \(endpoint)")
        
        guard let request = makeRequest(endpoint: endpoint) else {
            throw NSError(domain: "NUS API Invalid URL", code: -1)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Shuttle arrival info response status code: \(httpResponse.statusCode)")
        }
        
        // Optional: print raw response for debug
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw shuttle arrival response JSON:\n\(jsonString)")
        }
        
        do {
            // Parse and filter out "PUB:" buses
            var jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if var shuttleService = jsonObject?["ShuttleServiceResult"] as? [String: Any],
               var shuttles = shuttleService["shuttles"] as? [[String: Any]] {
                
                shuttles.removeAll { ($0["name"] as? String)?.hasPrefix("PUB:") == true }
                
                shuttleService["shuttles"] = shuttles
                jsonObject?["ShuttleServiceResult"] = shuttleService
            }
            
            let filteredData = try JSONSerialization.data(withJSONObject: jsonObject ?? [:])
            let decoded = try JSONDecoder().decode(NUSInternalShuttleServiceResponse.self, from: filteredData)
            return decoded.ShuttleServiceResult
            
        } catch {
            print("JSON Decoding error: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Offending JSON:\n\(jsonString)")
            }
            throw error
        }
    }
    
    // Async version for fetching active buses on a route
    func fetchActiveBuses(routeCode: String) async throws -> NUSInternalActiveBusResponse {
        let urlString = "https://nextbus.nus.edu.sg/service/\(routeCode)"
        print("Fetching internal bus from: \(urlString)")

        let endpoint = "/ActiveBus?route_code=\(routeCode)"
        
        guard let request = makeRequest(endpoint: endpoint) else {
            throw NSError(domain: "NUS API Invalid URL", code: -1)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("Active bus API response status code for \(routeCode): \(httpResponse.statusCode)")
        }

        if let rawString = String(data: data, encoding: .utf8), rawString.contains("Service not found") {
            print("Received 'Service not found' response for route: \(routeCode)")
            throw NSError(domain: "Service not found!", code: 404)
        }

        let decoded = try JSONDecoder().decode(NUSInternalActiveBusResponseWrapper.self, from: data)
        return decoded.ActiveBusResult
    }
}
