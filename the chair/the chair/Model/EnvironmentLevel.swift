//
//  EnvironmentLevel.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation

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
