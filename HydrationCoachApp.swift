//
//  HydrationCoachApp.swift
//  HydrationCoach
//
//  Created by Sreejith Menon on 11/16/25.
//

// File: HydrationCoachApp.swift

import SwiftUI

@main
struct HydrationCoachApp: App {
    @StateObject private var viewModel = HydrationViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(viewModel)
        }
    }
}
