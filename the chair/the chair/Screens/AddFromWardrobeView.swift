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
    @State private var isSelecting = false
    
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
                if (isSelecting) {
                    ToolbarItem(placement: .bottomBar) {
                            Button {
                                isSelecting.toggle()
                            } label: {
                                Text("Add to pile")
                            }.buttonStyle(.borderedProminent)
                        }
                    ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                isSelecting.toggle()
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }
                } else {
                    ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                isSelecting.toggle()
                            } label: {
                                Text("Select")
                            }
                        }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isListView.toggle()
                        } label: {
                            Image(systemName: "list.dash")
                        }
                    }
                }
            }
    }
    
    private var closetDisplay: some View {
        ScrollView(.horizontal){
            LazyHGrid(rows: columns, alignment: .top, spacing: 22) {
                ForEach(clothesStore.closetClothes) {
                    garment in
                    closetDisplayItems(garmentNickname: garment.nickname ?? "NAME DOES NOT EXIST")
                }
            }
        }
    }
    
    private var closetList : some View {
        List(clothesStore.closetClothes, selection: $selectedGarments){
            garment in
            HStack{
                Image(systemName: "tshirt")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .frame(width: 56, height: 56)
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Text(garment.nickname ?? "NAME DOES NOT EXIST")
            }
        }
        .environment(\.editMode, .constant(isSelecting ? .active : .inactive))
    }
    
    struct closetDisplayItems: View {
        let garmentNickname : String
        var body : some View {
            VStack{
                ZStack (alignment: .topTrailing){
                    Rectangle()
                        .frame(width: 170, height: 240)
                        .foregroundColor(Color(.systemGray5))
                    Rectangle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.accentColor)
                }
                Text(garmentNickname)
            }
        }
    }
}

#Preview {
    let store = ClothesStore()
    store.seedMockCloset()
    return NavigationStack {
        AddFromClosetView(clothesStore: store)
    }
}
