import Foundation

@MainActor
class BusStopArrivalViewModel: ObservableObject {
    @Published var stopName: String = ""
    @Published var arrivalTimes: [BusArrivalTime] = []
    @Published var notifyWhenSoon: Bool = false
    @Published var notificationLeadTime: Int = 1 // Default to 1 minute before arrival
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let apiClient: BusAPIClient
    private let notificationManager = NotificationManager.shared
    private var stopId: String?

    init(apiClient: BusAPIClient = .shared) {
        self.apiClient = apiClient
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

    func toggleNotification(_ enabled: Bool) {
        notifyWhenSoon = enabled

        guard let stopId = stopId else { return }
        let notificationId = "bus_arrival_\(stopId)"

        if enabled {
            scheduleNotification(id: notificationId)
        } else {
            notificationManager.cancelNotification(id: notificationId)
        }
    }

    func scheduleNotification(id: String) {
        guard let soonest = arrivalTimes.first else {
            errorMessage = "No arrival times to notify about."
            notifyWhenSoon = false
            return
        }

        let timeUntilArrival = soonest.minutes
        let leadTime = notificationLeadTime
        let secondsBefore = max(timeUntilArrival - leadTime, 0) * 60

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
        notificationManager.cancelNotification(id: notificationId)
        scheduleNotification(id: notificationId)
    }

    func onDisappear() {
        // Cancel notification when view disappears (Enhancement A)
        guard let stopId = stopId else { return }
        let notificationId = "bus_arrival_\(stopId)"
        notificationManager.cancelNotification(id: notificationId)
    }
}
