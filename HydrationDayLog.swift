// File: HydrationDayLog.swift

import Foundation

struct HydrationEntry: Codable, Identifiable {
    let id: UUID
    let timestamp: Date
    let amountMl: Int
    
    init(amountMl: Int, timestamp: Date = Date()) {
        self.id = UUID()
        self.amountMl = amountMl
        self.timestamp = timestamp
    }
}

struct HydrationDayLog: Codable, Identifiable {
    let id: UUID
    var date: Date
    var goalMl: Int
    var totalIntakeMl: Int
    var entries: [HydrationEntry]
    
    /// 1 glass ≈ 8 fl oz ≈ 240 ml (rounded for simplicity)
    static let mlPerGlass: Double = 240.0
    
    init(date: Date = Date(), goalMl: Int, totalIntakeMl: Int = 0, entries: [HydrationEntry] = []) {
        self.id = UUID()
        self.date = date
        self.goalMl = goalMl
        self.totalIntakeMl = totalIntakeMl
        self.entries = entries
    }
    
    var progress: Double {
        guard goalMl > 0 else { return 0 }
        return min(Double(totalIntakeMl) / Double(goalMl), 2.0)
    }
    
    var isGoalReached: Bool {
        totalIntakeMl >= goalMl
    }
    
    var reached80Percent: Bool {
        totalIntakeMl >= Int(Double(goalMl) * 0.8)
    }
    
    // MARK: - Glasses helpers
    
    var totalGlasses: Double {
        Double(totalIntakeMl) / Self.mlPerGlass
    }
    
    var goalGlasses: Double {
        Double(goalMl) / Self.mlPerGlass
    }
    
    func adding(amountMl: Int) -> HydrationDayLog {
        var copy = self
        copy.totalIntakeMl += amountMl
        copy.entries.append(HydrationEntry(amountMl: amountMl))
        return copy
    }
    
    func startOfDay() -> Date {
        Calendar.current.startOfDay(for: date)
    }
}

