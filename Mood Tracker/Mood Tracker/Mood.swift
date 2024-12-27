//
//  Mood.swift
//  Mood Tracker
//
//  Created by Andy Couto on 12/26/24.
//

import Foundation
import SwiftUI

enum Mood: String, CaseIterable, Codable {
    case veryUnpleasant = "Very Unpleasant"
    case unpleasant = "Unpleasant"
    case neutral = "Neutral"
    case pleasant = "Pleasant"
    case veryPleasant = "Very Pleasant"
    
    var color: Color
    {
        switch self
        {
        case .veryUnpleasant: return .red
        case .unpleasant: return .orange
        case .neutral: return .yellow
        case .pleasant: return .green
        case .veryPleasant: return .blue
        }
    }
}
