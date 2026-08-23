//
//  ClothesPersistence.swift
//
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation
// Everything about *where* clothes data is saved lives here
struct ClothesPersistence {
    private let storageKey = "clothes"
    private struct PersistedClothes: Codable {
        var pile: [ClothingItem]
        var smallCloset: [ClothingItem]
        var bigCloset: [ClothingItem]
        var washList: [ClothingItem]
        var lastPopulatedClosetSection: String
    }
    func load() -> (pile: [ClothingItem], smallCloset: [ClothingItem], bigCloset: [ClothingItem], washList: [ClothingItem], lastPopulatedClosetSection: String)? {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode(PersistedClothes.self, from: data) else {
            return nil
        }
        return (decoded.pile, decoded.smallCloset, decoded.bigCloset, decoded.washList, decoded.lastPopulatedClosetSection)
    }
    func save(pile: [ClothingItem], smallCloset: [ClothingItem], bigCloset: [ClothingItem], washList: [ClothingItem], lastPopulatedClosetSection: String) {
        let bundle = PersistedClothes(
            pile: pile,
            smallCloset: smallCloset,
            bigCloset: bigCloset,
            washList: washList,
            lastPopulatedClosetSection: lastPopulatedClosetSection
        )
        guard let data = try? JSONEncoder().encode(bundle) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
