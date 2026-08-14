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
    
    let columns = [GridItem(.fixed(300)),
                   GridItem(.fixed(300))]
    
    init(
        clothesStore: ClothesStore
    ) {
        self.clothesStore = clothesStore
    }
    
    var body: some View {
            VStack{
                closetDisplay
                Spacer()
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    TextField("Search", text: $searchTeam)
                  }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(.infinity)
            }
            .padding(20)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                        Button {
                        } label: {
                            Text("Select")
                        }
                    }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "list.dash")
                    }
                }
            }
    }
    
    private var closetDisplay: some View {
        ScrollView(.horizontal){
            LazyHGrid(rows: columns, spacing: 16) {
                ForEach(clothesStore.closetClothes) {
                    garment in
                    closetItems(garmentNickname: garment.nickname ?? "NAME DOES NOT EXIST")
                }
            }
        }
    }
    
    struct closetItems: View {
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
