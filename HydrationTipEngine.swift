// File: HydrationTipEngine.swift

import Foundation

struct HydrationTipEngine {
    
    /// Generates an "AI-like" hydration tip based on:
    /// - today's progress
    /// - time of day (morning / afternoon / evening)
    /// - recent history (last ~7 days)
    static func tip(for todayLog: HydrationDayLog,
                    recentLogs: [HydrationDayLog],
                    now: Date = Date()) -> String {
        
        // No entries yet today
        if todayLog.entries.isEmpty {
            return "Log your first glass of water to see how today’s hydration is shaping up."
        }
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let timeOfDay: String
        switch hour {
        case 5..<12:
            timeOfDay = "morning"
        case 12..<18:
            timeOfDay = "afternoon"
        default:
            timeOfDay = "evening"
        }
        
        let progress = min(max(todayLog.progress, 0.0), 2.0) // clamp
        let percent = Int(progress * 100)
        
        // Build history including today
        var allLogs = recentLogs
        allLogs.append(todayLog)
        
        // Normalize by day
        let uniqueByDay: [HydrationDayLog] = {
            var byDay: [Date: HydrationDayLog] = [:]
            for log in allLogs {
                byDay[log.startOfDay()] = log
            }
            return byDay.values.sorted { $0.startOfDay() < $1.startOfDay() }
        }()
        
        // Last up-to-7 days including today
        let last7 = Array(uniqueByDay.suffix(7))
        let historyCount = last7.count
        
        var averageProgress: Double?
        if historyCount >= 2 {
            let sum = last7.reduce(0.0) { $0 + min(max($1.progress, 0.0), 2.0) }
            averageProgress = sum / Double(historyCount)
        }
        
        // Base message: today's status + time of day
        let base = baseTip(timeOfDay: timeOfDay, percent: percent, progress: progress)
        
        // Optional comparison vs recent average
        var comparison = ""
        if let avg = averageProgress {
            if progress >= avg * 1.15 {
                comparison = " You’re ahead of your recent average—nice upward trend."
            } else if progress <= avg * 0.85 {
                comparison = " You’re a bit below your recent average, but small, steady sips will get you back on track."
            } else {
                comparison = " You’re roughly in line with your recent days—consistency is what counts."
            }
        }
        
        return base + comparison
    }
    
    // MARK: - Private helpers
    
    private static func baseTip(timeOfDay: String, percent: Int, progress: Double) -> String {
        switch percent {
        case ..<30:
            return lowProgressTip(timeOfDay: timeOfDay)
        case 30..<70:
            return midProgressTip(timeOfDay: timeOfDay)
        case 70..<100:
            return highProgressTip(timeOfDay: timeOfDay)
        default:
            return goalReachedTip(timeOfDay: timeOfDay, percent: percent)
        }
    }
    
    private static func lowProgressTip(timeOfDay: String) -> String {
        switch timeOfDay {
        case "morning":
            return "A glass now helps you start the day hydrated—supporting your focus, mood, and digestion."
        case "afternoon":
            return "You’re still early in your hydration for today. A quick glass now can ease afternoon fatigue."
        default:
            return "You’re a bit light on water today. A glass this evening still supports your kidneys and circulation."
        }
    }
    
    private static func midProgressTip(timeOfDay: String) -> String {
        switch timeOfDay {
        case "morning":
            return "You’re off to a solid start. Hydration this morning supports brain function and energy for the rest of the day."
        case "afternoon":
            return "You’re around the middle of your goal. Staying hydrated this afternoon helps prevent headaches and low energy."
        default:
            return "You’re making steady progress. A glass this evening supports recovery and keeps your body in balance overnight."
        }
    }
    
    private static func highProgressTip(timeOfDay: String) -> String {
        switch timeOfDay {
        case "morning":
            return "You’re well ahead for this morning. Keep sipping steadily rather than all at once for smoother hydration."
        case "afternoon":
            return "You’re closing in on your goal. Hydration now supports muscles, joints, and your ability to handle the rest of the day."
        default:
            return "You’re very close to your goal. A small top-up this evening helps your body flush waste and recover while you sleep."
        }
    }
    
    private static func goalReachedTip(timeOfDay: String, percent: Int) -> String {
        switch timeOfDay {
        case "morning":
            return "You’ve already hit your goal—great job. Listen to thirst cues and keep things balanced."
        case "afternoon":
            return "Hydration goal reached for today. You’re giving your heart, kidneys, and brain exactly what they need."
        default:
            return "You’ve met your hydration goal today. Staying mindful of thirst from here keeps things comfortable and healthy."
        }
    }
}
