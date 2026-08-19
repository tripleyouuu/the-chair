//
//  HomeView.swift
//
//
//  Created by Vitha Watson on 13/08/26.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var clothesStore: ClothesStore
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()

                Text("Clothes saved from over-washing: 67") // hehe kill me
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Image(systemName: "chair")
                    .font(.system(size: 240))
                    .foregroundStyle(.secondary)
                    .frame(maxHeight: 280)

                Spacer()

                VStack(spacing: 16) {
                    NavigationLink {
                        EvaluationView(clothesStore: clothesStore)
                    } label: {
                        Text("Evaluate")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 24)
                    .disabled(clothesStore.pile.isEmpty)

                    Text("The Chair isn't the problem, it's the solution!")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .navigationTitle("The Chair")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    VStack(spacing: 4) {
                        NavigationLink {
                            LaundryBasketView(clothesStore: clothesStore)
                        } label: {
                            Image(systemName: "washer")
                                .font(.title)
                                .frame(width: 44, height: 44)
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)

                        Text("Laundry bag")
                            .font(.caption)
                            .foregroundStyle(.primary)
                    }

                    Spacer()

                    VStack(spacing: 4) {
                        Menu {
                            NavigationLink{
                                AddClothesView()
                            } label : {
                                Text("Add new")
                            }
                            NavigationLink{
                                AddFromClosetView(clothesStore: clothesStore)
                            } label : {
                                Text("Add from closet")
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .frame(width: 44, height: 44)
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)

                        Text("Add to pile")
                            .font(.caption)
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }
        }
    }
}

#Preview {
    let store = ClothesStore()

    HomeView(clothesStore: store)
}
