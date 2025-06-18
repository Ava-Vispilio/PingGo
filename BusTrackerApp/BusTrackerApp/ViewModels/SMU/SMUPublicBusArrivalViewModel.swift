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
            scheduleNotification()
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

        let notifyAfter = (firstArrival - notifyMinutesBefore) * 60
        if notifyAfter > 0 {
            let id = "bus-\(arrival.serviceNo)-\(stop.BusStopCode)"
            NotificationManager.shared.scheduleNotification(
                id: id,
                title: "Bus \(arrival.serviceNo) arriving",
                body: "Your bus is arriving in \(notifyMinutesBefore) minutes at \(stop.Description).",
                after: notifyAfter
            )
        }
    }
}
