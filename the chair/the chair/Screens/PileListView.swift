//
//  PileListView.swift
//
//  Created by Vitha Watson on 13/08/26.
//

import SwiftUI

struct PileListView: View {
    @ObservedObject var clothesStore: ClothesStore
    @Binding var currentIndex: Int
    @Binding var selectionVersion: Int
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(
                    Array(clothesStore.pile.enumerated().reversed()),
                    id: \.element.id
                ) { index, item in
                    Button {
                        currentIndex = index
                        selectionVersion += 1
                        dismiss()
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("PILE")
                    .font(Font.custom("SueEllenFrancisco", size: 32))
                    .padding(.top,8)
            }
        }
    }
}

#Preview {
    let store = ClothesStore()

    NavigationStack {
        PileListView(
            clothesStore: store,
            currentIndex: .constant(store.pile.count - 1),
            selectionVersion: .constant(0)
        )
    }
}
