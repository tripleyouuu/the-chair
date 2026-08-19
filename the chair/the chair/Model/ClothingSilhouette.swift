//
//  ClothingSilhouette.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation

enum ClothingSilhouette: String, CaseIterable, Codable, Identifiable {
    case tShirt = "T-Shirt"
    case buttonUpShirt = "Button-Up Shirt"
    case tankTop = "Tank Top"

    case pants = "Pants"
    case shorts = "Shorts"
    case skirt = "Skirt"

    case dress = "Dress"
    case miniDress = "Mini Dress"
    case jumpsuit = "Jumpsuit"

    case jacket = "Jacket"
    case cardigan = "Cardigan"
    case hoodie = "Hoodie"

    var id: String { rawValue }

    var category: ClothingCategory {
        switch self {
        case .tShirt, .buttonUpShirt, .tankTop: return .top
        case .pants, .shorts, .skirt: return .bottom
        case .dress, .miniDress, .jumpsuit: return .singlePiece
        case .jacket, .cardigan, .hoodie: return .outerWear
        }
    }
}
