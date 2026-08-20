//
//  NotificationsStore.swift
//  the chair
//
//  Created by Aurora Purnawan on 19/08/26.
//

import Combine
import Foundation
import UserNotifications

final class NotificationsStore: ObservableObject {
    @Published var dailyCheckInEnabled = false
    @Published var dailyCheckInTime = DateComponents(hour: 9, minute: 41)
    @Published var laundryReminderEnabled = false
    @Published var laundryReminderDay: Weekday = .saturday
    @Published var laundryReminderTime = DateComponents(hour: 9, minute: 41)

    private let persistence = NotificationSettingsPersistence()
    private let center = UNUserNotificationCenter.current()

    private let dailyCheckInID = "dailyCheckIn"
    private let laundryReminderID = "laundryReminder"

    init() {
        if let saved = persistence.load() {
            dailyCheckInEnabled = saved.dailyCheckInEnabled
            dailyCheckInTime = DateComponents(hour: saved.dailyCheckInHour, minute: saved.dailyCheckInMinute)
            laundryReminderEnabled = saved.laundryReminderEnabled
            laundryReminderDay = saved.laundryReminderDay
            laundryReminderTime = DateComponents(hour: saved.laundryReminderHour, minute: saved.laundryReminderMinute)
        }
    }

    func setDailyCheckIn(enabled: Bool, time: DateComponents? = nil) {
        dailyCheckInEnabled = enabled
        if let time { dailyCheckInTime = time }
        savePersistence()

        if enabled {
            requestAuthorizationIfNeeded { [weak self] in
                self?.scheduleDailyCheckIn()
            }
        } else {
            center.removePendingNotificationRequests(withIdentifiers: [dailyCheckInID])
        }
    }

    func setLaundryReminder(enabled: Bool, day: Weekday? = nil, time: DateComponents? = nil) {
        laundryReminderEnabled = enabled
        if let day { laundryReminderDay = day }
        if let time { laundryReminderTime = time }
        savePersistence()

        if enabled {
            requestAuthorizationIfNeeded { [weak self] in
                self?.scheduleLaundryReminder()
            }
        } else {
            center.removePendingNotificationRequests(withIdentifiers: [laundryReminderID])
        }
    }

    private func requestAuthorizationIfNeeded(completion: @escaping () -> Void) {
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                completion()
            case .notDetermined:
                self.center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    if granted { completion() }
                }
            default:
                break
            }
        }
    }

    private func scheduleDailyCheckIn() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Check-In"
        content.body = "Log any new additions to your Pile today."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: dailyCheckInTime, repeats: true)
        let request = UNNotificationRequest(identifier: dailyCheckInID, content: content, trigger: trigger)

        center.removePendingNotificationRequests(withIdentifiers: [dailyCheckInID])
        center.add(request)
    }

    private func scheduleLaundryReminder() {
        var components = laundryReminderTime
        components.weekday = laundryReminderDay.rawValuew

        let content = UNMutableNotificationContent()
        content.title = "Laundry Day Reminder"
        content.body = "Evaluate your pile before washing!"
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: laundryReminderID, content: content, trigger: trigger)

        center.removePendingNotificationRequests(withIdentifiers: [laundryReminderID])
        center.add(request)
    }

    private func savePersistence() {
        persistence.save(
            dailyCheckInEnabled: dailyCheckInEnabled,
            dailyCheckInHour: dailyCheckInTime.hour ?? 9,
            dailyCheckInMinute: dailyCheckInTime.minute ?? 0,
            laundryReminderEnabled: laundryReminderEnabled,
            laundryReminderDay: laundryReminderDay,
            laundryReminderHour: laundryReminderTime.hour ?? 9,
            laundryReminderMinute: laundryReminderTime.minute ?? 0
        )
    }
}
