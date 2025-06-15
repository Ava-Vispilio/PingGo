//
//  NTUInternalBusStopArrivalViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//  Updated for NTU-specific stop arrival logic
//
// Fetches internal bus arrivals and handles notification logic for NTU's internal buses (including when to notify user of bus arrival)

import Foundation

@MainActor
class NTUInternalBusStopArrivalViewModel: ObservableObject {
    @Published var stopName: String = ""
    @Published var arrivalTimes: [NTUInternalBusArrivalTime] = []
    @Published var notifyWhenSoon: Bool = false
    @Published var notificationLeadTime: Int = 1 // Default to 1 minute before arrival
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let apiClient: NTUBusAPIClient
    private let notificationManager = NotificationManager.shared
    private var stopId: String?

    init(apiClient: NTUBusAPIClient = .shared) {
        self.apiClient = apiClient
    }

    func fetchArrivalTimes(for stopId: String) async {
        self.stopId = stopId
        isLoading = true
        errorMessage = nil
        do {
            let response = try await apiClient.fetchBusArrival(for: stopId)
            let busArrival = response.busArrival
            stopName = busArrival.name
            arrivalTimes = busArrival.forecasts.sorted { $0.minutes < $1.minutes }
        } catch {
            errorMessage = error.localizedDescription   // to standaridise error msg displayed
        }
        isLoading = false
    }

    func toggleNotification(_ enabled: Bool) {
        notifyWhenSoon = enabled

        guard let stopId = stopId else { return }
        let notificationId = "ntu_bus_arrival_\(stopId)"

        if enabled {
            scheduleNotification(id: notificationId)
        } else {
            notificationManager.cancelNotification(id: notificationId)
        }
    }

    func scheduleNotification(id: String) {
        guard let soonest = arrivalTimes.first else {
            errorMessage = "No arrival times to notify about."
            notifyWhenSoon = false
            return
        }

        let timeUntilArrival = soonest.minutes
        let leadTime = notificationLeadTime
        let secondsBefore = max((timeUntilArrival - leadTime), 0) * 60

        // Only schedule if secondsBefore > 0
        guard secondsBefore > 0 else {
            errorMessage = "Too late to notify."
            notifyWhenSoon = false
            return
        }

        notificationManager.scheduleNotification(
            id: id,
            title: "Bus arriving soon!",
            body: "Your bus at \(stopName) is arriving in \(leadTime) minutes.",
            after: secondsBefore
        )
    }

    func rescheduleNotificationIfNeeded() {
        guard notifyWhenSoon, let stopId = stopId else { return }
        let notificationId = "ntu_bus_arrival_\(stopId)"
        notificationManager.cancelNotification(id: notificationId)
        scheduleNotification(id: notificationId)
    }

    func onDisappear() {
        guard let stopId = stopId else { return }
        let notificationId = "ntu_bus_arrival_\(stopId)"
        notificationManager.cancelNotification(id: notificationId)
    }
}

// Edited this so it cld work with the edited view and models
//import Foundation
//
//@MainActor
//class NTUInternalBusStopArrivalViewModel: ObservableObject {
//    @Published var stopName: String = ""
//    @Published var arrivalTimes: [BusArrivalDisplayItem] = []
//    @Published var notifyWhenSoon: Bool = false
//    @Published var notificationLeadTime: Int = 1 // Default to 1 minute before arrival
//    @Published var isLoading = false
//    @Published var errorMessage: String? = nil
//
//    private let apiClient: NTUBusAPIClient
//    private let notificationManager = NotificationManager.shared
//    private var stopId: String?
//    
//    struct BusArrivalDisplayItem: Identifiable {
//        let id = UUID()
//        let minutes: Int //ETA in minutes
//        let receivedTime = Date()
//        
//        var asLegacyType: NTUInternalBusArrivalTime {
//            NTUInternalBusArrivalTime(minutes: minutes)
//        }
//    }
//
//    init(apiClient: NTUBusAPIClient = .shared) {
//        self.apiClient = apiClient
//    }
//
//    func fetchArrivalTimes(for stopId: String) async {
//        self.stopId = stopId
//        isLoading = true
//        errorMessage = nil
////        do {
////            let response = try await apiClient.fetchBusArrival(for: stopId)
////            let busArrival = response.busArrival
////            stopName = busArrival.name
////            arrivalTimes = busArrival.forecasts.sorted { $0.minutes < $1.minutes }
////        }
//        do {
//            let response = try await apiClient.fetchBusArrival(for: stopId)
//            let busArrival = response.busArrival
//            stopName = busArrival.name
//        
//            // Convert forecasts to display items with UUIDs
////            arrivalTimes = busArrival.forecasts.map { forecast in
////                BusArrivalDisplayItem(minutes: forecast.minutes)
////            }.sorted { $0.minutes < $1.minutes }
//            arrivalTimes = busArrival.forecasts.map {
//                BusArrivalDisplayItem(minutes: $0.minutes)
//            }.sorted { $0.minutes < $1.minutes }
//                    
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//        isLoading = false
//    }
//
//    func toggleNotification(_ enabled: Bool) {
//        notifyWhenSoon = enabled
//
//        guard let stopId = stopId else { return }
//        let notificationId = "ntu_bus_arrival_\(stopId)"
//
//        if enabled {
//            scheduleNotification(id: notificationId)
//        } else {
//            notificationManager.cancelNotification(id: notificationId)
//        }
//    }
//
//    func scheduleNotification(id: String) {
//        guard let soonest = arrivalTimes.first else {
//            errorMessage = "No arrival times to notify about."
//            notifyWhenSoon = false
//            return
//        }
//
//        let timeUntilArrival = soonest.minutes
//        let leadTime = notificationLeadTime
//        let secondsBefore = max((timeUntilArrival - leadTime), 0) * 60
//
//        // Only schedule if secondsBefore > 0
//        guard secondsBefore > 0 else {
//            errorMessage = "Too late to notify."
//            notifyWhenSoon = false
//            return
//        }
//
//        notificationManager.scheduleNotification(
//            id: id,
//            title: "Bus arriving soon!",
//            body: "Your bus at \(stopName) is arriving in \(leadTime) minutes.",
//            after: secondsBefore
//        )
//    }
//
//    func rescheduleNotificationIfNeeded() {
//        guard notifyWhenSoon, let stopId = stopId else { return }
//        let notificationId = "ntu_bus_arrival_\(stopId)"
//        notificationManager.cancelNotification(id: notificationId)
//        scheduleNotification(id: notificationId)
//    }
//
//    func onDisappear() {
//        guard let stopId = stopId else { return }
//        let notificationId = "ntu_bus_arrival_\(stopId)"
//        notificationManager.cancelNotification(id: notificationId)
//    }
//}
