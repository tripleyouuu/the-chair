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
        smallCloset.removeAll { item in
            guard itemIDs.contains(item.id) else { return false }
            var moved = item
            moved.location = .pile
            movedItems.append(moved)
            return true
        }
        bigCloset.removeAll { item in
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
        for item in movedItems {
            addToClosetSection(item)
        }
        savePersistence()
        validateNoDuplicatesOrLoss()
    }
    private func addToClosetSection(_ item: ClothingItem) {
        let bigSilhouettes: Set<ClothingSilhouette> = [
            .dress,
            .jumpsuit,
            .pants,
            .miniDress
        ]
        var moved = item
        moved.location = .wardrobe
        if bigSilhouettes.contains(moved.silhouette) {
            bigCloset.append(moved)
            return
        }
        if smallCloset.isEmpty {
            smallCloset.append(moved)
            if smallCloset.count >= bigCloset.count {
                lastPopulatedClosetSection = .small
            }
        } else if bigCloset.isEmpty {
            bigCloset.append(moved)
            lastPopulatedClosetSection = .big
        } else if lastPopulatedClosetSection == .big {
            smallCloset.append(moved)
            if smallCloset.count >= bigCloset.count {
                lastPopulatedClosetSection = .small
            }
        } else {
            bigCloset.append(moved)
            lastPopulatedClosetSection = .big
        }
    }
    // Debug-only safety net — crashes loudly during development if an item ever ends up
    // in two arrays at once. Compiled out entirely in release builds, zero shipped cost.
    private func validateNoDuplicatesOrLoss() {
        #if DEBUG
        let allIDs = pile.map(\.id) + smallCloset.map(\.id) + bigCloset.map(\.id) + washList.map(\.id)
        let uniqueIDs = Set(allIDs)
        assert(
            allIDs.count == uniqueIDs.count,
            "An item exists in more than one of pile/smallCloset/bigCloset/washList — check the last move operation."
        )
        #endif
    }
}
