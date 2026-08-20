//
//  ClothingMaterial.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation

enum ClothingMaterial: String, CaseIterable, Codable, Identifiable {
    case dryFit = "Dry-Fit"
    case silk = "Silk"
    case natural = "Natural"
    case synthetic = "Synthetic"
    case denim = "Denim"
    case wool = "Wool"

    var id: String { rawValue }

    var baseHours: Double {
        switch self {
        case .dryFit: return 0
        case .silk: return 9999
        case .natural: return 16
        case .synthetic: return 12
        case .denim: return 48
        case .wool: return 56
        }
    }
}
