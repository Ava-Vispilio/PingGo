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

    @Published var isLoading = false
    @Published var arrivals: [Int] = []
    @Published var errorMessage: String?
    
    @Published var notifyEnabled: Bool = false {
        didSet {
            if !notifyEnabled {
                cancelNotification()
                showScrollWheel = false
            }
        }
    }

    @Published var minutesBefore: Int = 1 {
        didSet {
            scheduleNotificationIfNeeded()
        }
    }
    
    @Published var showScrollWheel: Bool = false

    private var firstArrival: Int? {
        arrivals.first(where: { $0 > 0 }) // skip 0 min buses
    }

    init(stop: NUSInternalBusStop, routeCode: String) {
        self.stop = stop
        self.routeCode = routeCode
    }

    func fetchArrivals() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await NUSNextBusService.shared.fetchArrivalInfo(busStopName: stop.name)
            let allArrivals = result.shuttles
                .filter { $0.name == routeCode }
                .compactMap { Int($0.arrivalTime) }
                .filter { $0 > 0 } // skip immediate arrivals
            
            arrivals = Array(allArrivals.prefix(3))
            if let first = arrivals.first {
                if minutesBefore > first {
                    minutesBefore = first
                }
            }

            scheduleNotificationIfNeeded()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func scheduleNotificationIfNeeded() {
        guard notifyEnabled,
              let arrivalIn = firstArrival,
              minutesBefore > 0,
              minutesBefore < arrivalIn else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Bus \(routeCode) arriving soon"
        content.body = "Arriving at \(stop.caption) in \(minutesBefore) min"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval((arrivalIn - minutesBefore) * 60), repeats: false)
        let request = UNNotificationRequest(identifier: "bus-\(stop.name)-\(routeCode)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    private func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["bus-\(stop.name)-\(routeCode)"])
    }
}

