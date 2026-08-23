//
//  HangerView.swift
//  the chair
//
//  Created by Aulia Nadhirah Yasmin Badrulkamal on 23/08/26.
//

import SwiftUI

struct HangerView: View {
    let item: ClothingItem

    var body: some View {
        ZStack {
            Image("\(item.silhouette.rawValue)Hanger")
                .renderingMode(.template)
//                .resizable()
//                .scaledToFit()
                .foregroundStyle(Color(item.clothingColor.rawValue))

            Image("\(item.silhouette.rawValue)HangerOutline")
//                .resizable()
//                .scaledToFit()
                .foregroundStyle(Color("Black"))
        }
    }
}

#Preview {
    let item = ClothingItem(
        nickname: "Example Tee",
        clothingMaterial: .natural,
        clothingColor: .darkBlue,
        silhouette: .tShirt
    )

    HangerView(item: item)
        .frame(width: 120, height: 120)
}
