//
//  ClothingCategory.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation

enum ClothingCategory: String, CaseIterable, Codable, Identifiable {
    case top = "Top"
    case bottom = "Bottom"
    case singlePiece = "Single-Piece"
    case outerWear = "Outerwear"

    var id: String { rawValue }

    var wearabilityMultiplier: Double {
        switch self {
        case .top, .singlePiece: return 1.0
        case .bottom: return 1.5
        case .outerWear: return 5.0
        }
    }
}
