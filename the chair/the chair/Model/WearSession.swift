//
//  WearSession.swift
//  
//
//  Created by Aurora Purnawan on 11/08/26.
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

enum EnvironmentLevel: String, CaseIterable, Codable, Identifiable {
    case cold = "Cold"
    case cool = "Cool"
    case mild = "Mild"
    case warm = "Warm"
    case hot = "Hot"

    var id: String { rawValue }

    var multiplier: Double {
        switch self {
        case .cold: return 1.0
        case .cool: return 1.25
        case .mild: return 1.5
        case .warm: return 1.75
        case .hot: return 2.0
        }
    }
}

struct WearSession: Identifiable, Codable {
    let id: UUID
    var date: Date
    var hoursWorn: Double
    var activityLevel: ActivityLevel
    var environment: EnvironmentLevel

    init(
        id: UUID = UUID(),
        date: Date = .now,
        hoursWorn: Double,
        activityLevel: ActivityLevel,
        environment: EnvironmentLevel
    ) {
        self.id = id
        self.date = date
        self.hoursWorn = hoursWorn
        self.activityLevel = activityLevel
        self.environment = environment
    }

    var usedWearability: Double {
        hoursWorn * activityLevel.multiplier * environment.multiplier
    }
}
