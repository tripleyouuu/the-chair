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
    case cottonLinen = "Cotton/Linen"
    case nylonPolyester = "Nylon/Polyester"
    case denim = "Denim"
    case wool = "Wool"

    var id: String { rawValue }

    var baseHours: Double {
        switch self {
        case .dryFit, .silk: return 0
        case .cottonLinen: return 16
        case .nylonPolyester: return 12
        case .denim: return 48
        case .wool: return 56
        }
    }
}
