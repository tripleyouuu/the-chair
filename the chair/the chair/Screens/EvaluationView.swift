//
//  EvaluationView.swift
//
//
//  Created by Vitha Watson on 12/08/26.
//

import SwiftUI

struct EvaluationView: View {
    @ObservedObject var clothesStore: ClothesStore

    @Environment(\.dismiss) private var dismiss

    @State private var currentIndex: Int
    @State private var hoursWorn = 8
    @State private var hoursWornText = "8"
    @FocusState private var durationFieldFocused: Bool // so u can escape the keyboard
    @State private var environmentIndex = 2
    @State private var activityIndex = 2

    init(
        clothesStore: ClothesStore,
        initialIndex: Int? = nil
    ) {
        self.clothesStore = clothesStore

        let startingIndex = initialIndex ?? max(clothesStore.clothes.count - 1, 0)
        _currentIndex = State(initialValue: startingIndex)
    }

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
            hoursWorn: Double(hoursWorn),
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }

            // a custom back button was needed to make the go-straight-home logic work
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    PileListView(
                        clothesStore: clothesStore,
                        currentIndex: $currentIndex
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
        .onTapGesture {
            durationFieldFocused = false
        }
        .onChange(of: durationFieldFocused) { _, focused in
            if focused {
                if hoursWornText == "8" {
                    hoursWornText = ""
                }
            } else {
                if hoursWornText.isEmpty {
                    hoursWorn = 8
                    hoursWornText = "8"
                } else if let value = Int(hoursWornText) {
                    hoursWorn = min(99, max(1, value))
                    hoursWornText = String(hoursWorn)
                } else {
                    hoursWorn = 8
                    hoursWornText = "8"
                }
            }
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
                Text("Duration worn:")
                    .font(.headline)

                Spacer()

                HStack(spacing: 8) {
                    Button {
                        hoursWorn = max(1, hoursWorn - 1)
                        hoursWornText = String(hoursWorn)
                        durationFieldFocused = false
                    } label: {
                        Image(systemName: "minus")
                    }
                    .disabled(hoursWorn <= 1)

                    TextField("", text: $hoursWornText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .frame(width: 60)
                        .focused($durationFieldFocused)
                        .onChange(of: hoursWornText) { _, newValue in
                            let numbersOnly = newValue.filter(\.isNumber)

                            if numbersOnly != newValue {
                                hoursWornText = numbersOnly
                                return
                            }

                            if let value = Int(numbersOnly) {
                                if value > 99 {
                                    hoursWornText = "99"
                                    hoursWorn = 99
                                } else {
                                    hoursWorn = value
                                }
                            }
                        }

                    Button {
                        hoursWorn = min(99, hoursWorn + 1)
                        hoursWornText = String(hoursWorn)
                        durationFieldFocused = false
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(hoursWorn >= 99)
                }
                
                Text("     hours")
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
            clothesStore.clothes[currentIndex].location = .washList
            print("\(currentItem.nickname ?? "Garment") has been added to laundry bag")
        } else {
            clothesStore.clothes[currentIndex].location = .pile
            print("\(currentItem.nickname ?? "Garment") has been returned to the pile")
        }

        clothesStore.persistence.save(clothesStore.clothes)

        advanceToNextItem()
    }

    private func advanceToNextItem() {
        if currentIndex > 0 {
            currentIndex -= 1
        } else {
            currentIndex = clothesStore.clothes.count - 1
        }

        hoursWorn = 8
        hoursWornText = "8"
        durationFieldFocused = false
        environmentIndex = 2
        activityIndex = 2
    }
}

#Preview {
    let store = ClothesStore()
    store.seedMockData()

    return NavigationStack {
        EvaluationView(clothesStore: store)
    }
}
