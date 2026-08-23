//
//  HomeView.swift
//
//
//  Created by Vitha Watson on 13/08/26.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var clothesStore: ClothesStore
    @AppStorage("clothesSavedFromOverWashing") private var clothesSavedFromOverWashing = 0
    @State private var toast: Toast?
    @State private var path = NavigationPath()
    
    private var chairAssetName: String {
        switch clothesStore.pile.count {
        case 0:
            return "Empty Chair"
        case 1:
            return "Chair 1"
        case 2:
            return "Chair 2"
        case 3:
            return "Chair 3"
        case 4:
            return "Chair 4"
        case 5...8:
            return "Chair 5-8"
        case 9...12:
            return "Chair 9-12"
        default:
            return "Max Chair"
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 16) {
                Spacer()

                Text("Clothes saved from over-washing: \(clothesSavedFromOverWashing)") // when i use this app and it hits 67 i will stop using the app
                    .foregroundStyle(.sienna)
                    .opacity(0.8)
                Spacer()

                NavigationLink(value: ClothesRoute.pileList) {
                    Image(chairAssetName)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)
                        .frame(maxHeight: 280)
                }
                .buttonStyle(.plain)

                Spacer()

                VStack(spacing: 16) {
                    NavigationLink(value: ClothesRoute.evaluate(index: nil)) {
                        ZStack{
                            Image(clothesStore.pile.isEmpty ? "grayButton" : "siennaButton")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.secondary)
                            Text("Evaluate")
                                .font(.headline)
                                .foregroundStyle(.offWhite)
                        }
                    }
                    .tint(.sienna)
                    .padding(.horizontal, 24)
                    .disabled(clothesStore.pile.isEmpty)
                    // TODO: disabled asset needed for fat button

                    Text("The Chair isn't the problem, it's the solution!")
                        .font(.subheadline)
                        .foregroundStyle(.sienna)
                        .opacity(0.8)
                }

                Spacer()
            }
            .background(
                ZStack {
                    Color("backgroundBase")
                    Image("Texture")
                }
                .ignoresSafeArea()
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("THE CHAIR")
                        .font(Font.custom("SueEllenFrancisco", size: 48))
                        .fontDesign(nil)
                        .foregroundStyle(.deepBrown)
                        .padding(.top, 160)
                    }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        NotificationsSettingsView(
                            notificationsStore: NotificationsStore()
                        )
                    } label: {
                        ZStack{
                            Image("secondaryButton")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.secondary)
                                .frame(maxWidth:44)
                            Image(systemName: "gearshape")
                                .foregroundStyle(.sienna)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .sharedBackgroundVisibility(.hidden)
            }

            .safeAreaInset(edge: .bottom) {
                HStack {
                    VStack(spacing: 4) {
                        NavigationLink {
                            LaundryBasketView(clothesStore: clothesStore)
                        } label: {
                            ZStack{
                                Image("secondaryButton")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth:64)
                                Image(systemName: "washer")
                                    .font(.title)
                                    .foregroundStyle(.sienna)
                            }
                        }

                        Text("Laundry bag")
                            .font(.caption)
                            .foregroundStyle(.deepBrown)
                    }

                    Spacer()

                    VStack(spacing: 4) {
                        Menu {
                            NavigationLink{
                                AddClothesView(clothesStore: clothesStore)
                            } label : {
                                Text("Add new")
                            }
                            NavigationLink{
                                AddFromClosetView(clothesStore: clothesStore)
                            } label : {
                                Text("Add from closet")
                            }
                            .disabled(clothesStore.closet.isEmpty)
                        } label: {
                            ZStack{
                                Image("secondaryButton")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth:64)
                                Image(systemName: "plus")
                                    .font(.title)
                                    .foregroundStyle(.sienna)
                            }
                        }

                        Text("Add to pile")
                            .font(.caption)
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }
            .navigationDestination(for: ClothesRoute.self) { route in
                switch route {
                case .pileList:
                    PileListView(
                        clothesStore: clothesStore,
                        toast: $toast,
                        path: $path
                    )
                case .evaluate(let index):
                    EvaluationView(
                        clothesStore: clothesStore,
                        initialIndex: index,
                        toast: $toast,
                        path: $path
                    )
                }
            }
        }
        .toast($toast)
    }
}

#Preview {
    let store = ClothesStore()

    HomeView(clothesStore: store)
}
