//
//  BusTrackerWatchAppApp.swift
//  BusTrackerWatchApp Watch App
//
//  Created by Ava Vispilio on 1/6/25.
//

import SwiftUI

@main
struct BusTrackerWatchApp_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WatchLineSelectionView()
            }
        }
    }
}
