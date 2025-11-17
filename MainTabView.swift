// File: MainTabView.swift

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Today", systemImage: "drop.fill")
                }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "chart.bar.fill")
                }
            
            BadgeListView()
                .tabItem {
                    Label("Badges", systemImage: "star.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(.cyan)
    }
}
