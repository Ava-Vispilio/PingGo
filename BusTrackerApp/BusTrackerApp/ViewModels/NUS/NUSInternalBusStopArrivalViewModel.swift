//
//  NUSInternalBusStopArrivalViewModel.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 14/6/25.
//

import Foundation
import UserNotifications

@MainActor
class NUSInternalBusStopArrivalViewModel: ObservableObject {
    let stop: NUSInternalBusStop
    let routeCode: String

    @Published var isLoading = true
    @Published var errorMessage: String?
    @Published var arrivals: [Int] = []

    @Published var notifyEnabled = false
    @Published var minutesBefore = 3 {
        didSet {
            if notifyEnabled {
                scheduleNotification()
            }
        }
    }

    init(stop: NUSInternalBusStop, routeCode: String) {
        self.stop = stop
        self.routeCode = routeCode
    }

    func fetchArrivals() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await NUSNextBusService.shared.fetchArrivalInfo(busStopName: stop.name)

            // Filter shuttles by route code
            let filtered = result.shuttles.filter { $0.name == routeCode }

            // Extract and sort arrival times in minutes
            let mins = filtered.compactMap {
                Int($0.nextArrivalTime.replacingOccurrences(of: " mins", with: ""))
            }

            arrivals = mins.sorted()
        } catch {
            errorMessage = "Failed to fetch arrivals: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func scheduleNotification() {
        guard let firstArrival = arrivals.first else { return }

        let fireTime = firstArrival - minutesBefore
        if fireTime <= 0 { return }

        let content = UNMutableNotificationContent()
        content.title = "Bus Arrival Alert"
        content.body = "Your bus (\(routeCode)) will arrive in \(minutesBefore) minute(s) at \(stop.name)."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(fireTime * 60), repeats: false)
        let request = UNNotificationRequest(
            identifier: "nusbus_\(routeCode)_\(stop.name)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}
