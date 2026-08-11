//
//  Item.swift
//  the chair
//
//  Created by Aulia Nadhirah Yasmin Badrulkamal on 11/08/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
