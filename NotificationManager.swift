// File: NotificationManager.swift

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// Schedules local notifications between wake and sleep times.
    /// Uses SmartReminderEngine to adapt frequency and message based on how on-track the user is.
    func scheduleHydrationNotifications(settings: HydrationSettings, todayLog: HydrationDayLog) {
        guard settings.remindersEnabled else { return }
        
        let center = UNUserNotificationCenter.current()
        cancelAllNotifications()
        
        let calendar = Calendar.current
        let now = Date()
        
        // Build today's wake/sleep using stored hour/minute from settings.
        let wakeComponents = calendar.dateComponents([.hour, .minute], from: settings.wakeTime)
        let sleepComponents = calendar.dateComponents([.hour, .minute], from: settings.sleepTime)
        
        let dayComponents = calendar.dateComponents([.year, .month, .day], from: now)
        
        var wakeDateComponents = DateComponents()
        wakeDateComponents.year = dayComponents.year
        wakeDateComponents.month = dayComponents.month
        wakeDateComponents.day = dayComponents.day
        wakeDateComponents.hour = wakeComponents.hour
        wakeDateComponents.minute = wakeComponents.minute
        
        var sleepDateComponents = DateComponents()
        sleepDateComponents.year = dayComponents.year
        sleepDateComponents.month = dayComponents.month
        sleepDateComponents.day = dayComponents.day
        sleepDateComponents.hour = sleepComponents.hour
        sleepDateComponents.minute = sleepComponents.minute
        
        guard let wakeDate = calendar.date(from: wakeDateComponents),
              let sleepDate = calendar.date(from: sleepDateComponents) else {
            return
        }
        
        if sleepDate <= wakeDate {
            // If times are inverted, skip scheduling to avoid weird behavior.
            return
        }
        
        let expectedProgress = SmartReminderEngine.expectedProgressFraction(settings: settings, now: now)
        let adjustedMinutes = SmartReminderEngine.adjustedFrequencyMinutes(
            baseFrequency: settings.reminderFrequencyMinutes,
            settings: settings,
            todayLog: todayLog,
            now: now
        )
        
        let interval = TimeInterval(adjustedMinutes * 60)
        let message = SmartReminderEngine.message(
            forProgress: todayLog.progress,
            expectedProgress: expectedProgress
        )
        
        var currentFireDate = wakeDate
        
        while currentFireDate < sleepDate {
            if currentFireDate > now {
                let content = UNMutableNotificationContent()
                content.title = "Hydration reminder"
                content.body = message
                content.sound = UNNotificationSound.default
                
                let triggerDateComponents = calendar.dateComponents(
                    [.year, .month, .day, .hour, .minute],
                    from: currentFireDate
                )
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
                
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )
                
                center.add(request, withCompletionHandler: nil)
            }
            currentFireDate = currentFireDate.addingTimeInterval(interval)
        }
    }
}


