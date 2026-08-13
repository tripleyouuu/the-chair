//
//  ClothesStore+PileFlow.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation

extension ClothesStore {
    // Verdict said "needs wash" and the user agreed, queue it in the laundry bucket (only relocates it)
    func moveToWashList(_ itemID: UUID) {
        setLocation(.washList, for: itemID)
    }

    // Verdict said it's still wearable, back into active rotation
    func moveToPile(_ itemID: UUID) {
        setLocation(.pile, for: itemID)
    }

    // User did the laundry, reset the wear count and send it back to the wardrobe
    func markWashed(_ itemID: UUID) {
        guard let index = clothes.firstIndex(where: { $0.id == itemID }) else { return }
        clothes[index].wearSessions.removeAll()
        clothes[index].location = .wardrobe
        persistence.save(clothes)
    }

    // Only moveToWashList/moveToPile above (same file) can call this
    private func setLocation(_ location: ClothingLocation, for itemID: UUID) {
        guard let index = clothes.firstIndex(where: { $0.id == itemID }) else { return }
        clothes[index].location = location
        persistence.save(clothes)
    }
}
