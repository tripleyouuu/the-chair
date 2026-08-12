//
//  ClothesStore.swift
//  
//
//  Created by Aurora Purnawan on 11/08/26.
//

import Combine
import Foundation

final class ClothesStore: ObservableObject {
    @Published var clothes: [ClothingItem] = []

    func loadStuff() {
        clothes = [
            ClothingItem(nickname: "Everyday Tee", clothingMaterial: .cottonLinen, clothingColor: .white, clothingCategory: .top),
            ClothingItem(nickname: "Work Jeans", clothingMaterial: .denim, clothingColor: .blue, clothingCategory: .bottom),
            ClothingItem(nickname: "Rain Jacket", clothingMaterial: .nylonPolyester, clothingColor: .black, clothingCategory: .outerWear),
            ClothingItem(nickname: "Sunday Sweater", clothingMaterial: .wool, clothingColor: .gray, clothingCategory: .top),
            ClothingItem(nickname: "Slip Dress", clothingMaterial: .silk, clothingColor: .red, clothingCategory: .singlePiece),
        ]
        // Hardcoded for now. Swap when there's something that can be fetched from. 
    }
}
