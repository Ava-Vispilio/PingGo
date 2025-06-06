//
//  BusTrackerWatchApp.swift
//  BusTrackerWatchApp
//
//  Created by Ava on 5/6/25.
//

import AppIntents

struct BusTrackerWatchApp: AppIntent {
    static var title: LocalizedStringResource { "BusTrackerWatchApp" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
