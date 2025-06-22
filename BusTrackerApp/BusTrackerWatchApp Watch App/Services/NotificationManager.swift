//
//  NotificationManager.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 4/6/25.
//
//  Handles notification scheduling

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {
        requestAuthorization()
    }

    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            if !granted {
                print("Notification permission not granted.")
            }
        }
    }

    func scheduleNotification(id: String, title: String, body: String, after timeInterval: Int) {
        guard timeInterval > 0 else {
            print("Aborted scheduling: timeInterval must be > 0 (got \(timeInterval))")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }

    func cancelNotification(id: String) {
        print("Cancelled notification with id: \(id)")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
