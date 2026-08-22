//
//  AddClothesView.swift
//  the chair
//
//  Created by Aulia Nadhirah Yasmin Badrulkamal on 13/08/26.
//

import SwiftUI

struct AddClothesView: View {
    @ObservedObject var clothesStore: ClothesStore
    @State private var clothingNickname: String = ""
    @State private var clothingMaterial: ClothingMaterial = .dryFit
    @State private var clothingCategory: ClothingCategory = .top
    @State private var clothingSilhouette: ClothingSilhouette = .tShirt
    @State private var clothingColor: ClothingColor = .black
    @State private var showingCamera : Bool = false // control the camera
    @State private var clothingImage : UIImage?
    
    @Environment(\.dismiss) private var dismiss
    // TODO: set proper default values
    
    init(
        clothesStore: ClothesStore,
    ) {
        self.clothesStore = clothesStore
    }

    
    @State private var toast: Toast?
    
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
            
            // TO USE TOAST, ADD THIS
            .toast($toast)
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
                        let newClothingNickname : String = clothingNickname == "" ? clothingColor.rawValue + " " + clothingSilhouette.rawValue : clothingNickname
                        let newClothingImage : String? = clothingImage.flatMap{
                            ImageStorage.saveImage($0)
                        }

                        print(newClothingImage ?? "NO IMAGE DATA")
                        
                        let newClothing : ClothingItem =
                        ClothingItem(
                            nickname: newClothingNickname,
                            clothingMaterial: clothingMaterial,
                            clothingColor: clothingColor,
                            silhouette: clothingSilhouette,
                            location: .pile,
                            referenceImageName: newClothingImage
                        )
                        clothesStore.addItem(newClothing)
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)){
                            // AND THIS TO CALL THE TOAST
                            toast = Toast(message: newClothingNickname + " saved successfully")
                        }
                        resetForm()
                    } label: {
                        Image(systemName: "checkmark")
                    }.buttonStyle(.borderedProminent)
                }
                ToolbarItem(placement: .title){
                    Text("ADD NEW")
                        .font(Font.custom("SueEllenFrancisco", size: 32))
                        .padding(.top,8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .customBackButton()
        }
    
    private var clothesPreviewNickname : some View {
        VStack(spacing:16){
            ZStack(alignment: .bottomTrailing){
                GarmentPreviewView(clothingColor: $clothingColor, clothingSilhouette: $clothingSilhouette)
                    .frame(width: 200, height: 200)
                if let clothingImage {
                    Image(uiImage: clothingImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                } else {
                    Button(action: {
                        showingCamera = true
                    }) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 24))
                            .frame(width: 80, height: 80)
                    }.fullScreenCover(isPresented: $showingCamera){
                        CameraView(image: $clothingImage)
                            .ignoresSafeArea()
                    }
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                }
            }
            TextField("Nickname (optional)", text: $clothingNickname)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
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
                        .fill(Color(color.rawValue))
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
            HStack(){
                Text("Color")
                    .font(.headline)
                Text(clothingColor.rawValue)
                    .foregroundStyle(Color(.systemGray))
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
            }
            LazyVGrid(columns:columns, alignment: .leading){
                ForEach(ClothingMaterial.allCases) {
                    material in
                    Button(action: {
                        self.clothingMaterial = material
                    }){
                        Text(material.rawValue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                clothingMaterial == material
                                    ? Color.accentColor
                                : Color(.systemGray5)
                            )
                            .foregroundStyle(
                                clothingMaterial == material
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
                            self.clothingCategory = category
                        }){
                            Text(category.rawValue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(
                                    clothingCategory == category
                                    ? Color.accentColor
                                    : Color(.systemGray5)
                                )
                                .foregroundStyle(
                                    clothingCategory == category
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
                    silhouette in
                    Button(action: {
                        self.clothingSilhouette = silhouette
                        //change it later
                    }){
                        ZStack{
                            Rectangle()
                                .frame(width: .infinity, height:120)
                                .foregroundStyle(clothingSilhouette == silhouette ? Color.accentColor : Color(.systemGray5))
                                .cornerRadius(16)
                            Text(silhouette.name)
                            .foregroundStyle(
                                clothingSilhouette == silhouette
                                ? .white
                                : Color(.systemGray)
                            )
                        }

                    }
                }
            }
        }
    }
    
    func resetForm() {
        clothingNickname = ""
        clothingMaterial = .dryFit
        clothingCategory = .top
        clothingSilhouette = .tShirt
        clothingColor = .white
        clothingImage = nil
    }
}

#Preview {
    let store = ClothesStore()
    NavigationStack {
        AddClothesView(clothesStore: store)
    }
}
