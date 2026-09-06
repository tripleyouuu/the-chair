//
//  EditClothesView.swift
//  the chair
//
//  Created by Vitha Watson on 06/09/26.
//


//
//  EditClothesView.swift
//  the chair
//
//  Created by Aulia Nadhirah Yasmin Badrulkamal on 13/08/26.
//

import SwiftUI
struct EditClothesView: View {
    @ObservedObject var clothesStore: ClothesStore
    let garment: ClothingItem
    @State private var clothingNickname: String
    @State private var clothingMaterial: ClothingMaterial
    @State private var clothingCategory: ClothingCategory
    @State private var clothingSilhouette: ClothingSilhouette
    @State private var clothingColor: ClothingColor
    @State private var showingCamera : Bool = false // control the camera
    @State private var clothingImage : UIImage?
    @Environment(\.dismiss) private var dismiss
    @State private var hasNewImage = false
    // TODO: set proper default values
    init(
        clothesStore: ClothesStore,
        garment: ClothingItem
    ) {
        self.clothesStore = clothesStore
        self.garment = garment
        _clothingNickname = State(initialValue: garment.nickname ?? "")
        _clothingMaterial = State(initialValue: garment.clothingMaterial)
        _clothingCategory = State(initialValue: garment.clothingCategory)
        _clothingSilhouette = State(initialValue: garment.silhouette)
        _clothingColor = State(initialValue: garment.clothingColor)
        _clothingImage = State(
            initialValue: garment.referenceImageName.flatMap {
                ImageStorage.loadImage(named: $0)
            }
        )
    }
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    var silhouettesOptions : [ClothingSilhouette] {
        ClothingSilhouette.allCases.filter{ $0.category == clothingCategory }
    }
    var body: some View {
        ScrollView {
            VStack(spacing:20){
                clothesPreviewNickname
                colorSection
                categorySection
                materialSection
            }
            .padding(20)
        }
        .background(
            ZStack {
                Color("backgroundBase")
                Image("Texture")
            }
            .ignoresSafeArea()
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    var updatedClothing = garment
                    updatedClothing.nickname = clothingNickname == "" ? clothingColor.rawValue + " " + clothingSilhouette.name : clothingNickname
                    updatedClothing.clothingMaterial = clothingMaterial
                    updatedClothing.clothingColor = clothingColor
                    updatedClothing.silhouette = clothingSilhouette
                    updatedClothing.location = .wardrobe
                    updatedClothing.savedEvaluation = nil
                    if hasNewImage {
                        updatedClothing.referenceImageName = clothingImage.flatMap{
                            ImageStorage.saveImage($0)
                        }
                    }
                    clothesStore.updateClosetItem(updatedClothing)
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
            ToolbarItem(placement: .title){
                Text("EDIT")
                    .font(Font.custom("SueEllenFrancisco", size: 32))
                    .fontDesign(nil)
                    .padding(.top,8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .backButton(.custom)
    }
    private var clothesPreviewNickname : some View {
        VStack(spacing:8){
            VStack(spacing:16){
                ZStack(alignment: .bottomTrailing){
                    GarmentPreviewView(clothingColor: $clothingColor, clothingSilhouette: $clothingSilhouette)
                        .frame(width: 200, height: 200)
                    Button(action: {
                        showingCamera = true
                    }) {
                        ZStack {
                            if let clothingImage {
                                Image(uiImage: clothingImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(12)
                            } else {
                                Image(systemName: "camera")
                                    .font(.system(size: 32))
                                    .frame(width: 80, height: 80)
                                    .foregroundStyle(Color(.systemGray3))
                                    .background(Color(.systemGray5))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $showingCamera){
                        CameraView(image: $clothingImage)
                            .ignoresSafeArea()
                            .onDisappear {
                                if clothingImage != nil {
                                    hasNewImage = true
                                }
                            }
                    }
                }
                TextField("Nickname (optional)", text: $clothingNickname)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(.infinity)
                    .bold()
                    .font(.title2)
            }
            .padding(16)
            .background(.white)
            .cornerRadius(16)
            Text("Give it a name. Optional, add a photo of something distinctive. A pattern, graphic, or tag works great.")
                .font(.system(size:15))
                .foregroundStyle(Color("Sienna"))
                .opacity(0.8)
        }
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
                        .fill(Color(color.rawValue))
                        .frame(width: 32)
                    Circle()
                        .stroke(Color(.systemGray4), lineWidth: color == .white ? 1 : 0)
                        .frame(width: 32)
                    Circle()
                        .stroke(color == .white ? Color(.systemGray4) : .white, lineWidth: color == selectedColor ? 3 : 0)
                        .frame(width:22)
                }
            }
        }
    }
    private var colorSection : some View {
        VStack(alignment: .leading){
            HStack(){
                Text("Color")
                    .font(.headline)
                    .foregroundStyle(Color("Sienna"))
                Text(clothingColor.rawValue)
                    .foregroundStyle(Color("Tan"))
            }
            LazyVGrid(columns:[GridItem(.adaptive(minimum: 34))], alignment: .center){
                ForEach(ClothingColor.allCases) {
                    color in
                    ColorPicker(color: color, selectedColor: $clothingColor)
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
                    .foregroundStyle(Color("Sienna"))
            }
            LazyVGrid(columns:columns, alignment: .leading){
                ForEach(ClothingMaterial.allCases) {
                    material in
                    Button(action: {
                        self.clothingMaterial = material
                    }){
                        VStack{
                            ZStack{
                                Rectangle()
                                    .frame(height:100)
                                    .foregroundStyle(Color("Cream"))
                                    .cornerRadius(16)
                                Image(material.rawValue)
                                if (clothingMaterial == material) {
                                    Image("squareButtonOutline")
                                }
                            }
                            Text(material.rawValue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(
                                    clothingMaterial == material
                                    ? Color("Tan")
                                    : Color("Cream")
                                )
                                .foregroundStyle(
                                    clothingMaterial == material
                                    ? Color("White")
                                    : Color("Sienna")
                                )
                                .font(.system(size:14, weight: .medium))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        }
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
                .foregroundStyle(Color("Sienna"))
            VStack(spacing:8){
                HStack(){
                    ForEach(ClothingCategory.allCases) {
                        category in
                        Button(action: {
                            self.clothingCategory = category
                            if !silhouettesOptions.contains(clothingSilhouette),
                               let firstSilhouette = silhouettesOptions.first {
                                self.clothingSilhouette = firstSilhouette
                            }
                        }){
                            Text(category.rawValue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(
                                    clothingCategory == category
                                    ? Color("Tan")
                                    : Color("Cream")
                                )
                                .foregroundStyle(
                                    clothingCategory == category
                                    ? Color("White")
                                    : Color("Sienna")
                                )
                                .font(.system(size:14, weight: .medium))
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
            HStack(){
                ForEach(silhouettesOptions){
                    silhouette in
                    Button(action: {
                        self.clothingSilhouette = silhouette
                        //change it later
                    }){
                        ZStack{
                            Rectangle()
                                .frame(height:100)
                                .foregroundStyle(Color("Cream"))
                                .cornerRadius(16)
                            GarmentStaticView(clothingColor: .white, clothingSilhouette: silhouette)
                                .frame(width: 80, height: 80)
                            if (clothingSilhouette == silhouette) {
                                Image("squareButtonOutline")
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let store = ClothesStore()
    NavigationStack {
        if let garment = store.closet.first {
            EditClothesView(clothesStore: store, garment: garment)
        }
    }
}