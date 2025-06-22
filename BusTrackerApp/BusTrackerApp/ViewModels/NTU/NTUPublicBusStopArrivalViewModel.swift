//
//  NTUPublicBusStopArrivalViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Fetches public bus arrivals and handles notification logic for NTU's public buses (including when to notify user of bus arrival)

import Foundation

@MainActor
class NTUPublicBusStopArrivalViewModel: ObservableObject {
    @Published var arrivals: [PublicBusArrival] = []
    @Published var isLoading = false
    @Published var notificationsEnabled: Bool = false {
        didSet {
            saveNotificationsEnabledState()
            if notificationsEnabled {
                scheduleNotification()
            } else {
                cancelNotification()
                showScrollWheel = false
            }
        }
    }
    @Published var notificationLeadTime: Int = 3 {
        didSet {
            saveNotificationLeadTime()
            if notificationsEnabled {
                scheduleNotification()
            }
        }
    }
    @Published var showScrollWheel: Bool = false

    let stop: PublicBusStop
    let arriveLahService = ArriveLahService()
    var notificationID: String { "NTU_PUBLIC_\(stop.BusStopCode)" }
    
    private var notifyEnabledKey: String {
        "NTU_notifyEnabled_\(stop.BusStopCode)"
    }

    private var notifyMinutesKey: String {
        "NTU_notifyMinutes_\(stop.BusStopCode)"
    }

    init(stop: PublicBusStop) {
        self.stop = stop
        restoreSavedSettings()
    }
    
    private func saveNotificationsEnabledState() {
        UserDefaults.standard.set(notificationsEnabled, forKey: notifyEnabledKey)
    }

    private func saveNotificationLeadTime() {
        UserDefaults.standard.set(notificationLeadTime, forKey: notifyMinutesKey)
    }

    private func restoreSavedSettings() {
        notificationsEnabled = UserDefaults.standard.bool(forKey: notifyEnabledKey)

        let savedMinutes = UserDefaults.standard.integer(forKey: notifyMinutesKey)
        notificationLeadTime = savedMinutes > 0 ? savedMinutes : 3
    }

    func fetchArrivals() async {
        isLoading = true
        do {
            let response = try await arriveLahService.fetchArrivals(for: stop.BusStopCode, as: PublicBusArrivalResponse.self)
            arrivals = response.services.map(PublicBusArrival.init)
        } catch {
            print("Failed to fetch arrivals for stop \(stop.BusStopCode): \(error.localizedDescription)")
            arrivals = []
        }
        isLoading = false
    }

    private func scheduleNotification() {
        print("Scheduling notification")
        guard let soonest = arrivals
            .flatMap({ $0.minutesToArrivals })
            .filter({ $0 > 0 })
            .min() else {
            print("No valid arrival data to schedule notification.")
            notificationsEnabled = false
            return
        }

        if notificationLeadTime >= soonest || notificationLeadTime <= 0 {
            print("Lead time \(notificationLeadTime) not valid for soonest arrival of \(soonest) min.")
            notificationsEnabled = false
            return
        }

        let fireInSeconds = (soonest - notificationLeadTime) * 60

        NotificationManager.shared.scheduleNotification(
            id: notificationID,
            title: "Bus arriving soon!",
            body: "Bus will arrive at \(stop.Description) in \(notificationLeadTime) minutes.",
            after: fireInSeconds
        )
    }

    internal func cancelNotification() {
        NotificationManager.shared.cancelNotification(id: notificationID)
    }

//    func onDisappear() {
//        cancelNotification()
//    }
}
