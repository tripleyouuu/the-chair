//
//  ClothesStore+Queries.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation

extension ClothesStore {
    // Pile Verdict, currently-tracked items need a wash right now.
    func itemsNeedingWash() -> [ClothingItem] {
        clothes.filter { $0.needsWash }
    }

    // wash-every-wear materials/colors
    func urgentWashItems() -> [ClothingItem] {
        clothes.filter { $0.isUrgentWash }
    }

    // Add to Clothes Never Worn Before
    func neverWornItems() -> [ClothingItem] {
        clothes.filter { $0.wearSessions.isEmpty }
    }

    // Filtered Wardrobe by category, color, or silhouette.
    func items(in category: ClothingCategory) -> [ClothingItem] {
        clothes.filter { $0.clothingCategory == category }
    }

    func items(withColor color: ClothingColor) -> [ClothingItem] {
        clothes.filter { $0.clothingColor == color }
    }

    func items(withSilhouette silhouette: ClothingSilhouette) -> [ClothingItem] {
        clothes.filter { $0.silhouette == silhouette }
    }

    // Items sitting in a specific location (Pile, Washing List, or Wardrobe)
    func items(in location: ClothingLocation) -> [ClothingItem] {
        clothes.filter { $0.location == location }
    }
}
