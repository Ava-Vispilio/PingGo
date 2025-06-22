//
//  SMUPublicBusArrivalViewModel.swift
//  BusTrackerApp
//
//  Created by Ava on 17/6/25.
//

import Foundation

@MainActor
class SMUPublicBusArrivalViewModel: ObservableObject {
    @Published var minutesToArrivals: [Int] = []
    @Published var notifyEnabled = false {
        didSet {
            saveNotifyEnabledState()
            // Removed handleNotificationToggle from here
        }
    }
    @Published var notifyMinutesBefore = 2 {
        didSet {
            UserDefaults.standard.set(notifyMinutesBefore, forKey: notifyMinutesKey)
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

        notifyEnabled = UserDefaults.standard.bool(forKey: notifyKey)
        let savedMinutes = UserDefaults.standard.integer(forKey: notifyMinutesKey)
        notifyMinutesBefore = savedMinutes > 0 ? savedMinutes : 2
    }

    private func saveNotifyEnabledState() {
        UserDefaults.standard.set(notifyEnabled, forKey: notifyKey)
    }

    func handleNotificationToggle() {
        guard let arrival, let stop else { return }

        let id = "bus-\(arrival.serviceNo)-\(stop.BusStopCode)"
        if !notifyEnabled {
            print("Cancelled notification with id: \(id)")
            NotificationManager.shared.cancelNotification(id: id)
        } else {
            scheduleNotification()
        }
    }

    func scheduleNotification() {
        guard notifyEnabled,
              let firstArrival = minutesToArrivals.first,
              let stop,
              let arrival else { return }

        let cappedLeadTime = min(notifyMinutesBefore, firstArrival)
        let notifyAfter = (firstArrival - cappedLeadTime) * 60

        print("""
        Attempting to schedule notification:
          notifyEnabled = \(notifyEnabled)
          notifyMinutesBefore = \(notifyMinutesBefore)
          cappedLeadTime = \(cappedLeadTime)
          firstArrival = \(firstArrival)
          notifyAfter = \(notifyAfter)
        """)

        guard cappedLeadTime > 0 else {
            print("Invalid lead time: cappedLeadTime = \(cappedLeadTime)")
            notifyEnabled = false
            return
        }

        guard notifyAfter > 0 else {
            print("Too late to notify. Bus arriving in \(firstArrival) min (notifyAfter = \(notifyAfter))")
            notifyEnabled = false
            return
        }

        let id = "bus-\(arrival.serviceNo)-\(stop.BusStopCode)"
        print("Scheduling notification with id: \(id), to fire in \(notifyAfter) seconds")
        NotificationManager.shared.scheduleNotification(
            id: id,
            title: "Bus \(arrival.serviceNo) arriving",
            body: "Your bus is arriving in \(cappedLeadTime) minutes at \(stop.Description).",
            after: notifyAfter
        )
    }
}

