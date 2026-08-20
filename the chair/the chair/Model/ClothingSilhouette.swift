//
//  ClothingSilhouette.swift
//  
//
//  Created by Aurora Purnawan on 12/08/26.
//

import Foundation

enum ClothingSilhouette: String, CaseIterable, Codable, Identifiable {
    case tShirt = "tShirt"
    case buttonUpShirt = "buttonUpShirt"
    case tankTop = "tankTop"

    case pants = "pants"
    case shorts = "shorts"
    case skirt = "skirt"

    case dress = "dress"
    case miniDress = "miniDress"
    case jumpsuit = "jumpsuit"

    case jacket = "jacket"
    case cardigan = "cardigan"
    case hoodie = "hoodie"

    var id: String { rawValue }
    var name : String {
        switch self {
            case .tShirt: return "T-shirt"
            case .buttonUpShirt: return "Button-Up Shirt"
            case .tankTop: return "Tank Top"

            case .pants: return "Pants"
            case .shorts: return "Shorts"
            case .skirt: return "Skirt"

            case .dress: return "Dress"
            case .miniDress: return "Mini Dress"
            case .jumpsuit: return "Jumpsuit"

            case .jacket: return "Jacket"
            case .cardigan: return "Cardigan"
            case .hoodie: return "Hoodie"
        }
    }
    
    var category: ClothingCategory {
        switch self {
        case .tShirt, .buttonUpShirt, .tankTop: return .top
        case .pants, .shorts, .skirt: return .bottom
        case .dress, .miniDress, .jumpsuit: return .singlePiece
        case .jacket, .cardigan, .hoodie: return .outerWear
        }
    }
}
