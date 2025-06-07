//
//  BusTrackerAppApp.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 1/6/25.
//

import SwiftUI
import UserNotifications

@main
struct BusTrackerApp: App {
    // Create a delegate instance for notifications
    class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
        // Show notifications as banners even when app is in foreground
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
            NTULineSelectionView()
        }
    }
}
