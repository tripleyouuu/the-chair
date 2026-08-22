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
        clothesStore.washList
    }

    var body: some View {
        Group {
            if laundryItems.isEmpty {
                Text("Nothing to see here...") // UX writing hallelujah
                    .font(.subheadline)
                    .foregroundStyle(.sienna)
                    .opacity(0.8)
                    .background(
                        ZStack {
                            Color("backgroundBase")
                            Image("Texture")
                        }
                        .ignoresSafeArea()
                    )
            } else {
                List {
                    ForEach(laundryItems) { item in
                        HStack(spacing: 16) {
                            GarmentIconView(item: item)
                                .frame(width: 56, height: 56)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            Text(item.nickname ?? "Nickname")
                                .foregroundStyle(.deepBrown)

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
                                clothesStore.finishWashing([item.id])
                            } label: {
                                Image(systemName: "drop.degreesign")
                            }
                            .tint(.deepBlue)
                        }
                    }
                }
                .background(
                    ZStack {
                        Color("backgroundBase")
                        Image("Texture")
                    }
                    .ignoresSafeArea()
                )
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("LAUNDRY BAG")
                    .foregroundStyle(.deepBrown)
                    .font(Font.custom("SueEllenFrancisco", size: 32))
                    .padding(.top,8)
            }
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
                clothesStore.finishWashing(clothesStore.washList.map(\.id))
            }
            Button("Cancel", role: .cancel) {
            }
        } message: {
            Text("This will mark all clothes in the list as washed, and return them to the closet.")
        }
        .tint(.offWhite)
    }

}

#Preview {
    let store = ClothesStore()

    NavigationStack {
        LaundryBasketView(clothesStore: store)
    }
}
