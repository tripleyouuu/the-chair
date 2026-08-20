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
    case lightGreen = "Light Green"
    case darkGreen = "Dark Green"
    case lightTeal = "Light Teal"
    case darkTeal = "Dark Teal"
    case lightBlue = "Light Blue"
    case darkBlue = "Dark Blue"
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
}
