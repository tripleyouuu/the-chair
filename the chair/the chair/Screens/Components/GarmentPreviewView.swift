//
//  GarmentIconView.swift
//  the chair
//
//  Created by Vitha Watson on 19/08/26.
//

import SwiftUI

struct GarmentPreviewView: View {
    @Binding var clothingColor: ClothingColor
    @Binding var clothingSilhouette: ClothingSilhouette
    
    var body: some View {
        Image("\(clothingSilhouette.rawValue)Silhouette")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundStyle(clothingColor.swiftUIColor)
    }
}

#Preview {
    @State var color : ClothingColor = .darkBlue
    @State var  silhouette : ClothingSilhouette = .tShirt
    GarmentPreviewView(clothingColor : $color, clothingSilhouette: $silhouette)
        .frame(width: 120, height: 120)
}
