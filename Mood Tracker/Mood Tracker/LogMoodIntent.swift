//
//  LogMoodIntent.swift
//  Mood Tracker
//
//  Created by Andy Couto on 1/18/25.
//

import Foundation
import AppIntents

struct LogMoodIntent: AppIntent {
    static var title = LocalizedStringResource("Log My Mood")
    
    static var description = IntentDescription(
        "Logs your mood in the mood tracker app"
    )
    
    @Parameter(title: "Mood") var mood: Mood
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // 
        return .result(dialog: .init("We've logged your mood for today as \(mood.rawValue)"))
    }
}
