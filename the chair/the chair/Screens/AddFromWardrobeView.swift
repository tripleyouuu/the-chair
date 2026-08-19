//
//  AddFromWardrobeView.swift
//  the chair
//
//  Created by Aulia Nadhirah Yasmin Badrulkamal on 14/08/26.
//

import SwiftUI

struct AddFromClosetView: View {
    @ObservedObject var clothesStore: ClothesStore
    @State var searchTeam : String = ""
    @State var isListView : Bool = false
    @State private var selectedGarments: Set<UUID> = []
    @State private var isSelecting = true
    
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
                    ZStack{
                        closetDisplay
                        if (!isSelecting){
                            VStack{
                                Spacer()
                                HStack{
                                    Image(systemName: "magnifyingglass")
                                        .foregroundStyle(.gray)
                                    TextField("Search", text: $searchTeam)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(.infinity)
                                .padding(.horizontal,20)
                                .padding(.vertical,8)
                            }
                        }
                    }
                    .padding(20)
                    .ignoresSafeArea(.container, edges: .bottom)
                }
            }
            .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            clothesStore.addToPile(Array(selectedGarments))
                            selectedGarments.removeAll()
                            isSelecting = false
                        } label: {
                            Text("Add to pile")
                        }.buttonStyle(.borderedProminent)
                    }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isListView.toggle()
                    } label: {
                        Image(systemName: isListView ? "square.grid.2x2" : "list.dash")
                    }
                }
            }
    }
    
    private var searchedCloset: [ClothingItem] {
        clothesStore.search(searchTeam, within: clothesStore.closet)
    }

    private var closetDisplay: some View {
        ScrollView(.horizontal){
            LazyHGrid(rows: columns, alignment: .top, spacing: 22) {
                ForEach(searchedCloset) {
                    garment in
                    closetDisplayItems(
                        garment: garment,
                        selectedGarments: $selectedGarments,
                        isSelecting: $isSelecting
                    )
                }
            }
        }
    }

    private var closetList : some View {
        List(searchedCloset, selection: $selectedGarments){
            garment in
            HStack{
                GarmentIconView(item: garment)
                    .frame(width: 56, height: 56)
                    .background(.gray.opacity(0.1))
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
                ZStack (){
                    RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
                        .frame(width: 170, height: 240)
                        .foregroundColor(Color(.systemGray5))
                        .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
                                .strokeBorder(Color.accentColor, lineWidth: 2)
                                .opacity(isSelected ? 1 : 0)
                        )

                    GarmentIconView(item: garment)
                        .frame(width: 120, height: 120)
                    if let referenceImageName = garment.referenceImageName {
                        Image(referenceImageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 150, height: 220, alignment: .topTrailing)
                    }

                    if (isSelecting) {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.accentColor)
                            .frame(width: 150, height: 220, alignment: .bottomTrailing)
                    }
                }

                Text(garment.nickname ?? "NAME DOES NOT EXIST")
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
