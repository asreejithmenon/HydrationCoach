// File: GamificationEngine.swift

import Foundation

struct Badge: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let requiredStreak: Int
}

struct GamificationEngine {
    
    static let allBadges: [Badge] = [
        Badge(
            id: "rookie",
            name: "Hydration Rookie",
            description: "Hit your goal 3 days in a row.",
            requiredStreak: 3
        ),
        Badge(
            id: "champ",
            name: "Consistency Champ",
            description: "Hit your goal 7 days in a row.",
            requiredStreak: 7
        ),
        Badge(
            id: "hero",
            name: "Hydration Hero",
            description: "Hit your goal 30 days in a row.",
            requiredStreak: 30
        )
    ]
    
    /// Computes current streak based on consecutive days (ending today)
    /// where the user reached at least 80% of their goal.
    static func computeStreak(from logs: [HydrationDayLog]) -> Int {
        guard !logs.isEmpty else { return 0 }
        
        // Sort by date ascending and use start-of-day dates
        let sorted = logs
            .sorted { $0.startOfDay() < $1.startOfDay() }
        
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())
        
        // Map by day for quick lookup
        var logByDay: [Date: HydrationDayLog] = [:]
        for log in sorted {
            logByDay[log.startOfDay()] = log
        }
        
        var streak = 0
        var currentDay = todayStart
        
        while let log = logByDay[currentDay], log.reached80Percent {
            streak += 1
            if let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDay) {
                currentDay = previousDay
            } else {
                break
            }
        }
        
        return streak
    }
    
    static func unlockedBadges(for streak: Int) -> [Badge] {
        allBadges.filter { streak >= $0.requiredStreak }
    }
}

