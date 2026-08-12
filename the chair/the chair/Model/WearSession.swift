//
//  WearSession.swift
//  
//
//  Created by Aurora Purnawan on 11/08/26.
//

import Foundation

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
