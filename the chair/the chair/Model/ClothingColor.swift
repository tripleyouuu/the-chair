//
//  ClothingColor.swift
//
//
//  Created by Aurora Purnawan on 12/08/26.
//

import SwiftUI

enum ClothingColor: String, CaseIterable, Codable, Identifiable {
    case red = "Red"
    case orange = "Orange"
    case yellow = "Yellow"
    case beige = "Beige"
    case lightGreen = "Light Green"
    case darkGreen = "Dark Green"
    case darkTeal = "Dark Teal"
    case lightTeal = "Light Teal"
    case lightBlue = "Light Blue"
    case darkBlue = "Dark Blue"
    case purple = "Purple"
    case pink = "Pink"
    case gray = "Grey"
    case brown = "Brown"
    case white = "White"
    case black = "Black"

    var id: String { rawValue }

    func multiplier(with clothingMaterial: ClothingMaterial) -> Double {
        guard self == .white,
              clothingMaterial != .denim,
              clothingMaterial != .wool else {
            return 1.0
        }

        return 0.0
    }
}
