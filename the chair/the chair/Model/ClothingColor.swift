//
//  ClothingColor.swift
//
//
//  Created by Aurora Purnawan on 12/08/26.
//

import SwiftUI

enum ClothingColor: String, CaseIterable, Codable, Identifiable {
    case white = "White"
    case black = "Black"
    case gray = "Grey"
    case beige = "Beige"
    case red = "Red"
    case lightGreen = "L. Green"
    case darkGreen = "D. Green"
    case lightTeal = "L. Teal"
    case darkTeal = "D. Teal"
    case lightBlue = "L. Blue"
    case darkBlue = "D. Blue"
    case pink = "Pink"
    case orange = "Orange"
    case yellow = "Yellow"
    case purple = "Purple"
    case brown = "Brown"

    var id: String { rawValue }

    func multiplier(with clothingMaterial: ClothingMaterial) -> Double {
        guard self == .white,
              clothingMaterial != .denim,
              clothingMaterial != .wool else {
            return 1.0
        }

        return 0.0
    }

    var swiftUIColor: Color {
        switch self {
        case .white:
            return .white
        case .black:
            return .black
        case .gray:
            return Color.gray
        case .beige:
            return Color(red: 0.76, green: 0.69, blue: 0.58)
        case .red:
            return .red
        case .lightGreen:
            return Color(red: 0.45, green: 0.72, blue: 0.42)
        case .darkGreen:
            return Color(red: 0.12, green: 0.38, blue: 0.20)
        case .lightTeal:
            return Color(red: 0.35, green: 0.72, blue: 0.70)
        case .darkTeal:
            return Color(red: 0.05, green: 0.40, blue: 0.42)
        case .lightBlue:
            return Color(red: 0.35, green: 0.60, blue: 0.90)
        case .darkBlue:
            return Color(red: 0.08, green: 0.25, blue: 0.55)
        case .pink:
            return .pink
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .purple:
            return .purple
        case .brown:
            return Color(red: 0.45, green: 0.28, blue: 0.16)
        }
    }
}
