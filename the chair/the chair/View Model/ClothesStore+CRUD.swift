//
//  ClothesStore+CRUD.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation

extension ClothesStore {
    func addItem(_ item: ClothingItem) {
        clothes.append(item)
        persistence.save(clothes)
    }

    func deleteItem(_ itemID: UUID) {
        clothes.removeAll { $0.id == itemID }
        persistence.save(clothes)
    }

    func logWear(for itemID: UUID, session: WearSession) {
        guard let index = clothes.firstIndex(where: { $0.id == itemID }) else { return }
        clothes[index].wearSessions.append(session)
        persistence.save(clothes)
    }
}
