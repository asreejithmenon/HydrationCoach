// File: UserProfile.swift

import Foundation

enum Gender: String, Codable, CaseIterable, Identifiable {
    case female
    case male
    case other
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .female: return "Female"
        case .male: return "Male"
        case .other: return "Other / Prefer not to say"
        }
    }
}

enum ActivityLevel: String, Codable, CaseIterable, Identifiable {
    case sedentary
    case light
    case moderate
    case intense
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .sedentary: return "Sedentary"
        case .light: return "Light"
        case .moderate: return "Moderate"
        case .intense: return "Intense"
        }
    }
}

enum WeightUnit: String, Codable, CaseIterable, Identifiable {
    case kg
    case lbs
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .kg: return "Kilograms (kg)"
        case .lbs: return "Pounds (lbs)"
        }
    }
}

struct UserProfile: Codable {
    var age: Int
    var gender: Gender
    var weight: Double
    var heightCm: Double?
    var activityLevel: ActivityLevel
    
    static let empty = UserProfile(
        age: 30,
        gender: .other,
        weight: 70,
        heightCm: nil,
        activityLevel: .moderate
    )
    
    var isConfigured: Bool {
        age > 0 && weight > 0
    }
}

