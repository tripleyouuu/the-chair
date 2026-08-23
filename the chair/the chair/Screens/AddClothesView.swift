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
    @State private var clothingColor: ClothingColor = .red
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
                        let newClothingNickname : String = clothingNickname == "" ? clothingColor.rawValue + " " + clothingSilhouette.name : clothingNickname
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
                    Text("ADD NEW")
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
                    if let clothingImage {
                        Image(uiImage: clothingImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(12)
                    } else {
                        // @ mask
                        // It's doneeee
                        Button(action: {
                            showingCamera = true
                        }) {
                            Image(systemName: "camera")
                                .font(.system(size: 32))
                                .frame(width: 80, height: 80)
                                .foregroundStyle(Color(.systemGray3))
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
//                            Image("\(silhouette.rawValue)Silhouette")
//                            .foregroundStyle(
//                                clothingSilhouette == silhouette
//                                ? .white
//                                : Color(.systemGray)
//                            )
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
