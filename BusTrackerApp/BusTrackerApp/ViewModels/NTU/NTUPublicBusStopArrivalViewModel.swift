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
            if notificationsEnabled {
                scheduleNotification()
            }
        }
    }
    @Published var showScrollWheel: Bool = false

    let stop: PublicBusStop
    let arriveLahService = ArriveLahService()
    var notificationID: String { "NTU_PUBLIC_\(stop.BusStopCode)" }

    init(stop: PublicBusStop) {
        self.stop = stop
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

    func onDisappear() {
        cancelNotification()
    }
}

