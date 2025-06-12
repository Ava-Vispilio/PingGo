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
            if notifyEnabled {
                scheduleNotification()
            } else {
                cancelNotification()
            }
        }
    }
    @Published var minutesBefore: Int = 2 {
        didSet {
            if notifyEnabled {
                scheduleNotification()
            }
        }
    }

    private let service = ArriveLahService()
    private var stopCode: String = ""
    private var busService: String = ""

    private var notificationID: String {
        "\(stopCode)_\(busService)"
    }

    func configure(stopCode: String, busService: String) {
        self.stopCode = stopCode
        self.busService = busService
    }

    func fetchArrivals() async {
        isLoading = true
        errorMessage = nil

        do {
            let response: PublicBusArrivalResponse = try await service.fetchArrivals(for: stopCode, as: PublicBusArrivalResponse.self)
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

        let timeUntilArrivalSeconds = soonest * 60
        let leadTimeSeconds = minutesBefore * 60
        let fireInSeconds = timeUntilArrivalSeconds - leadTimeSeconds

        guard fireInSeconds > 0 else {
            print("Too late to notify: bus arrives in \(soonest) minutes, which is <= lead time.")
            notifyEnabled = false
            return
        }

        NotificationManager.shared.scheduleNotification(
            id: notificationID,
            title: "Bus \(busService) arriving soon!",
            body: "Bus will arrive at stop \(stopCode) in \(minutesBefore) minutes.",
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
