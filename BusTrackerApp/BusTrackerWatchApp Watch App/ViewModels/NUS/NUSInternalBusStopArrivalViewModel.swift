import Foundation

@MainActor
class NUSInternalBusStopArrivalViewModel: ObservableObject {
    @Published var minutesToArrivals: [Int] = []
    @Published var notifyEnabled = false {
        didSet {
            saveNotifyEnabledState()
            if !notifyEnabled {
                notificationWasScheduled = false
            }
        }
    }
    @Published var notifyMinutesBefore = 2 {
        didSet {
            UserDefaults.standard.set(notifyMinutesBefore, forKey: notifyMinutesKey)
        }
    }
    @Published var notificationWasScheduled = false

    let stop: NUSInternalBusStop
    let routeCode: String

    private var notifyKey: String {
        "NUS_notifyEnabled-\(routeCode)-\(stop.name)"
    }

    private var notifyMinutesKey: String {
        "NUS_notifyMinutes-\(routeCode)-\(stop.name)"
    }

    init(stop: NUSInternalBusStop, routeCode: String) {
        self.stop = stop
        self.routeCode = routeCode
        restoreSavedSettings()
    }

    func fetchArrivals() async {
        do {
            let result = try await NUSNextBusService.shared.fetchArrivalInfo(busStopName: stop.name)
            let arrivalTimes = result.shuttles
                .filter { $0.name == routeCode }
                .compactMap { Int($0.arrivalTime) }
                .filter { $0 > 0 }

            minutesToArrivals = Array(arrivalTimes.prefix(3))

            if let soonest = minutesToArrivals.first, notifyMinutesBefore > soonest {
                notifyMinutesBefore = soonest
            }

            scheduleNotificationIfNeeded()
        } catch {
            print("Failed to fetch NUS Internal arrivals: \(error.localizedDescription)")
        }
    }

    func handleNotificationToggle() {
        if !notifyEnabled {
            cancelNotificationIfNeeded()
        } else {
            scheduleNotificationIfNeeded()
        }
    }

    func scheduleNotificationIfNeeded() {
        guard notifyEnabled,
              let firstArrival = minutesToArrivals.first else {
            print("Cannot schedule: notifyEnabled = \(notifyEnabled), firstArrival = nil")
            notifyEnabled = false
            return
        }

        let cappedLeadTime = min(notifyMinutesBefore, firstArrival)
        let notifyAfter = (firstArrival - cappedLeadTime) * 60

        print("""
        🛠️ Attempting to schedule NUS internal notification:
          notifyEnabled = \(notifyEnabled)
          notifyMinutesBefore = \(notifyMinutesBefore)
          cappedLeadTime = \(cappedLeadTime)
          firstArrival = \(firstArrival)
          notifyAfter = \(notifyAfter)
        """)

        guard cappedLeadTime > 0, notifyAfter > 0 else {
            print("Invalid lead time: cappedLeadTime = \(cappedLeadTime), notifyAfter = \(notifyAfter)")
            notifyEnabled = false
            return
        }

        let id = "NUS-\(routeCode)-\(stop.name)"
        print("Scheduling notification with id: \(id), to fire in \(notifyAfter) seconds")

        NotificationManager.shared.scheduleNotification(
            id: id,
            title: "Bus \(routeCode) arriving",
            body: "Your bus is arriving at \(stop.caption) in \(cappedLeadTime) minutes.",
            after: notifyAfter
        )

        notificationWasScheduled = true
    }

    func cancelNotificationIfNeeded() {
        let id = "NUS-\(routeCode)-\(stop.name)"
        print("Cancelling notification with id: \(id)")
        NotificationManager.shared.cancelNotification(id: id)
    }

    private func saveNotifyEnabledState() {
        UserDefaults.standard.set(notifyEnabled, forKey: notifyKey)
    }

    private func restoreSavedSettings() {
        notifyEnabled = UserDefaults.standard.bool(forKey: notifyKey)
        let savedMinutes = UserDefaults.standard.integer(forKey: notifyMinutesKey)
        notifyMinutesBefore = savedMinutes > 0 ? savedMinutes : 2
    }
}
