//
//  GarmentPreviewView.swift
//  the chair
//
//  Created by Vitha Watson on 19/08/26.
//

import SwiftUI

struct GarmentStaticView: View {
    var clothingColor: ClothingColor
    var clothingSilhouette: ClothingSilhouette
    
    var body: some View {
        ZStack {
            Image("\(clothingSilhouette.rawValue)")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color(clothingColor.rawValue))

            Image("\(clothingSilhouette.rawValue)Outline")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color("Black"))
        }
    }
}

#Preview {
    var color : ClothingColor = .darkBlue
    var  silhouette : ClothingSilhouette = .tShirt
    GarmentStaticView(clothingColor : color, clothingSilhouette: silhouette)
        .frame(width: 120, height: 120)
}
