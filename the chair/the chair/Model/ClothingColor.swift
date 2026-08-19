//
//  ClothingColor.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation

enum ClothingColor: String, CaseIterable, Codable, Identifiable {
    case white = "White"
    case black = "Black"
    case gray = "Gray"
    case red = "Red"
    case yellow = "Yellow"
    case orange = "Orange"
    case green = "Green"
    case blue = "Blue"
    case purple = "Purple"
    case pink = "Pink"
    case brown = "Brown"
    case cream = "Cream"

    var id: String { rawValue }
    var hexCode: String {
        switch self {
        case .white: return "#F2F1F6"
        case .black: return "#1C1C1E"
        case .gray: return "#A9ABB1"
        case .red: return "#EF5350"
        case .yellow: return "#F6C744"
        case .orange: return "#F2994A"
        case .green: return "#66BB6A"
        case .blue: return "#3B82F6"
        case .purple: return "#5352ED"
        case .pink: return "#F0B8F7"
        case .brown: return "#9C7A5C"
        case .cream: return "#FAF3D0"
        }
    }

    func multiplier(with clothingMaterial: ClothingMaterial) -> Double {
        guard self == .white, clothingMaterial != .denim, clothingMaterial != .wool else { return 1.0 }
        return 0.0
    }
}
