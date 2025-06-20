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
            handleNotificationToggle()
        }
    }
    @Published var notifyMinutesBefore = 2 {
        didSet {
            if notifyEnabled {
                scheduleNotification()
            }
        }
    }

    private var stop: PublicBusStop?
    private var arrival: PublicBusArrival?

    func configure(with stop: PublicBusStop, arrival: PublicBusArrival) {
        self.stop = stop
        self.arrival = arrival
        self.minutesToArrivals = arrival.minutesToArrivals
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
            title: "Bus \(arrival.serviceNo) arriving",
            body: "Your bus is arriving in \(cappedLeadTime) minutes at \(stop.Description).",
            after: notifyAfter
        )
    }
}

