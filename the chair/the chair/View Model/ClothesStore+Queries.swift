//
//  ClothesStore+Queries.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation

extension ClothesStore {
    
    var allClothes: [ClothingItem] { pile + closet + washList }

    // Pile Verdict
    func itemsNeedingWash() -> [ClothingItem] {
        allClothes.filter { $0.needsWash }
    }

    // Subset of itemsNeedingWash that can't wait
    func urgentWashItems() -> [ClothingItem] {
        allClothes.filter { $0.isUrgentWash }
    }

    // Add to Clothes Never Worn Before
    func neverWornItems() -> [ClothingItem] {
        allClothes.filter { $0.wearSessions.isEmpty }
    }

    // Filtered Wardrobe 
    func items(in category: ClothingCategory) -> [ClothingItem] {
        allClothes.filter { $0.clothingCategory == category }
    }

    func items(withColor color: ClothingColor) -> [ClothingItem] {
        allClothes.filter { $0.clothingColor == color }
    }

    func items(withSilhouette silhouette: ClothingSilhouette) -> [ClothingItem] {
        allClothes.filter { $0.silhouette == silhouette }
    }

    // Search 
    func search(_ query: String, within items: [ClothingItem]) -> [ClothingItem] {
        let needle = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !needle.isEmpty else { return items }

        return items.filter { item in
            let nicknameWords = (item.nickname ?? "").lowercased().split(separator: " ")
            if nicknameWords.contains(where: { $0.hasPrefix(needle) }) {
                return true
            }
            return item.clothingColor.rawValue.lowercased().contains(needle)
                || item.silhouette.rawValue.lowercased().contains(needle)
                || item.clothingMaterial.rawValue.lowercased().contains(needle)
        }
    }
}
