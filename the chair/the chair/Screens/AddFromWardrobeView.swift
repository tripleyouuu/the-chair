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
            HStack(){
                searchBar
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
            .padding(.horizontal, 20)        }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("SELECT CLOTHES")
                        .font(Font.custom("SueEllenFrancisco", size: 32))
                        .fontDesign(nil)
                        .padding(.top,8)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        clothesStore.addToPile(Array(selectedGarments))
                        selectedGarments.removeAll()
                        isSelecting = false
                        dismiss()
                    } label: {
                        ZStack{
                            Image("primaryButton")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.secondary)
                                .frame(maxWidth:44)
                            Image(systemName: "checkmark")
                                .foregroundStyle(.offWhite)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
        
    private var searchBar: some View {
        ZStack {
            Image("customTextField")
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color("Sienna"))
                TextField("Search", text: $searchTerm)
                    .tint(.tan)
                    .focused($isSearchFocused)
            }
            .padding()
            .cornerRadius(.infinity)
            .padding(.vertical,8)
            .padding(.horizontal,8)
        }
    }
    
    private var searchedCloset: [ClothingItem] {
        clothesStore.search(searchTerm, within: clothesStore.closet)
    }
    
    private var smallCloset: [ClothingItem] {
        searchedCloset.filtered(by: [.tShirt, .buttonUpShirt, .cardigan, .hoodie, .jacket, .shorts, .skirt, .tankTop])
    }
    
    private var bigCloset: [ClothingItem] {
        searchedCloset.filtered(by: [.dress, .jumpsuit, .pants, .miniDress])
    }
        
    private var closetDisplay: some View {
        Group {
            if searchedCloset.isEmpty {
                Text("No matches found...")
                    .font(.subheadline)
                    .foregroundStyle(.sienna.opacity(0.8))
            } else {
                VStack {
                    ScrollView(.horizontal){
                        VStack (alignment: .leading,spacing:45){
                            HStack() {
                                ForEach(smallCloset) {
                                    garment in
                                    closetDisplayItems(
                                        garment: garment,
                                        selectedGarments: $selectedGarments,
                                        isSelecting: $isSelecting
                                    )
                                }
                            }.padding(.horizontal, 20)
                            HStack() {
                                ForEach(bigCloset) {
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
                    .ignoresSafeArea()
                    .padding(.top,1)
//                    .background(.red)
                    Spacer()
                }
            }
        }
    }
        
    private var closetList: some View {
        Group {
            if searchedCloset.isEmpty {
                Text("No matches found...")
                    .font(.subheadline)
                    .foregroundStyle(.sienna.opacity(0.8))
            } else {
                List(searchedCloset, selection: $selectedGarments) {
                    garment in
                    HStack(spacing: 16) {
                        GarmentIconView(item: garment)
                            .frame(width: 56, height: 56)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        Text(garment.nickname ?? "NAME DOES NOT EXIST")
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
                }
                .environment(\.editMode, .constant(isSelecting ? .active : .inactive))
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
                ZStack(alignment: .top) {
                    Image("hanger")
                    GarmentIconView(item: garment)
                        .frame(width: 180)
                        .scaleEffect(isSelected ? 1.2 : 1)
                        .padding(.top, 35)

                    if let imageName = garment.referenceImageName,
                       let image = ImageStorage.loadImage(named: imageName) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(12)
                    }
                }
                HStack {
                    Text(garment.nickname ?? "Clothes Name")
                        .foregroundStyle(Color("White"))
                        .bold()
                    if (isSelected) {
                        ZStack {
                            Image("secondaryButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                            Image(systemName: "checkmark")
                        }
                    }
                }
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
