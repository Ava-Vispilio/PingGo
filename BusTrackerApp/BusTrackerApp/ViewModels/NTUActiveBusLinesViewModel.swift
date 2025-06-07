//
//  NTUActiveBusLinesViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//  Refactored to use generic BusRouteColor with NTU-specific client.
//

import Foundation

@MainActor
class NTUActiveBusLinesViewModel: ObservableObject {
    @Published var activeLines: [BusRouteColor] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let apiClient: NTUBusAPIClient
    
    init(apiClient: NTUBusAPIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func fetchActiveLines() async {
        isLoading = true
        errorMessage = nil
        
        let allLines = BusRouteColor.allCases
        var foundActiveLines: [BusRouteColor] = []
        
        await withTaskGroup(of: (BusRouteColor, Bool).self) { group in
            for color in allLines {
                group.addTask {
                    do {
                        print("Fetching NTU line info for: \(color.rawValue)")
                        let response = try await self.apiClient.fetchBusLineInfo(for: color)
                        
                        let isActive = !response.bus.vehicles.isEmpty
                        print("Received \(response.bus.name) for NTU \(color.rawValue): \(isActive ? "active" : "inactive")")
                        
                        return (color, isActive)
                    } catch {
                        print("Error fetching NTU line \(color.rawValue): \(error.localizedDescription)")
                        return (color, false)
                    }
                }
            }
            
            for await (color, isActive) in group {
                if isActive {
                    foundActiveLines.append(color)
                }
            }
        }
        
        self.activeLines = foundActiveLines.sorted { $0.rawValue < $1.rawValue }
        print("Final active NTU lines: \(activeLines.map { $0.rawValue })")
        isLoading = false
    }
}
