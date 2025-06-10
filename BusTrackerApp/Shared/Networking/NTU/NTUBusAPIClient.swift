// Shared/Networking/BusAPIClient.swift
// Provides functions for all API calls.

import Foundation

struct NTUBusAPIClient {
    static let shared = NTUBusAPIClient()
    private init() {}  // Singleton
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    // Fetch bus line information (e.g. blueBus)
    func fetchBusLineInfo(for color: String) async throws -> NTUBusLineResponse {
        let url = NTUEndpoint.lineInfo(color: color).url
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let result = try decoder.decode(NTUBusLineResponse.self, from: data)
            print("Raw data for NTU \(color):", String(data: data, encoding: .utf8) ?? "No Data")
            return result
        } catch {
            print("Decoding failed for NTU \(color):", String(data: data, encoding: .utf8) ?? "No Data")
            throw NetworkError.decodingFailed(error)
        }
    }
    
    // Convenience overload to support enum
    func fetchBusLineInfo(for route: BusRouteColor) async throws -> NTUBusLineResponse {
        try await fetchBusLineInfo(for: route.rawValue)
    }
    
    // Fetch bus stop details
    func fetchBusStopDetails() async throws -> NTUBusStopDetailsResponse {
        let url = NTUEndpoint.busStopDetails.url
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let result = try decoder.decode(NTUBusStopDetailsResponse.self, from: data)
            return result
        } catch {
            print("Decoding failed for NTU bus stop details:", String(data: data, encoding: .utf8) ?? "No Data")
            throw NetworkError.decodingFailed(error)
        }
    }
    
    // Fetch bus arrival for a given bus stop
    func fetchBusArrival(for busStopId: String) async throws -> NTUBusArrivalResponse {
        let url = NTUEndpoint.busArrival(busStopId: busStopId).url
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let result = try decoder.decode(NTUBusArrivalResponse.self, from: data)
            return result
        } catch {
            print("Decoding failed for NTU bus arrival (\(busStopId)):", String(data: data, encoding: .utf8) ?? "No Data")
            throw NetworkError.decodingFailed(error)
        }
    }
}

extension NTUBusAPIClient {
    // Fetch stops for a specific bus route color
    func fetchStops(for line: BusRouteColor) async throws -> [NTUInternalBusStop] {
        let response = try await fetchBusStopDetails()
        
        // Keys are like "blueBus", "redBus", etc.
        let key = "\(line.rawValue)Bus"
        
        return response.busStopDetails[key] ?? []
    }
}
