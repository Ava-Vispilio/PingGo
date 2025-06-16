//
//  NUSActiveBusLineListViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Manages the list of active public bus lines in NUS

//import Foundation
//
//@MainActor
//class NUSActiveBusLineListViewModel: ObservableObject {
//    @Published var availableBusLines: [PublicBusLine] = []
//    @Published var isLoading = false
//    @Published var errorMessage: String? = nil
//
//    private let service = ArriveLahService()
//
//    func loadAvailableLines() async {
//        isLoading = true
//        errorMessage = nil
//
//        guard let url = Bundle.main.url(forResource: "NUSPublicBusStopList", withExtension: "json") else {
//            errorMessage = "Missing NUSPublicBusStopList.json"
//            isLoading = false
//            return
//        }
//
//        do {
//            let data = try Data(contentsOf: url)
//            let rawDictionary = try JSONDecoder().decode([String: [PublicBusStop]].self, from: data)
//
//            let allLines: [PublicBusLine] = rawDictionary.map { key, stops in
//                PublicBusLine(lineName: key.replacingOccurrences(of: "Bus", with: ""), stops: stops)
//            }
//
//            var filteredLines: [PublicBusLine] = []
//
//            await withTaskGroup(of: (PublicBusLine, Bool).self) { group in
//                for line in allLines {
//                    guard let firstStopCode = line.stops.first?.BusStopCode else { continue }
//
//                    group.addTask {
//                        do {
//                            let response: ServicesWrapper = try await self.service.fetchArrivals(for: firstStopCode, as: ServicesWrapper.self)
//                            let isActive = !response.services.isEmpty
//                            print("NUS public line \(line.lineName) is \(isActive ? "active" : "inactive")")
//                            return (line, isActive)
//                        } catch {
//                            print("Error fetching arrivals for NUS LTA line \(line.lineName): \(error)")
//                            return (line, false)
//                        }
//                    }
//                }
//
//                for await (line, isActive) in group {
//                    if isActive {
//                        filteredLines.append(line)
//                    }
//                }
//            }
//
//            availableBusLines = filteredLines.sorted { $0.lineName < $1.lineName }
//
//        } catch {
//            errorMessage = "Failed to load or parse NUS bus stop data: \(error.localizedDescription)"
//        }
//
//        isLoading = false
//    }
//}

import Foundation

@MainActor
class NUSActiveBusLineListViewModel: ObservableObject {
    @Published var publicActiveLines: [PublicBusLine] = []
    @Published var internalActiveLines: [NUSInternalBusRoute] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let arriveLahService = ArriveLahService()
    private let nusApiClient = NUSNextBusService()
    
    func loadAvailableLines() async {
        isLoading = true
        errorMessage = nil
        
        async let publicTask = loadActivePublicLines()
        async let internalTask = loadActiveInternalLines()
        
        do {
            let (publicLines, internalLines) = try await (publicTask, internalTask)
            self.publicActiveLines = publicLines
            self.internalActiveLines = internalLines
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // Load Active Public Lines
    
    private func loadActivePublicLines() async throws -> [PublicBusLine] {
        guard let url = Bundle.main.url(forResource: "NUSPublicBusStopList", withExtension: "json") else {
            throw NSError(domain: "BusTrackerApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing NUSPublicBusStopList.json"])
        }
        
        let data = try Data(contentsOf: url)
        let rawDictionary = try JSONDecoder().decode([String: [PublicBusStop]].self, from: data)
        
        let allLines: [PublicBusLine] = rawDictionary.map { key, stops in
            PublicBusLine(lineName: key.replacingOccurrences(of: "Bus", with: ""), stops: stops)
        }
        
        var filteredLines: [PublicBusLine] = []
        
        await withTaskGroup(of: (PublicBusLine, Bool).self) { group in
            for line in allLines {
                guard let firstStopCode = line.stops.first?.BusStopCode else { continue }
                
                group.addTask {
                    do {
                        let response: ServicesWrapper = try await self.arriveLahService.fetchArrivals(for: firstStopCode, as: ServicesWrapper.self)
                        let isActive = !response.services.isEmpty
                        print("NUS public line \(line.lineName) is \(isActive ? "active" : "inactive")")
                        return (line, isActive)
                    } catch {
                        print("Error fetching public line \(line.lineName): \(error)")
                        return (line, false)
                    }
                }
            }
            
            for await (line, isActive) in group {
                if isActive {
                    filteredLines.append(line)
                }
            }
        }
        
        return filteredLines.sorted { $0.lineName < $1.lineName }
    }
    
    // Load Active Internal Lines
    
    private func loadActiveInternalLines() async throws -> [NUSInternalBusRoute] {
        guard let url = Bundle.main.url(forResource: "NUSInternalBusStopList", withExtension: "json") else {
            throw NSError(domain: "BusTrackerApp", code: 2, userInfo: [NSLocalizedDescriptionKey: "Missing NUSInternalBusStopList.json"])
        }
        
        let data = try Data(contentsOf: url)
        let stopDict = try JSONDecoder().decode([String: [NUSInternalBusStop]].self, from: data)
        
        var activeRoutes: [NUSInternalBusRoute] = []
        
        try await withThrowingTaskGroup(of: (NUSInternalBusRoute, Bool).self) { group in
            for (routeCode, _) in stopDict {
                // Match the routeCode (e.g. "A1") to a known route in the hardcoded list
                guard let route = NUSInternalBusRoute.allRoutes.first(where: { $0.code == routeCode }) else {
                    print("Unknown route code in JSON: \(routeCode)")
                    continue
                }
                
                group.addTask {
                    let activeBusResponse = try await self.nusApiClient.fetchActiveBuses(routeCode: route.code)
                    let isActive = !activeBusResponse.activebus.isEmpty
                    print("NUS internal line \(route.code) is \(isActive ? "active" : "inactive")")
                    return (route, isActive)
                }
            }
            
            for try await (route, isActive) in group {
                if isActive {
                    activeRoutes.append(route)
                }
            }
        }
        
        return activeRoutes.sorted { $0.code < $1.code }
    }
}
