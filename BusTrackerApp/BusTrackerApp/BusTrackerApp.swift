//
//  BusTrackerApp.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 1/6/25.
//
// Combines the views according to flow, manages notifications & notification banner

import SwiftUI
import UserNotifications

@main
struct BusTrackerApp: App {
    // Notification Delegate for foreground display
    class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.banner, .sound])
        }
    }

    let notificationDelegate = NotificationDelegate()

    init() {
        let center = UNUserNotificationCenter.current()
        center.delegate = notificationDelegate
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                // NUS Tab - Public buses for now
                NUSLineSelectionView()
                    .tabItem {
                        Label("NUS", systemImage: "tram.fill")
                    }

                // NTU Tab - Your existing NTU flow
                NTULineSelectionView()
                    .tabItem {
                        Label("NTU", systemImage: "bus.fill")
                    }

                // SMU Tab - For public buses only
                SMUPublicBusStopSelectionView()
                    .tabItem {
                        Label("SMU", systemImage: "building.2.fill")
                    }
            }
        }
    }
}
