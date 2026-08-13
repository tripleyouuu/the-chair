//
//  EvaluationView.swift
//
//
//  Created by Vitha Watson on 12/08/26.
//


import SwiftUI

struct EvaluationView: View {
    @ObservedObject var clothesStore: ClothesStore

    private let initialIndex: Int
    @State private var currentIndex: Int

    init(clothesStore: ClothesStore, initialIndex: Int? = nil) {
        self.clothesStore = clothesStore

        let startingIndex = initialIndex ?? max(clothesStore.clothes.count - 1, 0)

        self.initialIndex = startingIndex
        _currentIndex = State(initialValue: startingIndex)
    }
    @State private var hoursWorn = 8.0
    @State private var environmentIndex = 2
    @State private var activityIndex = 2

    private let environments: [EnvironmentLevel] = [
        .cold,
        .cool,
        .mild,
        .warm,
        .hot
    ]

    private let activities: [ActivityLevel] = [
        .resting,
        .light,
        .moderate,
        .active,
        .intense
    ]

    private var currentItem: ClothingItem? {
        guard !clothesStore.clothes.isEmpty,
              currentIndex < clothesStore.clothes.count else {
            return nil
        }

        return clothesStore.clothes[currentIndex]
    }

    private var currentEnvironment: EnvironmentLevel {
        environments[environmentIndex]
    }

    private var currentActivity: ActivityLevel {
        activities[activityIndex]
    }

    private var currentSession: WearSession {
        WearSession(
            hoursWorn: hoursWorn,
            activityLevel: currentActivity,
            environment: currentEnvironment
        )
    }

    private var remainingWearability: Double {
        guard let currentItem else { return 0 }

        return currentItem.totalWearability
            - currentItem.usedWearability
            - currentSession.usedWearability // we don't have past session persistence logic yet, but this should work once we do
    }

    private var verdictIsWash: Bool {
        remainingWearability <= 0
    }

    private var verdictText: String {
        verdictIsWash ? "WASH" : "KEEP"
    }

    private var secondaryActionText: String {
        verdictIsWash ? "No, I'll keep" : "No, I'll wash"
    }

    var body: some View {
        Group {
            if let currentItem {
                evaluationContent(for: currentItem)
            } else {
                ContentUnavailableView(
                    "No Clothes",
                    systemImage: "questionmark.circle.dashed",
                    description: Text("Your laundry pile is empty.")
                )
            }
        }
        .navigationTitle("Evaluate")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    PileListView(
                        clothesStore: clothesStore
                    )
                } label: {
                    Image(systemName: "list.dash")
                }
            }
        }
    }

    private func evaluationContent(for item: ClothingItem) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                garmentPreview(for: item)

                durationSection

                environmentSection

                activitySection

                verdictSection
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
    }

    private func garmentPreview(for item: ClothingItem) -> some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
                .frame(width: 240, height: 240)
                .overlay {
                    Image(systemName: "tshirt")
                        .font(.system(size: 80))
                        .foregroundStyle(.secondary)
                }

            Text(item.nickname ?? "Nickname") // TODO: add auto nickname logic
                .font(.headline)
        }
    }

    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Duration worn: ")
                    .font(.headline)

                Spacer()

                HStack(spacing: 8) {
                    Button {
                        hoursWorn = max(0, hoursWorn - 1)
                    } label: {
                        Image(systemName: "minus")
                    }


                    TextField(
                        "",
                        value: $hoursWorn,
                        format: .number
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 60)


                    Button {
                        hoursWorn += 1
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                Text("     hours") // lmao
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
        }
    }

    private var environmentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Environment:")
                    .font(.headline)

                Text(environmentName)
                    .foregroundStyle(.secondary)
                
                Button {
                } label: {
                    Image(systemName: "questionmark")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.circle) // env info
                
            }

            HStack(spacing: 16) {
                Image(systemName: "snowflake")
                    .foregroundStyle(.secondary)

                Slider(
                    value: Binding(
                        get: { Double(environmentIndex) },
                        set: { environmentIndex = Int($0.rounded()) }
                    ),
                    in: 0...4,
                    step: 1
                )

                Image(systemName: "sun.max")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Activity level:")
                    .font(.headline)

                Text(activityName)
                    .foregroundStyle(.secondary)
                
                Button {
                } label: {
                    Image(systemName: "questionmark")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.circle) // act info
            }

            HStack(spacing: 16) {
                Image(systemName: "figure.seated.side")
                    .foregroundStyle(.secondary)

                Slider(
                    value: Binding(
                        get: { Double(activityIndex) },
                        set: { activityIndex = Int($0.rounded()) }
                    ),
                    in: 0...4,
                    step: 1
                )

                Image(systemName: "figure.run")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var verdictSection: some View {
        VStack(spacing: 16) {
            Button {
                registerDecision(washing: verdictIsWash)
            } label: {
                Text(verdictText)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
            }
            .buttonStyle(.borderedProminent)

            Button {
                registerDecision(washing: !verdictIsWash)
            } label: {
                Text(secondaryActionText)
                    .font(.subheadline)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 8)
    }

    private var environmentName: String {
        switch currentEnvironment {
        case .cold:
            return "Cold"
        case .cool:
            return "Cool"
        case .mild:
            return "Mild"
        case .warm:
            return "Warm"
        case .hot:
            return "Hot"
        }
    }

    private var activityName: String {
        switch currentActivity {
        case .resting:
            return "Resting"
        case .light:
            return "Light"
        case .moderate:
            return "Moderate"
        case .active:
            return "Active"
        case .intense:
            return "Intense"
        }
    }

    private func registerDecision(washing: Bool) {
        guard let currentItem else { return }

        if washing {
            print("\(currentItem.nickname ?? "Garment") has been added to laundry bag")
        } else {
            print("\(currentItem.nickname ?? "Garment") has been returned to the pile")
        }

        advanceToNextItem()
    }

    private func advanceToNextItem() {
        if currentIndex > 0 {
            currentIndex -= 1
        } else {
            currentIndex = clothesStore.clothes.count - 1
        }

        hoursWorn = 8
        environmentIndex = 2
        activityIndex = 2
    }
}

#Preview {
    let store = ClothesStore()
    store.seedMockData()

    return EvaluationView(clothesStore: store)
}
