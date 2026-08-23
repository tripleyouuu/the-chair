//
//  ClothesStore.swift
//
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Combine
import Foundation

extension Array where Element == ClothingItem {
    func filtered(by silhouettes: [ClothingSilhouette]) -> [ClothingItem] {
        return self.filter { silhouettes.contains($0.silhouette) }
    }
}

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
            // Tops
            ClothingItem(
                nickname: "Basic White Tee",
                clothingMaterial: .natural,
                clothingColor: .white,
                silhouette: .tShirt,
                location: .wardrobe,
                referenceImageName: "thumbnail"
            ),
            ClothingItem(
                nickname: "Office Button Up",
                clothingMaterial: .natural,
                clothingColor: .white,
                silhouette: .buttonUpShirt,
                location: .wardrobe,
                referenceImageName: "thumbnail"
            ),
            ClothingItem(
                nickname: "Gym Tank",
                clothingMaterial: .synthetic,
                clothingColor: .black,
                silhouette: .tankTop,
                location: .wardrobe,
                referenceImageName: "thumbnail"
            ),

            // Bottoms
            ClothingItem(
                nickname: "Work Slacks",
                clothingMaterial: .synthetic,
                clothingColor: .black,
                silhouette: .pants,
                location: .wardrobe,
                referenceImageName: "thumbnail"
            ),
            ClothingItem(
                nickname: "Lounge Shorts",
                clothingMaterial: .natural,
                clothingColor: .black,
                silhouette: .shorts,
                location: .wardrobe,
                referenceImageName: "thumbnail"
            ),
            ClothingItem(
                nickname: "Pleated Skirt",
                clothingMaterial: .synthetic,
                clothingColor: .black,
                silhouette: .skirt,
                location: .wardrobe,
                referenceImageName: "thumbnail"
            ),

            // Full Body
            ClothingItem(
                nickname: "Maxi Dress",
                clothingMaterial: .natural,
                clothingColor: .white,
                silhouette: .dress,
                location: .wardrobe,
                referenceImageName: "thumbnail"
            ),
            ClothingItem(
                nickname: "Party Mini",
                clothingMaterial: .synthetic,
                clothingColor: .black,
                silhouette: .miniDress,
                location: .wardrobe,
                referenceImageName: "thumbnail"
            ),
            ClothingItem(
                nickname: "Utility Jumpsuit",
                clothingMaterial: .natural,
                clothingColor: .black,
                silhouette: .jumpsuit,
                location: .wardrobe,
                referenceImageName: "thumbnail"
            ),

            // Outerwear
            ClothingItem(
                nickname: "Rain Jacket",
                clothingMaterial: .synthetic,
                clothingColor: .black,
                silhouette: .jacket,
                location: .wardrobe,
                referenceImageName: "thumbnail"
            ),
            ClothingItem(
                nickname: "Knit Cardigan",
                clothingMaterial: .natural,
                clothingColor: .white,
                silhouette: .cardigan,
                location: .wardrobe,
                referenceImageName: "thumbnail"
            ),
            ClothingItem(
                nickname: "Workout Hoodie",
                clothingMaterial: .synthetic,
                clothingColor: .black,
                silhouette: .hoodie,
                location: .wardrobe,
                referenceImageName: "thumbnail"
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
