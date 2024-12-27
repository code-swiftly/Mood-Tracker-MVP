//
//  SavedMood.swift
//  Mood Tracker
//
//  Created by Andy Couto on 12/26/24.
//

import Foundation
import SwiftData

@Model
class SavedMood {
    var date: Date
    var mood: Mood
    
    init(date: Date, mood: Mood) {
        self.date = date
        self.mood = mood
    }
}
