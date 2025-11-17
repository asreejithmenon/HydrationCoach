//
//  PersistenceManager.swift
//  HydrationCoach
//
//  Created by Sreejith Menon on 11/16/25.
//


// File: PersistenceManager.swift

import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys {
        static let userProfile = "userProfile"
        static let hydrationSettings = "hydrationSettings"
        static let hydrationLogs = "hydrationLogs"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    func saveUserProfile(_ profile: UserProfile) {
        saveCodable(profile, forKey: Keys.userProfile)
    }
    
    func loadUserProfile() -> UserProfile? {
        loadCodable(forKey: Keys.userProfile)
    }
    
    func saveSettings(_ settings: HydrationSettings) {
        saveCodable(settings, forKey: Keys.hydrationSettings)
    }
    
    func loadSettings() -> HydrationSettings? {
        loadCodable(forKey: Keys.hydrationSettings)
    }
    
    func saveLogs(_ logs: [HydrationDayLog]) {
        saveCodable(logs, forKey: Keys.hydrationLogs)
    }
    
    func loadLogs() -> [HydrationDayLog]? {
        loadCodable(forKey: Keys.hydrationLogs)
    }
    
    func setOnboardingCompleted(_ completed: Bool) {
        userDefaults.set(completed, forKey: Keys.hasCompletedOnboarding)
    }
    
    func isOnboardingCompleted() -> Bool {
        userDefaults.bool(forKey: Keys.hasCompletedOnboarding)
    }
    
    // MARK: - Generic helpers
    
    private func saveCodable<T: Codable>(_ value: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(value) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    private func loadCodable<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
