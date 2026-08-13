//
//  ClothesStore.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Combine
import Foundation

final class ClothesStore: ObservableObject {
    @Published var clothes: [ClothingItem] = []

    let persistence = ClothesPersistence()

    init() {
        if let saved = persistence.load() {
            clothes = saved
        } else {
            seedMockData()
        }
    }

    func seedMockData() {
        clothes = [
            ClothingItem(nickname: "Everyday Tee", clothingMaterial: .natural, clothingColor: .white, silhouette: .tShirt, location: .wardrobe),
            ClothingItem(nickname: "Work Jeans", clothingMaterial: .denim, clothingColor: .blue, silhouette: .pants, location: .pile),
            ClothingItem(nickname: "Rain Jacket", clothingMaterial: .synthetic, clothingColor: .black, silhouette: .jacket, location: .wardrobe),
            ClothingItem(nickname: "Sunday Sweater", clothingMaterial: .wool, clothingColor: .gray, silhouette: .hoodie, location: .pile),
            ClothingItem(nickname: "Slip Dress", clothingMaterial: .silk, clothingColor: .red, silhouette: .dress, location: .washList),
        ]
        persistence.save(clothes)
    }
}
