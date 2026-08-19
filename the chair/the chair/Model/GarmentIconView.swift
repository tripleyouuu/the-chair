//
//  GarmentIconView.swift
//
//
//  Created by Vitha Watson on 19/08/26.
//

import SwiftUI

struct GarmentIconView: View {
    let item: ClothingItem

    var body: some View {
        Image(item.silhouetteAssetName)
            .renderingMode(.template)
            .foregroundStyle(item.clothingColor.swiftUIColor)
    }
}