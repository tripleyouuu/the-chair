//
//  AddClothesView.swift
//  the chair
//
//  Created by Aulia Nadhirah Yasmin Badrulkamal on 13/08/26.
//

import SwiftUI

struct AddClothesView: View {
    @State private var clothesNickname: String = ""
    @State private var clothesMaterial: ClothingMaterial = .dryFit
    @State private var clothesCategory: ClothingCategory = .top
    @State private var clothesSilhouettes: ClothingSilhouette = .tShirt
    // TODO: set proper default values
    
    
    
    let columns = [
            GridItem(.adaptive(minimum: 100))
    ]
    
    var silhouettesOptions : [ClothingSilhouette] {
        ClothingSilhouette.allCases.filter{ $0.category == clothesCategory }
    }
    
    var body: some View {
        NavigationStack{
            VStack(spacing:20){
                    clothesPreview
                    TextField("Nickname", text: $clothesNickname)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(.infinity)
                    materialSection
                    categorySection
                    silhouetteSection
            }
            .padding(20)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "checkmark")
                    }.buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    private var clothesPreview : some View {
        ZStack{
            // TODO: add button to set colors
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
                .frame(width: 230, height: 230)
                .overlay {
                    Image(systemName: "tshirt")
                        .font(.system(size: 70))
                        .foregroundStyle(.secondary)
                }
        }
    }
    
    private var materialSection: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("MATERIAL")
                .font(.headline)
            LazyVGrid(columns:columns, alignment: .leading){
                ForEach(ClothingMaterial.allCases) {
                    material in
                    Button(action: {
                        self.clothesMaterial = material
                    }){
                        Text(material.rawValue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                clothesMaterial == material
                                    ? Color.accentColor
                                : Color(.systemGray5)
                            )
                            .foregroundStyle(
                                clothesMaterial == material
                                ? .white
                                : Color.accentColor
                            )
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    }
                }
            }
        }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("CATEGORY")
                .font(.headline)
            LazyVGrid(columns:[GridItem(.adaptive(minimum: 150))], alignment: .leading){
                ForEach(ClothingCategory.allCases) {
                    category in
                    Button(action: {
                        self.clothesCategory = category
                    }){
                        Text(category.rawValue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                clothesCategory == category
                                    ? Color.accentColor
                                : Color(.systemGray5)
                            )
                            .foregroundStyle(
                                clothesCategory == category
                                ? .white
                                : Color.accentColor
                            )
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    }
                }
            }
        }
    }
    
    private var silhouetteSection: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("SILHOUETTE")
                .font(.headline)
            LazyVGrid(columns:[GridItem(.adaptive(minimum: 100))], alignment: .center){
                ForEach(silhouettesOptions){
                    silhouettes in
                    Button(action: {
                        self.clothesSilhouettes = silhouettes
                        //change it later
                    }){
                        ZStack{
                            Rectangle()
                                .frame(width: .infinity, height:120)
                                .foregroundStyle(clothesSilhouettes == silhouettes ? Color.accentColor : Color(.systemGray5))
                                .cornerRadius(16)
//                                    Image(systemName: "tshirt.fill")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 80)
                            Text(silhouettes.rawValue)
                            .foregroundStyle(
                                clothesSilhouettes == silhouettes
                                ? .white
                                : Color.accentColor
                            )
                        }

                    }
                }
            }.frame(width: .infinity)
        }
    }
}

#Preview {
    let store = ClothesStore()
    store.seedMockData()
    return AddClothesView()
}
