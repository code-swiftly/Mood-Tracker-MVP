//
//  LogMoodIntent.swift
//  Mood Tracker
//
//  Created by Andy Couto on 1/18/25.
//

import Foundation
import AppIntents
import SwiftData

struct LogMoodIntent: AppIntent {
    static var title = LocalizedStringResource("Log My Mood")
    
    static var description = IntentDescription(
        "Logs your mood in the mood tracker app"
    )
    
    @Parameter(title: "Mood") var mood: Mood
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard let container = try? ModelContainer(for: SavedMood.self) else {
            throw NSError(domain: "MoodTrackerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Sorry, something went wrong"])
        }
        
        let normalizedDate = Date().normalizedDate
        
        try await MainActor.run {
            let fetchDescriptor = FetchDescriptor<SavedMood>()
            if let existingMood = try? container.mainContext.fetch(fetchDescriptor)
                .first(where: { Calendar.current.isDate($0.date, inSameDayAs: normalizedDate) }) {
                existingMood.mood = mood
            } else {
                let newMood = SavedMood(date: normalizedDate, mood: mood)
                container.mainContext.insert(newMood)
            }
            try container.mainContext.save()
        }
        
        return .result(dialog: .init("We've logged your mood for today as \(mood.rawValue)"))
    }
}
