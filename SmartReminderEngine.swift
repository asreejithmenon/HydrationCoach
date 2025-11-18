// File: SmartReminderEngine.swift

import Foundation

/// SmartReminderEngine adjusts reminder frequency and message
/// based on how on-track the user is for the current time of day.
struct SmartReminderEngine {
    
    /// Expected progress fraction (0.0 – 1.0) based on time between wake and sleep.
    static func expectedProgressFraction(settings: HydrationSettings,
                                         now: Date = Date()) -> Double {
        let calendar = Calendar.current
        let dayComponents = calendar.dateComponents([.year, .month, .day], from: now)
        
        let wakeComponents = calendar.dateComponents([.hour, .minute], from: settings.wakeTime)
        let sleepComponents = calendar.dateComponents([.hour, .minute], from: settings.sleepTime)
        
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
              let sleepDate = calendar.date(from: sleepDateComponents),
              sleepDate > wakeDate else {
            return 0.0
        }
        
        if now <= wakeDate {
            return 0.0
        }
        if now >= sleepDate {
            return 1.0
        }
        
        let span = sleepDate.timeIntervalSince(wakeDate)
        if span <= 0 { return 0.0 }
        let elapsed = now.timeIntervalSince(wakeDate)
        let fraction = elapsed / span
        return min(max(fraction, 0.0), 1.0)
    }
    
    /// Adjusts reminder frequency based on current vs expected progress.
    static func adjustedFrequencyMinutes(baseFrequency: Int,
                                         settings: HydrationSettings,
                                         todayLog: HydrationDayLog,
                                         now: Date = Date()) -> Int {
        let expected = expectedProgressFraction(settings: settings, now: now)
        let current = min(max(todayLog.progress, 0.0), 1.0)
        var frequency = baseFrequency
        
        // If user is clearly behind schedule, nudge more often.
        if current < expected * 0.7 {
            frequency = max(30, Int(Double(baseFrequency) * 0.66)) // ~33% more frequent
        }
        // If user is clearly ahead, back off a bit.
        else if current > max(expected, 0.2) * 1.3 {
            frequency = min(180, Int(Double(baseFrequency) * 1.5)) // ~50% less frequent
        } else {
            frequency = baseFrequency
        }
        
        return max(15, frequency)
    }
    
    /// Human-friendly message for reminders based on progress vs expected.
    static func message(forProgress currentProgress: Double,
                        expectedProgress: Double) -> String {
        let percent = Int(currentProgress * 100)
        
        if expectedProgress == 0 {
            // Early in the day
            return "Start your day with a glass of water to support focus, energy, and mood."
        }
        
        if currentProgress < expectedProgress * 0.7 {
            return "You’re a bit behind your hydration pace today. A quick glass now can help you catch up (\(percent)% of your goal)."
        } else if currentProgress > expectedProgress * 1.3 {
            return "You’re ahead of your usual pace (\(percent)% of your goal). Nice work—stay steady with small sips."
        } else {
            return "You’re roughly on track for your hydration goal (\(percent)%). A glass now keeps your pace comfortable."
        }
    }
}
