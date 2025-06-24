//
//  NTUInternalBusStopArrivalViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 24/6/25.
//

import Foundation

@MainActor
class NTUInternalBusStopArrivalViewModel: ObservableObject {
    @Published var stopName: String = ""
    @Published var arrivalTimes: [NTUInternalBusArrivalTime] = []
    @Published var notifyEnabled = false {
        didSet {
            print("[DEBUG] notifyEnabled set to \(notifyEnabled)")
            saveNotifyEnabledState()
            if !notifyEnabled {
                notificationWasScheduled = false
                print("[DEBUG] Notification was unscheduled due to toggle off")
            }
        }
    }
    @Published var notifyMinutesBefore = 1
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var notificationWasScheduled = false

    private let apiClient: NTUBusAPIClient
    private let notificationManager = NotificationManager.shared
    private var stopId: String?

    init(apiClient: NTUBusAPIClient = .shared) {
        self.apiClient = apiClient
    }

    init(busStopId: String, stopName: String, apiClient: NTUBusAPIClient = .shared) {
        self.apiClient = apiClient
        self.stopId = busStopId
        self.stopName = stopName
        restoreSavedSettings()
    }

    func fetchArrivalTimes(for stopId: String) async {
        self.stopId = stopId
        isLoading = true
        errorMessage = nil

        do {
            let response = try await apiClient.fetchBusArrival(for: stopId)
            let busArrival = response.busArrival
            stopName = busArrival.name
            arrivalTimes = busArrival.forecasts.sorted { $0.minutes < $1.minutes }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func handleNotificationToggle() {
        guard let stopId = stopId else { return }
        let id = notificationId(for: stopId)

        if !notifyEnabled {
            print("[DEBUG] Cancelling internal bus notification with ID: \(id)")
            notificationManager.cancelNotification(id: id)
        } else {
            print("[DEBUG] Scheduling internal bus notification for ID: \(id)")
            scheduleNotification()
        }
    }

    func scheduleNotification() {
        guard notifyEnabled,
              let soonest = arrivalTimes.first,
              let stopId = stopId else {
            print("[DEBUG] Skipping schedule: Missing conditions")
            return
        }

        let cappedLeadTime = min(notifyMinutesBefore, soonest.minutes)
        let notifyAfter = (soonest.minutes - cappedLeadTime) * 60

        guard cappedLeadTime > 0, notifyAfter > 0 else {
            print("[DEBUG] Invalid notifyAfter: \(notifyAfter)s or cappedLeadTime: \(cappedLeadTime)m — disabling toggle")
            notifyEnabled = false
            return
        }

        let id = notificationId(for: stopId)
        notificationManager.scheduleNotification(
            id: id,
            title: "Bus arriving soon!",
            body: "Your bus at \(stopName) is arriving in \(cappedLeadTime) minutes.",
            after: notifyAfter
        )

        print("[DEBUG] Internal bus notification scheduled in \(notifyAfter) seconds")
        notificationWasScheduled = true
    }

    func cancelNotificationIfNeeded() {
        guard let stopId = stopId else { return }
        let id = notificationId(for: stopId)
        print("[DEBUG] cancelNotificationIfNeeded() called for ID: \(id)")
        notificationManager.cancelNotification(id: id)
    }

    func restoreSavedSettings() {
        notifyEnabled = UserDefaults.standard.bool(forKey: notifyKey)
        let savedMinutes = UserDefaults.standard.integer(forKey: notifyMinutesKey)
        notifyMinutesBefore = savedMinutes > 0 ? savedMinutes : 1
        print("[DEBUG] Restored toggle = \(notifyEnabled), minutesBefore = \(notifyMinutesBefore)")
    }

    private func saveNotifyEnabledState() {
        UserDefaults.standard.set(notifyEnabled, forKey: notifyKey)
        print("[DEBUG] Saved toggle state: \(notifyEnabled) for key \(notifyKey)")
    }

    private var notifyKey: String {
        stopId.map { "ntu-notifyEnabled-\($0)" } ?? "ntu-notifyEnabled-default"
    }

    private var notifyMinutesKey: String {
        stopId.map { "ntu-notifyMinutes-\($0)" } ?? "ntu-notifyMinutes-default"
    }

    private func notificationId(for stopId: String) -> String {
        "ntu_bus_arrival_\(stopId)"
    }
}
