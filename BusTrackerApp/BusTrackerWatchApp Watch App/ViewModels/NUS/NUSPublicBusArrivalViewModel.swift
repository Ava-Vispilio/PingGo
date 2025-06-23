import Foundation

@MainActor
class NUSPublicBusArrivalViewModel: ObservableObject {
    @Published var arrivals: [PublicBusArrival] = []
    @Published var minutesToArrivals: [Int] = []
    @Published var notifyEnabled: Bool = false {
        didSet {
            saveNotifyEnabledState()
            if !notifyEnabled {
                notificationWasScheduled = false
            }
        }
    }
    @Published var notifyMinutesBefore: Int = 2 {
        didSet {
            UserDefaults.standard.set(notifyMinutesBefore, forKey: notifyMinutesKey)
        }
    }
    @Published var notificationWasScheduled = false

    let stop: PublicBusStop
    private let busService: String
    private let service = ArriveLahService()

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

    func fetchArrivals() async {
        do {
            let response: PublicBusArrivalResponse = try await service.fetchArrivals(for: stop.BusStopCode, as: PublicBusArrivalResponse.self)
            let matching = response.services.filter { $0.no == busService }
            let formatted = matching.map { PublicBusArrival(from: $0) }

            self.arrivals = formatted
            self.minutesToArrivals = formatted.first?.minutesToArrivals.filter { $0 > 0 } ?? []

            if notifyEnabled {
                scheduleNotification()
            }
        } catch {
            print("Failed to fetch NUS public arrivals: \(error.localizedDescription)")
            self.arrivals = []
            self.minutesToArrivals = []
        }
    }

    func handleNotificationToggle() {
        if notifyEnabled {
            scheduleNotification()
        } else {
            cancelNotificationIfNeeded()
        }
    }

    func scheduleNotification() {
        guard let firstArrival = minutesToArrivals.first else {
            print("Cannot schedule NUS Public Notif: no arrival data.")
            notifyEnabled = false
            return
        }

        let cappedLeadTime = min(notifyMinutesBefore, firstArrival)
        let notifyAfter = (firstArrival - cappedLeadTime) * 60

        print("""
        🛠️ Attempting to schedule NUS Public notification:
          notifyEnabled = \(notifyEnabled)
          notifyMinutesBefore = \(notifyMinutesBefore)
          cappedLeadTime = \(cappedLeadTime)
          firstArrival = \(firstArrival)
          notifyAfter = \(notifyAfter)
        """)

        guard cappedLeadTime > 0 && notifyAfter > 0 else {
            print("Invalid lead time: cappedLeadTime = \(cappedLeadTime), notifyAfter = \(notifyAfter)")
            notifyEnabled = false
            return
        }

        print("Scheduling notification with id: \(notificationID), to fire in \(notifyAfter) seconds")

        NotificationManager.shared.scheduleNotification(
            id: notificationID,
            title: "Bus \(busService) arriving",
            body: "Bus will arrive at \(stop.Description) in \(cappedLeadTime) minutes.",
            after: notifyAfter
        )

        notificationWasScheduled = true
    }

    func cancelNotificationIfNeeded() {
        print("Cancelling notification with id: \(notificationID)")
        NotificationManager.shared.cancelNotification(id: notificationID)
    }

    private func saveNotifyEnabledState() {
        UserDefaults.standard.set(notifyEnabled, forKey: notifyEnabledKey)
    }

    private func restoreSavedSettings() {
        notifyEnabled = UserDefaults.standard.bool(forKey: notifyEnabledKey)
        let saved = UserDefaults.standard.integer(forKey: notifyMinutesKey)
        notifyMinutesBefore = saved > 0 ? saved : 2
    }
}
