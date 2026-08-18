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
    @Published var closetClothes: [ClothingItem] = []

    let persistence = ClothesPersistence()

    init() {
        if let saved = persistence.load() {
            clothes = saved
        } else {
            seedMockData()
        }
    }

    // TODO: make it so that data for different places are placed in separate arrays so that the pile, closet and wash clothes have different arrays
    func seedMockData() {
        clothes = [
            ClothingItem(nickname: "Everyday Tee", clothingMaterial: .natural, clothingColor: .white, silhouette: .tShirt, location: .pile),
            ClothingItem(nickname: "Work Jeans", clothingMaterial: .denim, clothingColor: .blue, silhouette: .pants, location: .pile),
            ClothingItem(nickname: "Rain Jacket", clothingMaterial: .synthetic, clothingColor: .black, silhouette: .jacket, location: .pile),
            ClothingItem(nickname: "Sunday Sweater", clothingMaterial: .wool, clothingColor: .gray, silhouette: .hoodie, location: .pile),
            ClothingItem(nickname: "Slip Dress", clothingMaterial: .silk, clothingColor: .red, silhouette: .dress, location: .pile),
        ]
        persistence.save(clothes)
    }
    
    // TODO: delete this function later
    func seedMockCloset() {
        closetClothes = [
            ClothingItem(nickname: "Everyday Tee", clothingMaterial: .natural, clothingColor: .white, silhouette: .tShirt, location: .wardrobe),
            ClothingItem(nickname: "Work Jeans", clothingMaterial: .denim, clothingColor: .blue, silhouette: .pants, location: .wardrobe),
            ClothingItem(nickname: "Rain Jacket", clothingMaterial: .synthetic, clothingColor: .black, silhouette: .jacket, location: .wardrobe),
            ClothingItem(nickname: "Sunday Sweater", clothingMaterial: .wool, clothingColor: .gray, silhouette: .hoodie, location: .wardrobe),
            ClothingItem(nickname: "Slip Dress", clothingMaterial: .silk, clothingColor: .red, silhouette: .dress, location: .wardrobe),
            ClothingItem(nickname: "Everyday Tee", clothingMaterial: .natural, clothingColor: .white, silhouette: .tShirt, location: .wardrobe),
            ClothingItem(nickname: "Work Jeans", clothingMaterial: .denim, clothingColor: .blue, silhouette: .pants, location: .wardrobe),
            ClothingItem(nickname: "Rain Jacket", clothingMaterial: .synthetic, clothingColor: .black, silhouette: .jacket, location: .wardrobe),
            ClothingItem(nickname: "Sunday Sweater", clothingMaterial: .wool, clothingColor: .gray, silhouette: .hoodie, location: .wardrobe),
            ClothingItem(nickname: "Slip Dress", clothingMaterial: .silk, clothingColor: .red, silhouette: .dress, location: .wardrobe)
        ]
        persistence.save(closetClothes)
    }
}
