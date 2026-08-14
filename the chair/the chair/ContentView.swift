//
//  ContentView.swift
//  the chair
//
//  Created by Aulia Nadhirah Yasmin Badrulkamal on 11/08/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var clothesStore = ClothesStore()

    var body: some View {
        HomeView(clothesStore: clothesStore)
    }
}

#Preview {
    ContentView()
}
