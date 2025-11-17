// File: RootView.swift

import SwiftUI

struct RootView: View {
    @EnvironmentObject var viewModel: HydrationViewModel
    
    var body: some View {
        Group {
            if viewModel.hasCompletedOnboarding {
                MainTabView()
            } else {
                SetupView()
            }
        }
    }
}
