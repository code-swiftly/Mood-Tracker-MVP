//
//  Mood.swift
//  Mood Tracker
//
//  Created by Andy Couto on 12/26/24.
//

import Foundation
import SwiftUI
import AppIntents

enum Mood: String, CaseIterable, Codable, AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Mood"
    }
    
    static var caseDisplayRepresentations: [Mood: DisplayRepresentation] {
        [
            .veryUnpleasant: "😭 very unpleasant",
            .unpleasant: "☹️ unpleasant",
            .neutral: "😕 neutral",
            .pleasant: "🙂 pleasant",
            .veryPleasant: "😁 very pleasant",
            .unknown: "😐 unknown"
        ]
    }
    
    case veryUnpleasant = "Very Unpleasant"
    case unpleasant = "Unpleasant"
    case neutral = "Neutral"
    case pleasant = "Pleasant"
    case veryPleasant = "Very Pleasant"
    case unknown = "Unknown"
    
    var color: Color
    {
        switch self
        {
        case .veryUnpleasant: return .red
        case .unpleasant: return .orange
        case .neutral: return .yellow
        case .pleasant: return .green
        case .veryPleasant: return .blue
        case .unknown: return .mint
        }
    }
}
