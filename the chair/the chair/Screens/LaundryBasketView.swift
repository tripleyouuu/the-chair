//
//  LaundryBasketView.swift
//  the chair
//
//  Created by Vitha Watson on 14/08/26.
//

import SwiftUI

struct LaundryBasketView: View {
    @ObservedObject var clothesStore: ClothesStore

    @State private var showClearAlert = false

    private var laundryItems: [ClothingItem] {
        clothesStore.clothes.filter { $0.location == .washList }
    }

    var body: some View {
        Group {
            if laundryItems.isEmpty {
                Text("Nothing to see here...") // UX writing hallelujah
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                List {
                    ForEach(laundryItems) { item in
                        HStack(spacing: 16) {
                            Image(systemName: "tshirt")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                                .frame(width: 56, height: 56)
                                .background(.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            Text(item.nickname ?? "Nickname")
                                .foregroundStyle(.primary)

                            Spacer()
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(.background)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .listRowInsets(
                            EdgeInsets(
                                top: 8,
                                leading: 16,
                                bottom: 8,
                                trailing: 16
                            )
                        )
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                removeFromLaundry(item)
                            } label: {
                                Image(systemName: "drop.degreesign")
                            }
                            .tint(.blue)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Laundry Basket")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showClearAlert = true
                } label: {
                    Image(systemName: "bubbles.and.sparkles")
                }
                .disabled(laundryItems.isEmpty)
            }
        }
        .alert("Clear laundry basket", isPresented: $showClearAlert) {
            Button("Confirm", role: .destructive) {
                clearLaundryBasket()
            }

            Button("Cancel", role: .cancel) {
            }
        } message: {
            Text("This will mark all clothes in the list as washed, and return them to the closet.")
        }
    }

    private func removeFromLaundry(_ item: ClothingItem) {
        guard let index = clothesStore.clothes.firstIndex(where: { $0.id == item.id }) else {
            return
        }

        clothesStore.clothes[index].location = .wardrobe
        clothesStore.persistence.save(clothesStore.clothes)

        print("\(item.nickname ?? "Garment") has been returned to the closet.")
    }

    private func clearLaundryBasket() {
        for index in clothesStore.clothes.indices {
            if clothesStore.clothes[index].location == .washList {
                print("\(clothesStore.clothes[index].nickname ?? "Garment") has been returned to the closet.")
                clothesStore.clothes[index].location = .wardrobe
            }
        }

        clothesStore.persistence.save(clothesStore.clothes)
    }
}

#Preview {
    let store = ClothesStore()
    store.seedMockData()

    return NavigationStack {
        LaundryBasketView(clothesStore: store)
    }
}
