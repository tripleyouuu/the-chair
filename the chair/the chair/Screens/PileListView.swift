//
//  PileListView.swift
//
//
//  Created by Vitha Watson on 13/08/26.
//

import SwiftUI

struct PileListView: View {
    @ObservedObject var clothesStore: ClothesStore
    @Binding var currentIndex: Int

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(
                    Array(clothesStore.clothes.enumerated().reversed()),
                    id: \.element.id
                ) { index, item in
                    Button {
                        currentIndex = index //picking an item from the list just goes to the og evalview instead of creating one for the chosen item and then returning
                        dismiss() //tells the listview to fuck itself instead of lodging in the navigation flow
                    } label: {
                        HStack {
                            GarmentIconView(item: item)
                                .frame(width: 56, height: 56)
                                .background(.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            Text(item.nickname ?? "Nickname")
                                .foregroundStyle(.primary)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.background)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Pile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let store = ClothesStore()
    store.seedMockData()

    return NavigationStack {
        PileListView(
            clothesStore: store,
            currentIndex: .constant(store.clothes.count - 1)
        )
    }
}
