//
//  NotificationSettingsPersistence.swift
//  the chair
//
//  Created by Aurora Purnawan on 19/08/26.
//

import Foundation

struct NotificationSettingsPersistence {
    private let storageKey = "notificationSettings"

    private struct PersistedSettings: Codable {
        var dailyCheckInEnabled: Bool
        var dailyCheckInHour: Int
        var dailyCheckInMinute: Int
        var laundryReminderEnabled: Bool
        var laundryReminderDay: Weekday
        var laundryReminderHour: Int
        var laundryReminderMinute: Int
    }

    func load() -> (
        dailyCheckInEnabled: Bool,
        dailyCheckInHour: Int,
        dailyCheckInMinute: Int,
        laundryReminderEnabled: Bool,
        laundryReminderDay: Weekday,
        laundryReminderHour: Int,
        laundryReminderMinute: Int
    )? {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode(PersistedSettings.self, from: data) else {
            return nil
        }
        return (
            decoded.dailyCheckInEnabled,
            decoded.dailyCheckInHour,
            decoded.dailyCheckInMinute,
            decoded.laundryReminderEnabled,
            decoded.laundryReminderDay,
            decoded.laundryReminderHour,
            decoded.laundryReminderMinute
        )
    }

    func save(
        dailyCheckInEnabled: Bool,
        dailyCheckInHour: Int,
        dailyCheckInMinute: Int,
        laundryReminderEnabled: Bool,
        laundryReminderDay: Weekday,
        laundryReminderHour: Int,
        laundryReminderMinute: Int
    ) {
        let bundle = PersistedSettings(
            dailyCheckInEnabled: dailyCheckInEnabled,
            dailyCheckInHour: dailyCheckInHour,
            dailyCheckInMinute: dailyCheckInMinute,
            laundryReminderEnabled: laundryReminderEnabled,
            laundryReminderDay: laundryReminderDay,
            laundryReminderHour: laundryReminderHour,
            laundryReminderMinute: laundryReminderMinute
        )
        guard let data = try? JSONEncoder().encode(bundle) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
