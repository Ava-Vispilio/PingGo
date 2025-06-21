//
//  NTUInternalBusStopArrivalViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//  Updated for NTU-specific stop arrival logic
//
// Fetches internal bus arrivals and handles notification logic for NTU's internal buses (including when to notify user of bus arrival)

//import Foundation
//
//@MainActor
//class NTUInternalBusStopArrivalViewModel: ObservableObject {
//    @Published var stopName: String = ""
//    @Published var arrivalTimes: [NTUInternalBusArrivalTime] = []
//    @Published var notifyWhenSoon: Bool = false
//    @Published var notificationLeadTime: Int = 1 // Default to 1 minute before arrival
//    @Published var isLoading = false
//    @Published var errorMessage: String? = nil
//
//    private let apiClient: NTUBusAPIClient
//    private let notificationManager = NotificationManager.shared
//    private var stopId: String?
//
//    init(apiClient: NTUBusAPIClient = .shared) {
//        self.apiClient = apiClient
//    }
//
//    func fetchArrivalTimes(for stopId: String) async {
//        self.stopId = stopId
//        isLoading = true
//        errorMessage = nil
//        do {
//            let response = try await apiClient.fetchBusArrival(for: stopId)
//            let busArrival = response.busArrival
//            stopName = busArrival.name
//            arrivalTimes = busArrival.forecasts.sorted { $0.minutes < $1.minutes }
//        } catch {
//            errorMessage = error.localizedDescription   // to standaridise error msg displayed
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

import Foundation
import UserNotifications

@MainActor
class NTUInternalBusStopArrivalViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var arrivalTimes: [ArrivalTime] = []
    @Published var errorMessage: String?

    @Published var notifyWhenSoon = false {
        didSet {
            saveNotifyWhenSoonEnabledState()
            if !notifyWhenSoon {
                cancelNotification()
            } else {
                scheduleNotificationIfNeeded()
            }
        }
    }
    @Published var notificationLeadTime: Int = 1 {
        didSet {
            // Cap lead time to first arrival's minutes
            saveNotificationLeadTime()
            if let first = arrivalTimes.first?.minutes, notificationLeadTime > first {
                notificationLeadTime = first
            }
            scheduleNotificationIfNeeded()
        }
    }
    @Published var showScrollWheel = false

    var stopName: String = ""
    
    private(set) var busStopId: String
    
    init(busStopId: String) {
        self.busStopId = busStopId
    }
    
    private var notifyEnabledKey: String {
        "NTU_notifyEnabled_\(busStopId)"
    }

    private var notifyMinutesKey: String {
        "NTU_notifyMinutes_\(busStopId)"
    }

    private func saveNotifyWhenSoonEnabledState() {
        UserDefaults.standard.set(notifyWhenSoon, forKey: notifyEnabledKey)
    }

    private func saveNotificationLeadTime() {
        UserDefaults.standard.set(notificationLeadTime, forKey: notifyMinutesKey)
    }

    private func restoreSavedSettings() {
        notifyWhenSoon = UserDefaults.standard.bool(forKey: notifyEnabledKey)

        let savedMinutes = UserDefaults.standard.integer(forKey: notifyMinutesKey)
        notificationLeadTime = savedMinutes > 0 ? savedMinutes : 3
    }
    
    struct ArrivalTime: Hashable {
        let minutes: Int
    }

    func fetchArrivalTimes(for busStopId: String) async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil

        // Dummy fetch logic - replace with your real fetch here
        // Simulate arrivals for demo
        await Task.sleep(1_000_000_000) // 1 second delay

        // Example static data
        arrivalTimes = [ArrivalTime(minutes: 5), ArrivalTime(minutes: 12), ArrivalTime(minutes: 20)]

        // Example stop name
        stopName = "Example Stop"

        // Adjust notification lead time if needed
        if let first = arrivalTimes.first?.minutes, notificationLeadTime > first {
            notificationLeadTime = first
        }

        scheduleNotificationIfNeeded()
    }

    private func scheduleNotificationIfNeeded() {
        guard notifyWhenSoon,
              let firstArrival = arrivalTimes.first?.minutes,
              notificationLeadTime > 0,
              notificationLeadTime < firstArrival else {
            cancelNotification()
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Bus arriving soon"
        content.body = "Arriving at \(stopName) in \(notificationLeadTime) min"
        content.sound = .default

        let interval = TimeInterval((firstArrival - notificationLeadTime) * 60)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "bus-\(stopName)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    private func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["bus-\(stopName)"])
    }

    func toggleNotification(_ enabled: Bool) {
        notifyWhenSoon = enabled
    }

    func rescheduleNotificationIfNeeded() {
        if notifyWhenSoon {
            scheduleNotificationIfNeeded()
        }
    }

//    func onDisappear() {
//        notifyWhenSoon = false
//        cancelNotification()
//    }
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
//        do {
//            let response = try await apiClient.fetchBusArrival(for: stopId)
//            let busArrival = response.busArrival
//            stopName = busArrival.name
//            arrivalTimes = busArrival.forecasts.sorted { $0.minutes < $1.minutes }
//        }
//        do {
//            let response = try await apiClient.fetchBusArrival(for: stopId)
//            let busArrival = response.busArrival
//            stopName = busArrival.name
//        
//            // Convert forecasts to display items with UUIDs
//          arrivalTimes = busArrival.forecasts.map { forecast in
//                BusArrivalDisplayItem(minutes: forecast.minutes)
//            }.sorted { $0.minutes < $1.minutes }
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
