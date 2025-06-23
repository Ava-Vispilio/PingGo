//
//  SMUPublicBusArrivalViewModel.swift
//  BusTrackerApp
//
//  Created by Ava on 17/6/25.
//
// Fetches bus arrival timings of selected SMU bus service

import Foundation

@MainActor
class SMUPublicBusArrivalViewModel: ObservableObject {
    @Published var minutesToArrivals: [Int] = []
    @Published var notifyEnabled = false {
        didSet {
            saveNotifyEnabledState() // notifs edit
            handleNotificationToggle()
        }
    }
    @Published var notifyMinutesBefore = 2 {
        didSet {
            UserDefaults.standard.set(notifyMinutesBefore, forKey: notifyMinutesKey)
            if notifyEnabled {
                scheduleNotification()
            }
        }
    }

    private var stop: PublicBusStop?
    private var arrival: PublicBusArrival?
    
    private var notifyKey: String {
        guard let arrival, let stop else { return "notifyEnabled-default" }
        return "notifyEnabled-\(arrival.serviceNo)-\(stop.BusStopCode)"
    }
    
    private var notifyMinutesKey: String {
        guard let arrival, let stop else { return "notifyMinutes-default" }
        return "notifyMinutes-\(arrival.serviceNo)-\(stop.BusStopCode)"
    }

    func configure(with stop: PublicBusStop, arrival: PublicBusArrival) {
        self.stop = stop
        self.arrival = arrival
        self.minutesToArrivals = arrival.minutesToArrivals
        
        notifyEnabled = UserDefaults.standard.bool(forKey: notifyKey) // saves state of toggle
        
        let savedMinutes = UserDefaults.standard.integer(forKey: notifyMinutesKey) // saves time set for notifs
        notifyMinutesBefore = savedMinutes > 0 ? savedMinutes : 2
    }
    
    private func saveNotifyEnabledState() { // func to save notifs state
        UserDefaults.standard.set(notifyEnabled, forKey: notifyKey)
    }
    
    private func handleNotificationToggle() {
        guard let arrival, let stop else { return }

        let id = "bus-\(arrival.serviceNo)-\(stop.BusStopCode)"
        if !notifyEnabled {
            NotificationManager.shared.cancelNotification(id: id)
        } else {
            scheduleNotification()
        }
    }

    private func scheduleNotification() {
        guard notifyEnabled,
              let firstArrival = minutesToArrivals.first,
              let stop,
              let arrival else { return }

        let cappedLeadTime = min(notifyMinutesBefore, firstArrival)
        guard cappedLeadTime > 0 else {
            print("Invalid or zero lead time.")
            notifyEnabled = false
            return
        }

        let notifyAfter = (firstArrival - cappedLeadTime) * 60
        guard notifyAfter > 0 else {
            print("Too late to notify. Bus arriving in \(firstArrival) min.")
            notifyEnabled = false
            return
        }

        let id = "bus-\(arrival.serviceNo)-\(stop.BusStopCode)"
        NotificationManager.shared.scheduleNotification(
            id: id,
            title: "Bus \(arrival.serviceNo) arriving soon",
            body: "Bus will arrive at \(stop.Description) in \(cappedLeadTime) min.",
            after: notifyAfter
        )
    }
}
