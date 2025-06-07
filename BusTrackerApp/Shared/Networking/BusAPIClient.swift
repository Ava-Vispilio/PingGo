// Shared/Networking/BusAPIClient.swift
// Provides functions for all API calls.

import Foundation

struct BusAPIClient {
    static let shared = BusAPIClient()
    private init() {}  // Singleton
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    // Fetch bus line information (e.g. blueBus)
    func fetchBusLineInfo(for color: String) async throws -> BusLineResponse {
        let url = Endpoint.lineInfo(color: color).url
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let result = try decoder.decode(BusLineResponse.self, from: data)
            print("Raw data for \(color):", String(data: data, encoding: .utf8) ?? "No Data")
            return result
        } catch {
            print("Decoding failed for \(color):", String(data: data, encoding: .utf8) ?? "No Data")
            throw NetworkError.decodingFailed(error)
        }
    }
    
    // Convenience overload to support enum
    func fetchBusLineInfo(for route: BusRouteColor) async throws -> BusLineResponse {
        try await fetchBusLineInfo(for: route.rawValue)
    }
    
    // Fetch bus stop details.
    func fetchBusStopDetails() async throws -> BusStopDetailsResponse {
        let url = Endpoint.busStopDetails.url
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let result = try decoder.decode(BusStopDetailsResponse.self, from: data)
            return result
        } catch {
            print("Decoding failed for bus stop details:", String(data: data, encoding: .utf8) ?? "No Data")
            throw NetworkError.decodingFailed(error)
        }
    }
    
    // Fetch bus arrival for a given bus stop.
    func fetchBusArrival(for busStopId: String) async throws -> BusArrivalResponse {
        let url = Endpoint.busArrival(busStopId: busStopId).url
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let result = try decoder.decode(BusArrivalResponse.self, from: data)
            return result
        } catch {
            print("Decoding failed for bus arrival (\(busStopId)):", String(data: data, encoding: .utf8) ?? "No Data")
            throw NetworkError.decodingFailed(error)
        }
    }
}

extension BusAPIClient {
    // Fetch stops for a specific bus route color
    func fetchStops(for line: BusRouteColor) async throws -> [BusStop] {
        let response = try await fetchBusStopDetails()
        
        // Keys are like "blueBus", "redBus", etc.
        let key = "\(line.rawValue)Bus"
        
        return response.busStopDetails[key] ?? []
    }
}

