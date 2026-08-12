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

    var id: String { rawValue }

    func multiplier(with clothingMaterial: ClothingMaterial) -> Double {
        guard self == .white, clothingMaterial != .denim, clothingMaterial != .wool else { return 1.0 }
        return 0.0
    }
}
