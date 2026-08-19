//
//  ClothesStore+CRUD.swift
//  
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

    func deleteItem(_ itemID: UUID) {
        pile.removeAll { $0.id == itemID }
        closet.removeAll { $0.id == itemID }
        washList.removeAll { $0.id == itemID }
        savePersistence()
    }

    func logWear(for itemID: UUID, session: WearSession) {
        if let index = pile.firstIndex(where: { $0.id == itemID }) {
            pile[index].wearSessions.append(session)
        } else if let index = closet.firstIndex(where: { $0.id == itemID }) {
            closet[index].wearSessions.append(session)
        } else if let index = washList.firstIndex(where: { $0.id == itemID }) {
            washList[index].wearSessions.append(session)
        } else {
            return
        }
        savePersistence()
    }
}
