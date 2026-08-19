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
    @State private var clothesColor: ClothingColor = .red
    @Environment(\.dismiss) private var dismiss
    // TODO: set proper default values
    
    @State private var toast: Toast?
    
    
    let columns = [
            GridItem(.adaptive(minimum: 100))
    ]
    
    var silhouettesOptions : [ClothingSilhouette] {
        ClothingSilhouette.allCases.filter{ $0.category == clothesCategory }
    }
    
    var body: some View {
            ScrollView {
                VStack(spacing:20){
                    clothesPreviewNickname
                    colorSection
                    categorySection
                    materialSection
                    
                }
                .padding(.top, 100)
                .padding(20)
            }
            // TO USE TOAST, ADD THIS
            .toast($toast)
            .background(Color(.systemGray6))
            .ignoresSafeArea(edges: .all)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)){
                            // AND THIS TO CALL THE TOAST
                            toast = Toast(message: clothesNickname + " saved successfully")
                        }
                    } label: {
                        Image(systemName: "checkmark")
                    }.buttonStyle(.borderedProminent)
                }
            }
        }
    
    private var clothesPreviewNickname : some View {
        VStack(spacing:16){
            ZStack{
                // TODO: add button to set colors
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .frame(width: 200, height: 200)
                    .overlay {
                        Image(systemName: "tshirt")
                            .font(.system(size: 70))
                            .foregroundStyle(.secondary)
                    }
            }
            TextField("Nickname", text: $clothesNickname)
                .textFieldStyle(.plain)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(.infinity)
        }
        .padding(16)
        .background(.white)
        .cornerRadius(16)
    }
    
    struct ColorPicker: View {
        var color : ClothingColor
        @Binding var selectedColor: ClothingColor
        var body : some View {
            Button {
                selectedColor = color
            } label: {
                ZStack{
                    Circle()
                        .fill(Color(color.swiftUIColor))
                        .frame(width: 32)
                    Circle()
                        .stroke(Color(.systemGray4), lineWidth: color == .white ? 2 : 0)
                        .frame(width: 32)
                    Circle()
                        .stroke(Color(.systemGray2), lineWidth: color == selectedColor ? 4 : 0)
                        .frame(width: 40)
                }
            }
        }
    }
    
    private var colorSection : some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading){
                Text("Color")
                    .font(.headline)
                Text(clothesColor.rawValue)
            }
            LazyVGrid(columns:[GridItem(.adaptive(minimum: 34))], alignment: .center){
                ForEach(ClothingColor.allCases) {
                    color in
                    ColorPicker(color: color, selectedColor: $clothesColor)
                }
            }
            .padding()
            .background()
            .cornerRadius(16)
        }
    }
    
    private var materialSection: some View {
        VStack(alignment: .leading, spacing: 8){
            VStack{
                Text("Material")
                    .font(.headline)
            }
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
                                : Color(.systemGray)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    }
                }
            }
            .padding()
            .background()
            .cornerRadius(16)
        }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("Silhouette")
                .font(.headline)
            VStack(spacing:20){
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
                                    : Color(.systemGray)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        }
                    }
                }
                silhouetteSection
            }
            .padding()
            .background()
            .cornerRadius(16)
        }
    }
    
    private var silhouetteSection: some View {
        VStack(alignment: .leading, spacing: 8){
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
                            Text(silhouettes.rawValue)
                            .foregroundStyle(
                                clothesSilhouettes == silhouettes
                                ? .white
                                : Color(.systemGray)
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
    NavigationStack {
        AddClothesView()
    }
}
