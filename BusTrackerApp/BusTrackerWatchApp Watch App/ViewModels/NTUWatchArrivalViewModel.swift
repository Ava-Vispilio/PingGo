//
//  NTUWatchArrivalViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 4/6/25.
//
// Fetches NTU's bus arrival time (selected bus route and stop)


import Foundation

@MainActor
class NTUWatchArrivalViewModel: ObservableObject {
    @Published var stopName: String = ""
    @Published var arrivalTimes: [NTUInternalBusArrivalTime] = []
    @Published var notifyWhenSoon: Bool = false
    @Published var notificationLeadTime: Int = 1 // default 1 minute
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
            print("[Watch] Fetching arrival times for NTU stop ID: \(stopId)")
            let response = try await apiClient.fetchBusArrival(for: stopId)
            let busArrival = response.busArrival

            self.stopName = busArrival.name
            self.arrivalTimes = busArrival.forecasts.sorted { $0.minutes < $1.minutes }
            print("[Watch] Fetched arrival times:", self.arrivalTimes.map { "\($0.minutes) min" })

        } catch {
            print("[Watch] Failed to fetch arrival times:", error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func toggleNotification(_ enabled: Bool) {
        notifyWhenSoon = enabled

        guard let stopId = stopId else { return }
        let notificationId = "bus_arrival_\(stopId)"

        if enabled {
            print("[Watch] Enabling notification for NTU stop \(stopId)")
            scheduleNotification(id: notificationId)
        } else {
            print("[Watch] Cancelling notification for NTU stop \(stopId)")
            notificationManager.cancelNotification(id: notificationId)
        }
    }

    func scheduleNotification(id: String) {
        guard let soonest = arrivalTimes.first else {
            print("[Watch] No arrival times available to schedule notification.")
            errorMessage = "No arrival times to notify about."
            notifyWhenSoon = false
            return
        }

        let timeUntilArrival = soonest.minutes
        let leadTime = notificationLeadTime
        let secondsBefore = max(timeUntilArrival - leadTime, 0) * 60

        print("[Watch] Scheduling notification '\(id)' \(leadTime) min before arrival (\(secondsBefore) seconds from now)")

        notificationManager.scheduleNotification(
            id: id,
            title: "Bus arriving soon!",
            body: "Your bus at \(stopName) is arriving in \(leadTime) minutes.",
            after: secondsBefore
        )
    }

    func rescheduleNotificationIfNeeded() {
        guard notifyWhenSoon, let stopId = stopId else { return }
        let notificationId = "bus_arrival_\(stopId)"
        print("[Watch] Rescheduling notification for NTU stop \(stopId)")
        notificationManager.cancelNotification(id: notificationId)
        scheduleNotification(id: notificationId)
    }

    func onDisappear() {
        guard let stopId = stopId else { return }
        let notificationId = "bus_arrival_\(stopId)"
        print("[Watch] View disappeared — cancelling notification: \(notificationId)")
        notificationManager.cancelNotification(id: notificationId)
    }
}
