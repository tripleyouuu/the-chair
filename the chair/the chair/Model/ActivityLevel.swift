//
//  ActivityLevel.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation

enum ActivityLevel: String, CaseIterable, Codable, Identifiable {
    case resting = "Resting"
    case light = "Light"
    case moderate = "Moderate"
    case active = "Active"
    case intense = "Intense"

    var id: String { rawValue }

    var multiplier: Double {
        switch self {
        case .resting: return 1.0
        case .light: return 1.37
        case .moderate: return 1.87
        case .active: return 2.5
        case .intense: return 3.5
        }
    }
}
