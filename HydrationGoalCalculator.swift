//
//  HydrationGoalCalculator.swift
//  HydrationCoach
//
//  Created by Sreejith Menon on 11/16/25.
//


// File: HydrationGoalCalculator.swift

import Foundation

struct HydrationGoalCalculator {
    /// Very simple science-based guideline (not medical advice):
    /// - Base: ~35 ml per kg body weight.
    /// - Activity: adds 10–35% based on activity level.
    /// - Gender/Age: small +/- 5-10%.
    static func calculateGoalMl(for profile: UserProfile, unit: WeightUnit) -> Int {
        let weightKg: Double
        switch unit {
        case .kg:
            weightKg = profile.weight
        case .lbs:
            weightKg = profile.weight * 0.45359237
        }
        
        var mlPerKg = 35.0 // base guideline
        
        // Adjust for activity
        switch profile.activityLevel {
        case .sedentary:
            mlPerKg *= 1.0
        case .light:
            mlPerKg *= 1.1
        case .moderate:
            mlPerKg *= 1.2
        case .intense:
            mlPerKg *= 1.35
        }
        
        // Adjust for age
        if profile.age < 18 {
            mlPerKg *= 1.05
        } else if profile.age > 55 {
            mlPerKg *= 0.95
        }
        
        // Adjust slightly by gender
        switch profile.gender {
        case .female:
            mlPerKg *= 0.95
        case .male:
            mlPerKg *= 1.05
        case .other:
            break
        }
        
        let goal = Int(weightKg * mlPerKg)
        
        // Clamp between a reasonable range: 1200 ml – 4500 ml
        return min(max(goal, 1200), 4500)
    }
}
