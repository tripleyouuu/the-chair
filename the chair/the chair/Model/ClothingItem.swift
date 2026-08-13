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
    var silhouette: ClothingSilhouette
    var location: ClothingLocation
    var wearSessions: [WearSession]

    init(
        id: UUID = UUID(),
        nickname: String? = nil,
        clothingMaterial: ClothingMaterial,
        clothingColor: ClothingColor,
        silhouette: ClothingSilhouette,
        location: ClothingLocation = .pile,
        wearSessions: [WearSession] = []
    ) {
        self.id = id
        self.nickname = nickname
        self.clothingMaterial = clothingMaterial
        self.clothingColor = clothingColor
        self.silhouette = silhouette
        self.location = location
        self.wearSessions = wearSessions
    }

    // A silhouette only belongs to one category
    var clothingCategory: ClothingCategory {
        silhouette.category
    }

    // Lookup key for design's silhouette assets, this is the name they'll match.
    var silhouetteAssetName: String {
        let name = String(describing: silhouette)
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

    // Wash the instant it's worn (dry-fit, silk, white-on-non-denim/wool) 
    var isUrgentWash: Bool {
        needsWash && totalWearability == 0
    }
}
