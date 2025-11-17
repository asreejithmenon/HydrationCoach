// File: HydrationSettings.swift

import Foundation

struct HydrationSettings: Codable {
    var weightUnit: WeightUnit
    var dailyGoalMl: Int
    var remindersEnabled: Bool
    var reminderFrequencyMinutes: Int
    var wakeTime: Date
    var sleepTime: Date
    
    /// Optional bottle size in ounces, e.g. 64 oz.
    /// If nil, the app will just show glasses and ml.
    var bottleSizeOz: Double?
    
    static func defaultSettings() -> HydrationSettings {
        // Default wake/sleep using today's date with typical hours
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        let wakeComponents = DateComponents(
            year: components.year,
            month: components.month,
            day: components.day,
            hour: 7,
            minute: 0
        )
        let sleepComponents = DateComponents(
            year: components.year,
            month: components.month,
            day: components.day,
            hour: 23,
            minute: 0
        )
        
        let wakeDate = calendar.date(from: wakeComponents) ?? now
        let sleepDate = calendar.date(from: sleepComponents) ?? now.addingTimeInterval(16 * 3600)
        
        return HydrationSettings(
            weightUnit: .kg,
            dailyGoalMl: 2000,
            remindersEnabled: false,
            reminderFrequencyMinutes: 120,
            wakeTime: wakeDate,
            sleepTime: sleepDate,
            bottleSizeOz: nil   // user can set this later
        )
    }
}

