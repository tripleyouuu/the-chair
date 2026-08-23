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


    private let cardCornerRadius: CGFloat = 24

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
        verdictIsWash ? "Wash" : "Keep"
    }

    private var verdictButtonAsset: String {
        verdictIsWash ? "cornflowerBlueButton" : "tanButton"
    }

    private var secondaryActionText: String {
        verdictIsWash ? "Nah, I'll keep" : "Nah, I'll wash"
    }

    private var screenBackground: some View {
        ZStack {
            Color("backgroundBase")
            Image("Texture")
        }
        .ignoresSafeArea()
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(screenBackground)
        .navigationTitle("Evaluate")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("EVALUATE")
                    .font(Font.custom("SueEllenFrancisco", size: 32))
                    .fontDesign(nil)
                    .foregroundStyle(.deepBrown)
                    .padding(.top, 8)
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    finishSession()
                } label: {
                    Image("backButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
            }
            .sharedBackgroundVisibility(.hidden)
            

            // ^ a custom back button was needed to make the go-straight-home logic work
            
            
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    PileListView(
                        clothesStore: clothesStore,
                        currentIndex: $currentIndex,
                        selectionVersion: $selectionVersion,
                        toast: $toast
                    )
                } label: {
                    ZStack{
                        Image("primaryButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                        Image(systemName: "list.dash")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.offWhite)
                    }
                }
                .buttonStyle(.plain)
            }
            .sharedBackgroundVisibility(.hidden)
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
            VStack(spacing: 20) {
                garmentPreview(for: item)

                evaluationCard(for: item)

                verdictSection
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .scrollDismissesKeyboard(.interactively)
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

    private func evaluationCard(for item: ClothingItem) -> some View {
        VStack(spacing: 0) {
            if item.clothingMaterial == .silk {
                infoSection(silkInfoText)
            } else if item.clothingMaterial == .dryFit {
                infoSection(dryFitInfoText)
            } else if item.clothingColor == .white &&
                        item.clothingMaterial != .denim &&
                        item.clothingMaterial != .wool &&
                        item.clothingMaterial != .silk {
                infoSection(whiteInfoText)
            } else {
                durationSection
                cardDivider
                environmentSection
                cardDivider
                activitySection
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous)
                .fill(.white)
        )
    }

    private func garmentPreview(for item: ClothingItem) -> some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                GarmentIconView(item: item)
                    .frame(width: 220, height: 220)

                if let imageName = item.referenceImageName,
                   let image = ImageStorage.loadImage(named: imageName) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 96)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                        )
                        .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 3)
                        .offset(x: 24)
                }
            }

            Text(item.nickname ?? "Nickname") // TODO: add auto nickname logic
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundStyle(.sienna)
        }
    }

    private var cardDivider: some View {
        Rectangle()
            .fill(Color.deepBrown.opacity(0.12))
            .frame(height: 1)
            .padding(.vertical, 16)
    }

    private func infoSection(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 15, design: .rounded))
            .foregroundStyle(.sienna)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
    }

    private var silkInfoText: String {
        "This garment is made of silk! In order to preserve the durability of this fabric, it is not recommended to wash it unless absolutely necessary (heavy sweat, staining, etc.)"
    }

    private var dryFitInfoText: String {
        "This garment is made of a dry-fit material. As it does not absorb sweat, in order to avoid bacterial growth and odor, it is recommended to wash it even after light use."
    }

    private var whiteInfoText: String {
        "This garment is white in color. In order to preserve the brightness of the white fabric, it is recommended to wash it even after light use."
    }

    private func sectionHeader(_ title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.deepBrown)

            Text(description)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(Color("textGrey"))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func stepperButton(
        systemName: String,
        fill: Color,
        glyph: Color,
        isDisabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(fill)
                    .frame(width: 32, height: 32)

                Image(systemName: systemName)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(glyph)
            }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.4 : 1)
    }

    private var durationSection: some View {
        HStack {
            Text("Hours worn")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.deepBrown)

            Spacer()

            HStack(spacing: 12) {
                stepperButton(
                    systemName: "minus",
                    fill: .tan,
                    glyph: .sienna,
                    isDisabled: hoursWorn <= (currentItem?.savedEvaluation?.hoursWorn ?? 1) // cant reduce in later evals lah
                ) {
                    inputWasChanged = true
                    hoursWorn = max(1, hoursWorn - 1)
                    hoursWornText = String(hoursWorn)
                    durationFieldFocused = false
                }

                TextField("", text: $hoursWornText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(.deepBrown)
                    .frame(width: 44)
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

                            if durationFieldFocused {
                                inputWasChanged = true
                            }
                        }
                    }

                stepperButton(
                    systemName: "plus",
                    fill: .sienna,
                    glyph: .tan,
                    isDisabled: hoursWorn >= 99
                ) {
                    inputWasChanged = true
                    hoursWorn = min(99, hoursWorn + 1)
                    hoursWornText = String(hoursWorn)
                    durationFieldFocused = false
                }
            }
        }
    }

    private var environmentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Environment", description: environmentDescription)

            HStack(spacing: 12) {
                Image(systemName: "thermometer.low")
                    .font(.system(size: 17, weight: .semibold))
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
                .tint(.tan)

                Image(systemName: "thermometer.high")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Activity", description: activityDescription)

            HStack(spacing: 12) {
                Image(systemName: "figure.seated.side")
                    .font(.system(size: 17, weight: .semibold))
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
                .tint(.tan)

                Image(systemName: "figure.run")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var verdictSection: some View {
        VStack(spacing: 12) {
            Button {
                registerDecision(washing: verdictIsWash)
            } label: {
                ZStack {
                    Image(verdictButtonAsset)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)

                    Text(verdictText)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(.offWhite)
                }
            }
            .buttonStyle(.plain)

            Button {
                registerDecision(washing: !verdictIsWash)
            } label: {
                Text(secondaryActionText)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundStyle(.sienna)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 4)
    }
    // unused
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

    // unused
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
