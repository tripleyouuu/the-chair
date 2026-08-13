//
//  ClothesPersistence.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation

// Everything about *where* clothes data is saved lives here — ClothesStore
// shouldn't know or care that it's UserDefaults today.
struct ClothesPersistence {
    private let storageKey = "clothes"

    func load() -> [ClothingItem]? {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([ClothingItem].self, from: data) else {
            return nil
        }
        return decoded
    }

    func save(_ clothes: [ClothingItem]) {
        guard let data = try? JSONEncoder().encode(clothes) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
