//
//  ClothingItem.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation

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

    // Lookup key for design's silhouette set assets, this is just the name they'll match.
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
