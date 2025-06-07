//
//  NetworkError.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case badURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Invalid URL"
        case .requestFailed(let error):
            return "Network request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid server response"
        case .decodingFailed(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        }
    }
}
