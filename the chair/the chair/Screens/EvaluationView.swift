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
    @Binding var toast: Toast?
    @State private var currentIndex: Int
    @State private var hoursWorn = 8
    @State private var hoursWornText = "8"
    @FocusState private var durationFieldFocused: Bool // so u can escape the keyboard
    @State private var environmentIndex = 2
    @State private var activityIndex = 2
    @State private var sessionVisitedIDs: Set<UUID> = []
    @State private var sessionStarted = false
    @State private var currentItemIsRevisit = false
    @State private var selectionVersion = 0
    @State private var inputWasChanged = false
    @AppStorage("clothesSavedFromOverWashing") private var clothesSavedFromOverWashing = 0
    @AppStorage("clothesSavedFromOverWashingIDs") private var clothesSavedFromOverWashingIDs = ""
    
    init(
        clothesStore: ClothesStore,
        initialIndex: Int? = nil,
        toast: Binding<Toast?>
    ) {
        self.clothesStore = clothesStore
        self._toast = toast
        let startingIndex = initialIndex ?? max(clothesStore.pile.count - 1, 0)
        _currentIndex = State(initialValue: startingIndex)
    }
    
    // persistence and session experimentation
    private func loadItem(at index: Int, revisited: Bool) {
        guard index >= 0, index < clothesStore.pile.count else {
            finishSession()
            return
        }

        let item = clothesStore.pile[index]

        currentIndex = index
        currentItemIsRevisit = revisited
        sessionVisitedIDs.insert(item.id)

        if let saved = item.savedEvaluation {
            hoursWorn = saved.hoursWorn
            hoursWornText = String(saved.hoursWorn)
            environmentIndex = saved.environmentIndex
            activityIndex = saved.activityIndex
        } else {
            hoursWorn = 8
            hoursWornText = "8"
            environmentIndex = 2
            activityIndex = 2
        }

        durationFieldFocused = false
        inputWasChanged = false
    }
    
    private func startSession() {
        guard !sessionStarted else { return }

        sessionStarted = true
        sessionVisitedIDs.removeAll()

        guard !clothesStore.pile.isEmpty else {
            finishSession()
            return
        }

        loadItem(
            at: currentIndex,
            revisited: false
        )
    }
    
    private func finishSession(showToast: Bool = false) {
        sessionStarted = false
        sessionVisitedIDs.removeAll()

        if showToast {
            toast = Toast(message: "Sorted all items in pile!")
        }

        dismiss()
    }
    
    private func advanceToNextItem() {
        let nextIndex = clothesStore.pile.indices.reversed().first {
            !sessionVisitedIDs.contains(clothesStore.pile[$0].id)
        }

        guard let nextIndex else {
            finishSession(showToast: true)
            return
        }

        loadItem(
            at: nextIndex,
            revisited: false
        )
    }
    
    private var evaluationIsLocked: Bool {
        guard let item = currentItem else { return false }
        return item.savedEvaluation != nil && !currentItemIsRevisit
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
        guard !clothesStore.pile.isEmpty,
              currentIndex < clothesStore.pile.count else {
            return nil
        }

        return clothesStore.pile[currentIndex]
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
                    finishSession()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }

            // a custom back button was needed to make the go-straight-home logic work
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    PileListView(
                        clothesStore: clothesStore,
                        currentIndex: $currentIndex,
                        selectionVersion: $selectionVersion
                    )
                } label: {
                    Image(systemName: "list.dash")
                }
            }
        }
        .onAppear {
            startSession()
        }
        .onChange(of: selectionVersion) { _, _ in
            guard let currentItem else { return }
            let wasAlreadyVisited = sessionVisitedIDs.contains(currentItem.id)

            loadItem(
                at: currentIndex,
                revisited: wasAlreadyVisited
            )
        }
    }

    private func evaluationContent(for item: ClothingItem) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                garmentPreview(for: item)
                
                // fuckass returns

                if item.clothingMaterial == .silk {
                    silkInfoSection
                } else if item.clothingMaterial == .dryFit {
                    dryFitInfoSection
                } else if item.clothingColor == .white &&
                            item.clothingMaterial != .denim &&
                            item.clothingMaterial != .wool &&
                            item.clothingMaterial != .silk {
                    whiteInfoSection
                } else {
                    durationSection
                    environmentSection
                    activitySection
                }

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
                    GarmentIconView(item: item)
                        .frame(width: 160, height: 160)
                }

            Text(item.nickname ?? "Nickname") // TODO: add auto nickname logic
                .font(.headline)
        }
    }
    
    // fuckass returns returns
    
    private var silkInfoSection: some View {
        Text("This garment is made of silk! In order to preserve the durability of this fabric, it is not recommended to wash it unless absolutely necessary (heavy sweat, staining, etc.)")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .frame(height: 264)
    }
    private var dryFitInfoSection: some View {
        Text("This garment is made of a dry-fit material. As it does not absorb sweat, in order to avoid bacterial growth and odor, it is recommended to wash it even after light use.")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .frame(height: 264)
    }

    private var whiteInfoSection: some View {
        Text("This garment is white in color. In order to preserve the brightness of the white fabric, it is recommended to wash it even after light use.")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .frame(height: 264)
    }

    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Duration worn:")
                    .font(.headline)

                Spacer()

                HStack(spacing: 8) {
                    Button {
                        inputWasChanged = true
                        hoursWorn = max(1, hoursWorn - 1)
                        hoursWornText = String(hoursWorn)
                        durationFieldFocused = false
                    } label: {
                        Image(systemName: "minus")
                    }
                    .disabled(hoursWorn <= (currentItem?.savedEvaluation?.hoursWorn ?? 1) || evaluationIsLocked) // cant reduce in later evals lah

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
                                let minimum = evaluationIsLocked
                                    ? (currentItem?.savedEvaluation?.hoursWorn ?? 1)
                                    : 1

                                hoursWorn = min(99, max(minimum, value))

                                if evaluationIsLocked {
                                    hoursWornText = String(hoursWorn)
                                }
                                
                                if durationFieldFocused {
                                    inputWasChanged = true
                                }
                            }
                        }

                    Button {
                        inputWasChanged = true
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

                .buttonStyle(.bordered)
                .buttonBorderShape(.circle) // env info
                
            }

            HStack(spacing: 16) {
                Image(systemName: "snowflake")
                    .foregroundStyle(.secondary)

                Slider(
                    value: Binding(
                        get: { Double(environmentIndex) },
                        set: {
                            let newValue: Int
                            if evaluationIsLocked {
                                newValue = max(
                                    currentItem?.savedEvaluation?.environmentIndex ?? 0,
                                    Int($0.rounded())
                                )
                            } else {
                                newValue = Int($0.rounded())
                            }

                            if newValue != environmentIndex {
                                inputWasChanged = true
                            }

                            environmentIndex = newValue
                        }
                    ),
                    in: 0...4,
                    step: 1
                )

                Image(systemName: "sun.max")
                    .foregroundStyle(.secondary)
            }
            Text(environmentDescription)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Activity level:")
                    .font(.headline)

                Text(activityName)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 16) {
                Image(systemName: "figure.seated.side")
                    .foregroundStyle(.secondary)
                Slider(
                    value: Binding(
                        get: { Double(activityIndex) },
                        set: {
                            let newValue: Int
                            if evaluationIsLocked {
                                newValue = max(
                                    currentItem?.savedEvaluation?.activityIndex ?? 0,
                                    Int($0.rounded())
                                )
                            } else {
                                newValue = Int($0.rounded())
                            }

                            if newValue != activityIndex {
                                inputWasChanged = true
                            }

                            activityIndex = newValue
                        }
                    ),
                    in: 0...4,
                    step: 1
                )
                Image(systemName: "figure.run")
                    .foregroundStyle(.secondary)
            }
            Text(activityDescription)
                .font(.caption)
                .foregroundStyle(.secondary)
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
    
    private var environmentDescription: String {
        switch currentEnvironment {
        case .cold:
            return "Air conditioned or winter; almost no sweat."
        case .cool:
            return "Generally chilly conditions; very little sweat."
        case .mild:
            return "Neither chilly nor stuffy, moderate sweat."
        case .warm:
            return "Generally stuffy conditions; quite sweaty."
        case .hot:
            return "Suffocating or summer; very sweaty."
        }
    }

    private var activityDescription: String {
        switch currentActivity {
        case .resting:
            return "Sedentary with little to no movement."
        case .light:
            return "Some movement such as a short walk."
        case .moderate:
            return "Average movement - brisk walks / brief exercise."
        case .active:
            return "Constant movement - long walks / moderate exercise."
        case .intense:
            return "High-energy movement - dancing / gymming."
        }
    }
    
    // making sure the clothes-saved counter doesn't increment unless modified before keeping
    
    private func registerSavedGarment(_ id: UUID) {
        guard inputWasChanged else { return }

        var savedIDs = Set(
            clothesSavedFromOverWashingIDs
                .split(separator: ",")
                .compactMap { UUID(uuidString: String($0)) }
        )

        guard savedIDs.insert(id).inserted else { return }

        clothesSavedFromOverWashingIDs = savedIDs
            .map(\.uuidString)
            .joined(separator: ",")

        clothesSavedFromOverWashing = savedIDs.count
    }

    private func registerDecision(washing: Bool) {
        guard currentIndex < clothesStore.pile.count else { return }

        let currentItem = clothesStore.pile[currentIndex]

        if washing {
            clothesStore.sendToLaundry([currentItem.id])
        } else {
            clothesStore.pile[currentIndex].savedEvaluation = SavedEvaluation(
                hoursWorn: hoursWorn,
                environmentIndex: environmentIndex,
                activityIndex: activityIndex
            )
            clothesStore.savePersistence()
            registerSavedGarment(currentItem.id)
        }

        advanceToNextItem()
    }

//    private func advanceToNextItem() {
//        if currentIndex > 0 {
//            currentIndex -= 1
//        } else {
//            currentIndex = clothesStore.pile.count - 1
//        }
//
//        hoursWorn = 8
//        hoursWornText = "8"
//        durationFieldFocused = false
//        environmentIndex = 2
//        activityIndex = 2
//    }
}

#Preview {
    let store = ClothesStore()

    NavigationStack {
        EvaluationView(
            clothesStore: store,
            toast: .constant(nil)
        )
    }
}
