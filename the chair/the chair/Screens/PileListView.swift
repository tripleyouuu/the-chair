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
    @Binding var toast: Toast?
//    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(
                    Array(clothesStore.pile.enumerated().reversed()),
                    id: \.element.id
                ) { index, item in
                    NavigationLink {
                        EvaluationView(
                            clothesStore: clothesStore,
                            initialIndex: index,
                            toast: $toast
                        )
                    } label: {
                        HStack {
                            GarmentIconView(item: item)
                                .frame(width: 56, height: 56)
//                                .background(.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            Text(item.nickname ?? "Nickname")
                                .foregroundStyle(.deepBrown)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.sienna)
                                .opacity(0.8)
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
        .background(
            ZStack {
                Color("backgroundBase")
                Image("Texture")
            }
            .ignoresSafeArea()
        )
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("PILE")
                    .font(Font.custom("SueEllenFrancisco", size: 32))
                    .padding(.top,8)
            }
        }
        .backButton(.custom)
    }
}

#Preview {
    let store = ClothesStore()

    NavigationStack {
        PileListView(
            clothesStore: store,
            currentIndex: .constant(store.pile.count - 1),
            selectionVersion: .constant(0),
            toast: .constant(nil)
        )
    }
}
