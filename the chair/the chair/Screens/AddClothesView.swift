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
                    clothesPreview
                    TextField("Nickname", text: $clothesNickname)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(.infinity)
                    colorSection
                    materialSection
                    categorySection
                    silhouetteSection
                    
                }
                .padding(.top, 100)
                .padding(20)
            }
            // TO USE TOAST, ADD THIS
            .toast($toast)
            .ignoresSafeArea(edges: .all)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }

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
    
    struct ColorPicker: View {
        var color : ClothingColor = .red
        @Binding var selectedColor: ClothingColor
        var body : some View {
            Button {
                selectedColor = color
            } label: {
                ZStack{
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 32)
                    Circle().stroke(.white, lineWidth: color == .white ? 2 : 0)
                    Circle().stroke(Color(.systemGray2), lineWidth: color == selectedColor ? 4 : 0)
                        .frame(width: 40)
                }
            }
        }
    }
    
    private var colorSection : some View {
        VStack(alignment: .leading){
            Text("COLOR")
                .font(.headline)
            LazyVGrid(columns:[GridItem(.adaptive(minimum: 38))], alignment: .center){
                ForEach(ClothingColor.allCases) {
                    color in
                    ColorPicker(color: color, selectedColor: $clothesColor)
                }
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
    NavigationStack {
        AddClothesView()
    }
}
