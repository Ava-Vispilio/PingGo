//
//  NTUPublicBusStopArrivalViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 24/6/25.
//

import Foundation

@MainActor
class NTUPublicBusStopArrivalViewModel: ObservableObject {
    @Published var arrivals: [PublicBusArrival] = []
    @Published var isLoading = false
    @Published var notificationsEnabled: Bool = false {
        didSet {
            print("NTU Internal notification state set")
            saveNotificationsEnabledState()
            if !notificationsEnabled {
                cancelNotification()
                notificationWasScheduled = false
                print("NTU external notification cleared due to toggle off")
            }
        }
    }
    @Published var notificationLeadTime: Int = 3 {
        didSet {
            UserDefaults.standard.set(notificationLeadTime, forKey: notifyMinutesKey)
            print("Updated NTU external lead time to \(notificationLeadTime) min")
        }
    }
    @Published var notificationWasScheduled = false
    @Published var showScrollWheel: Bool = false

    let stop: PublicBusStop
    let arriveLahService = ArriveLahService()

    init(stop: PublicBusStop) {
        self.stop = stop
        restoreSavedSettings()
    }

    var notificationID: String {
        "NTU_PUBLIC_\(stop.BusStopCode)"
    }

    private var notifyEnabledKey: String {
        "NTU_notifyEnabled_\(stop.BusStopCode)"
    }

    private var notifyMinutesKey: String {
        "NTU_notifyMinutes_\(stop.BusStopCode)"
    }

    private func saveNotificationsEnabledState() {
        UserDefaults.standard.set(notificationsEnabled, forKey: notifyEnabledKey)
        print("Saved notify toggle \(notificationsEnabled) to \(notifyEnabledKey)")
    }

    private func restoreSavedSettings() {
        notificationsEnabled = UserDefaults.standard.bool(forKey: notifyEnabledKey)
        let savedMinutes = UserDefaults.standard.integer(forKey: notifyMinutesKey)
        notificationLeadTime = savedMinutes > 0 ? savedMinutes : 3
        print("Restored toggle = \(notificationsEnabled), minutesBefore = \(notificationLeadTime)")
    }

    func fetchArrivals() async {
        isLoading = true
        do {
            let response = try await arriveLahService.fetchArrivals(for: stop.BusStopCode, as: PublicBusArrivalResponse.self)
            arrivals = response.services.map(PublicBusArrival.init)
            print("Loaded \(arrivals.count) services for stop \(stop.BusStopCode)")
        } catch {
            print("Failed to fetch arrivals for stop \(stop.BusStopCode): \(error.localizedDescription)")
            arrivals = []
        }
        isLoading = false
    }

    func handleNotificationToggle() {
        if notificationsEnabled {
            print("[DEBUG] Triggering scheduleNotification()")
            scheduleNotification()
        } else {
            print("[DEBUG] Triggering cancelNotification()")
            cancelNotification()
        }
    }

    func scheduleNotification() {
        guard notificationsEnabled else {
            print("NTU external Schedule skipped — toggle is off")
            return
        }

        guard let soonest = arrivals
            .flatMap({ $0.minutesToArrivals })
            .filter({ $0 > 0 })
            .min() else {
                print("No valid upcoming arrival found.")
                notificationsEnabled = false
                return
        }

        let cappedLeadTime = min(notificationLeadTime, soonest)
        let notifyAfter = (soonest - cappedLeadTime) * 60

        guard cappedLeadTime > 0, notifyAfter > 0 else {
            print("Skipping NTU external scheduling: cappedLeadTime=\(cappedLeadTime), notifyAfter=\(notifyAfter)")
            notificationsEnabled = false
            return
        }

        NotificationManager.shared.scheduleNotification(
            id: notificationID,
            title: "Bus arriving soon",
            body: "Bus will arrive at \(stop.Description) in \(cappedLeadTime) minutes.",
            after: notifyAfter
        )

        notificationWasScheduled = true
        print("NTU external bus notification scheduled in \(notifyAfter) seconds (lead time \(cappedLeadTime))")
    }

    func cancelNotification() {
        NotificationManager.shared.cancelNotification(id: notificationID)
        print("Canceled NTU external notification ID: \(notificationID)")
    }
}

