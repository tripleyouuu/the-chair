//
//  ClothesStore.swift
//
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Combine
import Foundation

final class ClothesStore: ObservableObject {
    // The move-between-arrays risk is contained in
    // ClothesStore+PileFlow.swift's single moveItem helper, and a debug-only consistency check.
    @Published var pile: [ClothingItem] = []
    @Published var closet: [ClothingItem] = []
    @Published var washList: [ClothingItem] = []

    let persistence = ClothesPersistence()

    init() {
        if let saved = persistence.load() {
            pile = saved.pile
            closet = saved.closet
            washList = saved.washList
        } else {
            seedMockData()
        }
    }

    private func seedMockData() {
        pile = [
            ClothingItem(
                nickname: "Work Jeans",
                clothingMaterial: .denim,
                clothingColor: .darkBlue,
                silhouette: .pants,
                location: .pile
            ),
            ClothingItem(
                nickname: "Sunday Sweater",
                clothingMaterial: .wool,
                clothingColor: .gray,
                silhouette: .hoodie,
                location: .pile
            )
        ]

        closet = [
            ClothingItem(
                nickname: "Everyday Tee",
                clothingMaterial: .natural,
                clothingColor: .white,
                silhouette: .tShirt,
                location: .wardrobe,
                referenceImageName: "testCircle"
            ),
            ClothingItem(
                nickname: "Rain Jacket",
                clothingMaterial: .synthetic,
                clothingColor: .black,
                silhouette: .jacket,
                location: .wardrobe,
                referenceImageName: "testCircle"
            )
        ]

        washList = [
            ClothingItem(
                nickname: "Slip Dress",
                clothingMaterial: .silk,
                clothingColor: .red,
                silhouette: .dress,
                location: .washList
            )
        ]
        savePersistence()
    }

    func savePersistence() {
        persistence.save(
            pile: pile,
            closet: closet,
            washList: washList
        )
    }
}
