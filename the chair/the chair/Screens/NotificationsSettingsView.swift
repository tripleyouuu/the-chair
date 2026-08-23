//
//  NotificationsSettingsView.swift
//  the chair
//
//  Created by Aurora Purnawan on 20/08/26.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @ObservedObject var notificationsStore: NotificationsStore

//    @Environment(\.dismiss) private var dismiss
    
// TODO: fix the fucking padding space wtv

    var body: some View {
        ScrollView {
            VStack() {
                dailyCheckInSection
                laundryReminderSection
            }
            .padding(20)
            
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("SETTINGS")
                    .font(Font.custom("SueEllenFrancisco", size: 32))
                    .fontDesign(nil)
                    .padding(.top,8)
                    .foregroundStyle(.deepBrown)
            }
        }
        .background(
            ZStack {
                Color("backgroundBase")
                Image("Texture")
            }
                .ignoresSafeArea()
        )
        .backButton(.custom)
//        .navigationTitle("Settings")
//        .navigationBarTitleDisplayMode(.inline)
    }
    
    

    private var dailyCheckInSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "clock.badge")
                    Text("Daily Check-In")
                        .foregroundStyle(.deepBrown)
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { notificationsStore.dailyCheckInEnabled },
                        set: { notificationsStore.setDailyCheckIn(enabled: $0) }
                    ))
                    .tint(.darkGreen)
                    .labelsHidden()
                }
                .padding()

                if notificationsStore.dailyCheckInEnabled {
                    Divider().padding(.leading)

                    HStack {
                        Text("Reminder Time")
                            .foregroundStyle(.deepBrown)
                        Spacer()
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { date(from: notificationsStore.dailyCheckInTime) },
                                set: { notificationsStore.setDailyCheckIn(enabled: true, time: components(from: $0)) }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                        .labelsHidden()
                    }
                    .padding()
                }
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text("Get reminded to log any new additions to your Pile each day.")
                .font(.caption)
                .foregroundStyle(.sienna)
                .opacity(0.8)
        }
    }

    private var laundryReminderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "washer")
                    Text("Laundry Day Reminder")
                        .foregroundStyle(.deepBrown)
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { notificationsStore.laundryReminderEnabled },
                        set: { notificationsStore.setLaundryReminder(enabled: $0) }
                    ))
                    .tint(.darkGreen)
                    .labelsHidden()
                }
                .padding()

                if notificationsStore.laundryReminderEnabled {
                    Divider().padding(.leading)

                    HStack {
                        Text("Reminder Day")
                            .foregroundStyle(.deepBrown)
                        Spacer()
                        Picker("", selection: Binding(
                            get: { notificationsStore.laundryReminderDay },
                            set: { notificationsStore.setLaundryReminder(enabled: true, day: $0) }
                        )) {
                            ForEach(Weekday.allCases) { day in
                                Text(day.name).tag(day)
                            }
                        }
                        .tint(.sienna)
                        .pickerStyle(.menu)
                        .labelsHidden()
                    }
                    .padding()

                    Divider().padding(.leading)

                    HStack {
                        Text("Reminder Time")
                            .foregroundStyle(.deepBrown)
                        Spacer()
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { date(from: notificationsStore.laundryReminderTime) },
                                set: { notificationsStore.setLaundryReminder(enabled: true, time: components(from: $0)) }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                        .labelsHidden()
                    }
                    .padding()
                }
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text("Make sure you never miss laundry day with a weekly nudge from The Chair to evaluate your pile before washing!")
                .font(.caption)
                .foregroundStyle(.sienna)
                .opacity(0.8)
        }
    }

    // DatePicker works in terms of Date, our store works in terms of hour/minute
    // DateComponents — these two just translate between them.
    private func date(from components: DateComponents) -> Date {
        Calendar.current.date(from: components) ?? Date()
    }

    private func components(from date: Date) -> DateComponents {
        Calendar.current.dateComponents([.hour, .minute], from: date)
    }
}

#Preview {
    NavigationStack {
        NotificationsSettingsView(notificationsStore: NotificationsStore())
    }
}
