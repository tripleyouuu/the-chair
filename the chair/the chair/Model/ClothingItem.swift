//
//  ClothingItem.swift
//  
//
//  Created by Aurora Purnawan on 11/08/26.
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

struct ClothingItem: Identifiable, Codable {
    let id: UUID
    var nickname: String?
    var clothingMaterial: ClothingMaterial
    var clothingColor: ClothingColor
    var clothingCategory: ClothingCategory
    var wearSessions: [WearSession]

    init(
        id: UUID = UUID(),
        nickname: String? = nil,
        clothingMaterial: ClothingMaterial,
        clothingColor: ClothingColor,
        clothingCategory: ClothingCategory,
        wearSessions: [WearSession] = []
    ) {
        self.id = id
        self.nickname = nickname
        self.clothingMaterial = clothingMaterial
        self.clothingColor = clothingColor
        self.clothingCategory = clothingCategory
        self.wearSessions = wearSessions
    }

    // Lookup key for design's silhouette set assets, this is just the name they'll match against.
    var silhouetteAssetName: String {
        let name = String(describing: clothingCategory)
        return "silhouette" + name.prefix(1).uppercased() + name.dropFirst()
    }

    var totalWearability: Double {
        clothingMaterial.baseHours * clothingCategory.wearabilityMultiplier * clothingColor.multiplier(with: clothingMaterial)
    }

    var usedWearability: Double {
        wearSessions.reduce(0) { $0 + $1.usedWearability }
    }

    var wearabilityRemaining: Double {
        totalWearability - usedWearability
    }

    var needsWash: Bool {
        guard !wearSessions.isEmpty else { return false }
        return wearabilityRemaining <= 0
    }
}

