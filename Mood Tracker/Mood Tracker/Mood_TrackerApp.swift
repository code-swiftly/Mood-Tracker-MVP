//
//  Mood_TrackerApp.swift
//  Mood Tracker
//
//  Created by Andy Couto on 12/20/24.
//

import SwiftUI
import SwiftData

@main
struct Mood_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: SavedMood.self)
    }
}
