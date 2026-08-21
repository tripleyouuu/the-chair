//
//  NotificationsSettingsView.swift
//  the chair
//
//  Created by Aurora Purnawan on 20/08/26.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @ObservedObject var notificationsStore: NotificationsStore

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                dailyCheckInSection
                laundryReminderSection
            }
            .padding(20)
        }
        .background(
            ZStack {
                Color("backgroundBase")
                Image("Texture")
            }
            .ignoresSafeArea()
        )
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.circle)
            }
        }
    }

    private var dailyCheckInSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "clock.badge")
                    Text("Daily Check-In")
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { notificationsStore.dailyCheckInEnabled },
                        set: { notificationsStore.setDailyCheckIn(enabled: $0) }
                    ))
                    .labelsHidden()
                }
                .padding()

                if notificationsStore.dailyCheckInEnabled {
                    Divider().padding(.leading)

                    HStack {
                        Text("Reminder Time")
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
                .foregroundStyle(.secondary)
        }
    }

    private var laundryReminderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "washer")
                    Text("Laundry Day Reminder")
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { notificationsStore.laundryReminderEnabled },
                        set: { notificationsStore.setLaundryReminder(enabled: $0) }
                    ))
                    .labelsHidden()
                }
                .padding()

                if notificationsStore.laundryReminderEnabled {
                    Divider().padding(.leading)

                    HStack {
                        Text("Reminder Day")
                        Spacer()
                        Picker("", selection: Binding(
                            get: { notificationsStore.laundryReminderDay },
                            set: { notificationsStore.setLaundryReminder(enabled: true, day: $0) }
                        )) {
                            ForEach(Weekday.allCases) { day in
                                Text(day.name).tag(day)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                    }
                    .padding()

                    Divider().padding(.leading)

                    HStack {
                        Text("Reminder Time")
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
                .foregroundStyle(.secondary)
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
