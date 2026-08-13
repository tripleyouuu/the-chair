import SwiftUI

struct PileListView: View {
    @ObservedObject var clothesStore: ClothesStore

    var body: some View {
        List {
            ForEach(Array(clothesStore.clothes.enumerated()), id: \.element.id) { index, item in
                NavigationLink {
                    EvaluationView(
                        clothesStore: clothesStore,
                        initialIndex: index
                    )
                } label: {
                    HStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 56, height: 56)
                            .overlay {
                                Image(systemName: "tshirt")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                            }

                        Text(item.nickname ?? "Nickname")
                            .font(.body)

                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Pile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
