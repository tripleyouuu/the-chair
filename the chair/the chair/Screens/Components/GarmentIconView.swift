//
//  GarmentIconView.swift
//  the chair
//
//  Created by Vitha Watson on 19/08/26.
//

import SwiftUI

struct GarmentIconView: View {
    let item: ClothingItem

    var body: some View {
        Image("testCircle")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundStyle(item.clothingColor.swiftUIColor)
    }
}

#Preview {
    let item = ClothingItem(
        nickname: "Example Tee",
        clothingMaterial: .natural,
        clothingColor: .darkBlue,
        silhouette: .tShirt
    )

    GarmentIconView(item: item)
        .frame(width: 120, height: 120)
}
