//
//  ClothesStore+CRUD.swift
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation
extension ClothesStore {
    // New items always start in the pile.
    func addItem(_ item: ClothingItem) {
        pile.append(item)
        savePersistence()
    }
    // Add Bulk Function to the Pile. several new items in one go, one save at the end.
    func addItems(_ items: [ClothingItem]) {
        pile.append(contentsOf: items)
        savePersistence()
    }
    func updateClosetItem(_ updatedItem: ClothingItem) {
        var updatedItem = updatedItem
        updatedItem.location = .wardrobe
        if let index = smallCloset.firstIndex(where: { $0.id == updatedItem.id }) {
            smallCloset[index] = updatedItem
        } else if let index = bigCloset.firstIndex(where: { $0.id == updatedItem.id }) {
            bigCloset[index] = updatedItem
        } else {
            return
        }
        rebalanceClosetSections()
        savePersistence()
    }
    func deleteItem(_ itemID: UUID) {
        pile.removeAll { $0.id == itemID }
        let removedFromSmall = smallCloset.firstIndex(where: { $0.id == itemID })
        if let index = removedFromSmall {
            smallCloset.remove(at: index)
            rebalanceClosetSections()
        } else if let index = bigCloset.firstIndex(where: { $0.id == itemID }) {
            bigCloset.remove(at: index)
            rebalanceClosetSections()
        }
        washList.removeAll { $0.id == itemID }
        print("YES ITS WORKING")
        savePersistence()
    }
    func logWear(for itemID: UUID, session: WearSession) {
        if let index = pile.firstIndex(where: { $0.id == itemID }) {
            pile[index].wearSessions.append(session)
        } else if let index = smallCloset.firstIndex(where: { $0.id == itemID }) {
            smallCloset[index].wearSessions.append(session)
        } else if let index = bigCloset.firstIndex(where: { $0.id == itemID }) {
            bigCloset[index].wearSessions.append(session)
        } else if let index = washList.firstIndex(where: { $0.id == itemID }) {
            washList[index].wearSessions.append(session)
        } else {
            return
        }

        savePersistence()
    }
    
    func rebalanceClosetSections() {
        let bigSilhouettes: Set<ClothingSilhouette> = [
            .dress,
            .jumpsuit,
            .pants,
            .miniDress
        ]
        let allCloset = smallCloset + bigCloset
        let forcedBigItems = allCloset.filter {
            bigSilhouettes.contains($0.silhouette)
        }
        let flexibleItems = allCloset.filter {
            !bigSilhouettes.contains($0.silhouette)
        }
        let previousLastPopulatedSection = lastPopulatedClosetSection
        let desiredSmallCount = min(
            flexibleItems.count,
            max(0, (allCloset.count - forcedBigItems.count + 1) / 2)
        )
        smallCloset = Array(flexibleItems.prefix(desiredSmallCount))
        bigCloset = forcedBigItems + Array(flexibleItems.dropFirst(desiredSmallCount))
        if smallCloset.count == bigCloset.count {
            lastPopulatedClosetSection = previousLastPopulatedSection
        } else if smallCloset.count > bigCloset.count {
            lastPopulatedClosetSection = .small
        } else {
            lastPopulatedClosetSection = .big
        }
    }
}
