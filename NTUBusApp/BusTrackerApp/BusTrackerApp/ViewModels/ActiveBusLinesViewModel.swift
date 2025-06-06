//
//  ActiveBusLinesViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//


import Foundation

@MainActor
class ActiveBusLinesViewModel: ObservableObject {
    @Published var activeLines: [BusRouteColor] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let apiClient: BusAPIClient
    
    init(apiClient: BusAPIClient = .shared) {
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
                        print("Fetching line info for: \(color.rawValue)")
                        let response = try await self.apiClient.fetchBusLineInfo(for: color)
                        
                        let isActive = !response.bus.vehicles.isEmpty
                        print("Received \(response.bus.name) for \(color.rawValue): \(isActive ? "active" : "inactive")")
                        
                        return (color, isActive)
                    } catch {
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
        print("Final active lines: \(activeLines.map {$0.rawValue })")
        isLoading = false
    }
}
