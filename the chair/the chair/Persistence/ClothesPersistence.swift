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
        var closet: [ClothingItem]
        var washList: [ClothingItem]
    }

    func load() -> (pile: [ClothingItem], closet: [ClothingItem], washList: [ClothingItem])? {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode(PersistedClothes.self, from: data) else {
            return nil
        }
        return (decoded.pile, decoded.closet, decoded.washList)
    }

    func save(pile: [ClothingItem], closet: [ClothingItem], washList: [ClothingItem]) {
        let bundle = PersistedClothes(pile: pile, closet: closet, washList: washList)
        guard let data = try? JSONEncoder().encode(bundle) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
