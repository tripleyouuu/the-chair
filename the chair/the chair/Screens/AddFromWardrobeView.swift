//
//  AddFromWardrobeView.swift
//  the chair
//
//  Created by Aulia Nadhirah Yasmin Badrulkamal on 14/08/26.
//

import SwiftUI

struct AddFromClosetView: View {
    @ObservedObject var clothesStore: ClothesStore
    @State var searchTerm : String = ""
    @State var isListView : Bool = false
    @State private var selectedGarments: Set<UUID> = []
    @State private var isSelecting = true
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isSearchFocused: Bool
    
    let columns = [GridItem(.fixed(300)),
                   GridItem(.fixed(300))]
    
    init(
        clothesStore: ClothesStore
    ) {
        self.clothesStore = clothesStore
    }
    
    var body: some View {
        Group{
            if (isListView) {
                closetList
            } else {
                closetDisplay
            }
        }
        .background(
            ZStack {
                Image("wardrobeBackground")
            }
                .ignoresSafeArea()
        )
        .backButton(isListView ? .hidden : .custom)
        .safeAreaInset(edge: .bottom) {
            HStack {
                searchBar
                Button {
                    clothesStore.addToPile(Array(selectedGarments))
                    selectedGarments.removeAll()
                    isSelecting = false
                    dismiss()
                } label: {
                    Text("Add").padding(10)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 20)        }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("CLOSET")
                        .font(Font.custom("SueEllenFrancisco", size: 32))
                        .padding(.top,8)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isListView.toggle()
                    } label: {
                        ZStack{
                            Image("secondaryButton")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.secondary)
                                .frame(maxWidth:44)
                            Image(systemName: isListView ? "square.grid.2x2" : "list.dash")
                                .foregroundStyle(.sienna)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
        
        private var searchBar: some View {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search", text: $searchTerm)
                    .focused($isSearchFocused)
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(.infinity)
            .padding(.vertical,8)
        }
        
        private var searchedCloset: [ClothingItem] {
            clothesStore.search(searchTerm, within: clothesStore.closet)
        }
        
        private var closetDisplay: some View {
            ScrollView(.horizontal){
                HStack() {
                    ForEach(searchedCloset) {
                        garment in
                        closetDisplayItems(
                            garment: garment,
                            selectedGarments: $selectedGarments,
                            isSelecting: $isSelecting
                        )
                    }
                }.padding(.horizontal, 20)
                HStack() {
                    ForEach(searchedCloset) {
                        garment in
                        closetDisplayItems(
                            garment: garment,
                            selectedGarments: $selectedGarments,
                            isSelecting: $isSelecting
                        )
                    }
                }.padding(.horizontal, 20)
            }
        }
        
        private var closetList : some View {
            List(searchedCloset, selection: $selectedGarments){
                garment in
                HStack{
                    GarmentIconView(item: garment)
                        .frame(width: 56, height: 56)
//                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    Text(garment.nickname ?? "NAME DOES NOT EXIST")
                }
            }
            .environment(\.editMode, .constant(isSelecting ? .active : .inactive))
        }
        
        struct closetDisplayItems: View {
            let garment: ClothingItem
            @Binding var selectedGarments: Set<UUID>
            @Binding var isSelecting: Bool
            private var isSelected: Bool {
                selectedGarments.contains(garment.id)
            }
            var body : some View {
                VStack{
                    ZStack(alignment: .top){
                        Image("hanger")
                        GarmentIconView(item: garment)
                            .frame(width: 170)
                            .scaleEffect(isSelected ? 1.2 : 1)
                        if let imageName = garment.referenceImageName, let image = ImageStorage.loadImage(named: imageName) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(12)
                        }
                    }
                    Text(garment.nickname ?? "NAME DOES NOT EXIST")
                        .padding(8)
                        .padding(.horizontal, 12)
                        .background(isSelected ? Color("Yellow") : .clear)
                        .cornerRadius(99)
                }.onTapGesture {
                    if (isSelected) {
                        selectedGarments.remove(garment.id)
                    } else {
                        selectedGarments.insert(garment.id)
                    }
                    
                }
            }
        }
}

#Preview {
    let store = ClothesStore()
    NavigationStack {
        AddFromClosetView(clothesStore: store)
    }
}
