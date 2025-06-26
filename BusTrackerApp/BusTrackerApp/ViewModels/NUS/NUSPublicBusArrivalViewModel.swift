//
//  NUSPublicBusArrivalViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Fetches bus arrival timings, handles notification logic for NUS's public buses (including when to notify user of bus arrival)

import Foundation

@MainActor
class NUSPublicBusArrivalViewModel: ObservableObject {
    @Published var arrivals: [PublicBusArrival] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var notifyEnabled: Bool = false {
        didSet {
            saveNotifyEnabledState()
            if notifyEnabled {
                scheduleNotification()
            } else {
                cancelNotification()
            }
        }
    }
    @Published var minutesBefore: Int = 2 {
        didSet {
            saveNotificationLeadTime()
            if notifyEnabled {
                scheduleNotification()
            }
        }
    }

    private let service = ArriveLahService()
    let stop: PublicBusStop
    private let busService: String

    var notificationID: String {
        "NUS_PUBLIC_\(stop.BusStopCode)_\(busService)"
    }

    private var notifyEnabledKey: String {
        "NUS_notifyEnabled_\(stop.BusStopCode)_\(busService)"
    }

    private var notifyMinutesKey: String {
        "NUS_notifyMinutes_\(stop.BusStopCode)_\(busService)"
    }
    
    init(stop: PublicBusStop, busService: String) {
        self.stop = stop
        self.busService = busService
        restoreSavedSettings()
    }
    
    private func saveNotifyEnabledState() {
        UserDefaults.standard.set(notifyEnabled, forKey: notifyEnabledKey)
    }

    private func saveNotificationLeadTime() {
        UserDefaults.standard.set(minutesBefore, forKey: notifyMinutesKey)
    }

    private func restoreSavedSettings() {
        notifyEnabled = UserDefaults.standard.bool(forKey: notifyEnabledKey)

        let savedMinutes = UserDefaults.standard.integer(forKey: notifyMinutesKey)
        minutesBefore = savedMinutes > 0 ? savedMinutes : 3
    }

    func fetchArrivals() async {
        isLoading = true
        errorMessage = nil

        do {
            let response: PublicBusArrivalResponse = try await service.fetchArrivals(for: stop.BusStopCode, as: PublicBusArrivalResponse.self)
            let matchingServices = response.services.filter { $0.no == busService }
            let formattedArrivals = matchingServices.map { PublicBusArrival(from: $0) }

            self.arrivals = formattedArrivals

            if notifyEnabled {
                scheduleNotification()
            }
        } catch {
            errorMessage = "Failed to fetch arrivals: \(error.localizedDescription)"
            arrivals = []
        }

        isLoading = false
    }

    private func scheduleNotification() {
        guard let soonest = arrivals.first?.minutesToArrivals.first else {
            print("No arrival data to schedule notification.")
            notifyEnabled = false
            return
        }

        // Cap minutesBefore to not exceed soonest
        let cappedLeadTime = min(minutesBefore, soonest)
        guard cappedLeadTime > 0 else {
            print("Invalid lead time: 0 or greater than/equal to arrival.")
            notifyEnabled = false
            return
        }

        let fireInSeconds = (soonest - cappedLeadTime) * 60

        guard fireInSeconds > 0 else {
            print("Too late to notify: bus arrives in \(soonest) min, lead time \(cappedLeadTime) min.")
            notifyEnabled = false
            return
        }

        NotificationManager.shared.scheduleNotification(
            id: notificationID,
            title: "Bus \(busService) arriving soon",
//            body: "Bus will arrive at \(stop.Description) in \(cappedLeadTime) minute\(cappedLeadTime > 1 ? "s" : "").", // standardising
            body: "Bus will arrive at \(stop.Description) in \(cappedLeadTime) min.",
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
