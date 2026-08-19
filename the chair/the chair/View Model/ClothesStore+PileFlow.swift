//
//  ClothesStore+PileFlow.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//


import Foundation

extension ClothesStore {
    // Closet -> Pile
    func addToPile(_ itemIDs: [UUID]) {
        var movedItems: [ClothingItem] = []
        closet.removeAll { item in
            guard itemIDs.contains(item.id) else { return false }
            var moved = item
            moved.location = .pile
            movedItems.append(moved)
            return true
        }
        pile.append(contentsOf: movedItems)
        savePersistence()
        validateNoDuplicatesOrLoss()
    }

    // Pile -> Laundry Bag
    func sendToLaundry(_ itemIDs: [UUID]) {
        var movedItems: [ClothingItem] = []
        pile.removeAll { item in
            guard itemIDs.contains(item.id) else { return false }
            var moved = item
            moved.location = .washList
            moved.savedEvaluation = nil
            moved.location = .washList
            movedItems.append(moved)
            return true
        }
        washList.append(contentsOf: movedItems)
        savePersistence()
        validateNoDuplicatesOrLoss()
    }

    // Laundry Bag -> Closet 
    func finishWashing(_ itemIDs: [UUID]) {
        var movedItems: [ClothingItem] = []
        washList.removeAll { item in
            guard itemIDs.contains(item.id) else { return false }
            var washed = item
            washed.savedEvaluation = nil
            washed.wearSessions.removeAll()
            washed.location = .wardrobe
            movedItems.append(washed)
            return true
        }
        closet.append(contentsOf: movedItems)
        savePersistence()
        validateNoDuplicatesOrLoss()
    }

    // Debug-only safety net — crashes loudly during development if an item ever ends up
    // in two arrays at once. Compiled out entirely in release builds, zero shipped cost.
    private func validateNoDuplicatesOrLoss() {
        #if DEBUG
        let allIDs = pile.map(\.id) + closet.map(\.id) + washList.map(\.id)
        let uniqueIDs = Set(allIDs)
        assert(
            allIDs.count == uniqueIDs.count,
            "An item exists in more than one of pile/closet/washList — check the last move operation."
        )
        #endif
    }
}
