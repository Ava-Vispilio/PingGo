//
//  NTUPublicBusStopArrivalViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//


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
        guard let soonest = arrivals.first?.minutesToArrivals.first else {
            print("No arrival data to schedule notification.")
            notificationsEnabled = false
            return
        }

        let timeUntilArrivalSeconds = soonest * 60
        let leadTimeSeconds = notificationLeadTime * 60
        let fireInSeconds = timeUntilArrivalSeconds - leadTimeSeconds

        if fireInSeconds <= 0 {
            print("Too late to notify: arrival is within or before lead time.")
            notificationsEnabled = false
            return
        }

        NotificationManager.shared.scheduleNotification(
            id: notificationID,
            title: "Bus arriving soon",
            body: "Bus will arrive at \(stop.Description) in \(notificationLeadTime) minutes.",
            after: fireInSeconds
        )
    }

    private func cancelNotification() {
        NotificationManager.shared.cancelNotification(id: notificationID)
    }

    func onDisappear() {
        cancelNotification()
    }
}
