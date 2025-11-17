// File: DashboardView.swift

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: HydrationViewModel
    
    // Last-used / preferred amount in GLASSES (not ml)
    @State private var preferredGlasses: Double = 1.0
    
    // Show custom sheet
    @State private var showCustomSheet = false
    
    // Quick add amounts in GLASSES
    private let quickGlassAmounts: [Double] = [0.5, 1.0, 2.0]
    
    // Extra custom options in GLASSES
    private let customOptions: [Double] = [0.25, 0.5, 0.75, 1.0, 1.5, 2.0, 3.0]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.cyan.opacity(0.25), Color.blue.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        headerCard
                        progressCard
                        loggingCard
                        preferredLogButton
                        tipCard
                        streakCard
                        disclaimerText
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)
                }
                
                if viewModel.showCelebration {
                    CelebrationOverlayView()
                }
            }
            .navigationTitle("Hydration Coach")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showCustomSheet) {
                customSheet
            }
            .onAppear {
                // If user already logged something today, use last entry as preferred
                if let last = viewModel.todayLog.entries.last {
                    let g = Double(last.amountMl) / HydrationDayLog.mlPerGlass
                    if g > 0 {
                        preferredGlasses = g
                    }
                }
            }
        }
    }
    
    // MARK: - Cards
    
    private var headerCard: some View {
        let goalGlasses = viewModel.todayLog.goalGlasses
        let totalGlasses = viewModel.todayLog.totalGlasses
        let percent = Int(viewModel.todayLog.progress * 100)
        
        // Bottle mapping
        let bottleLine: String? = {
            guard let bottleOz = viewModel.settings.bottleSizeOz, bottleOz > 0 else {
                return nil
            }
            let totalOz = totalGlasses * 8.0  // 1 glass = 8 oz
            let bottles = totalOz / bottleOz
            return "≈ \(formatted(bottles)) of your \(Int(bottleOz)) oz bottle"
        }()
        
        return VStack(alignment: .leading, spacing: 8) {
            Text("Today’s target")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("\(formatted(totalGlasses)) / \(formatted(goalGlasses)) glasses")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("\(percent)% of your daily goal")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let bottleLine {
                Text(bottleLine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)
    }
    
    private var progressCard: some View {
        let progress = min(viewModel.todayLog.progress, 1.0)
        let remainingGlasses = max(viewModel.todayLog.goalGlasses - viewModel.todayLog.totalGlasses, 0)
        
        return VStack(spacing: 16) {
            CircularProgressView(progress: progress)
                .frame(width: 190, height: 190)
            
            if viewModel.todayLog.isGoalReached {
                Text("Goal reached! 🎉")
                    .font(.headline)
                    .foregroundColor(.green)
            } else {
                Text("\(formatted(remainingGlasses)) glasses remaining")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)
    }
    
    /// Main logging card: big, high-contrast quick buttons + a simple "Custom" sheet
    private var loggingCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick log")
                .font(.headline)
            
            // Big, high-contrast quick buttons (0.5 / 1 / 2 glasses)
            HStack(spacing: 12) {
                ForEach(quickGlassAmounts, id: \.self) { glasses in
                    Button {
                        addGlasses(glasses)
                    } label: {
                        VStack(spacing: 6) {
                            Text("+\(formatted(glasses))")
                                .font(.headline)
                            Text("glass\(glasses == 1 ? "" : "es")")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 6)
                    }
                }
            }
            
            // Custom: very low effort – just tap once, pick from a list
            VStack(alignment: .leading, spacing: 6) {
                Text("Need a different amount?")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button {
                    showCustomSheet = true
                } label: {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                        Text("Custom amount")
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.caption)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(Color.white.opacity(0.96))
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)
    }
    
    /// Big “one-tap” button for the user’s preferred amount (last used)
    private var preferredLogButton: some View {
        Button {
            addGlasses(preferredGlasses)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("One-tap log")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    Text("Log \(formatted(preferredGlasses)) glass\(preferredGlasses == 1 ? "" : "es")")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Spacer()
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 18)
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.indigo],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(18)
            .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 8)
        }
        .padding(.horizontal, 2)
    }
    
    private var tipCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Hydration insight", systemImage: "lightbulb.fill")
                .font(.headline)
            Text(viewModel.latestTip)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)
    }
    
    private var streakCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Streak & badges", systemImage: "flame.fill")
                .font(.headline)
            
            Text("Current streak: \(viewModel.streakCount) day(s)")
                .font(.subheadline)
            
            if let topBadge = viewModel.unlockedBadges.sorted(by: { $0.requiredStreak > $1.requiredStreak }).first {
                Text("Top badge: \(topBadge.name)")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            } else {
                Text("Keep going to unlock your first badge!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)
    }
    
    private var disclaimerText: some View {
        Text("This app provides general hydration guidance only and is not medical advice. Talk to your healthcare provider for personal recommendations.")
            .font(.footnote)
            .foregroundColor(.white.opacity(0.9))
            .multilineTextAlignment(.center)
            .padding(.top, 8)
            .padding(.horizontal, 16)
    }
    
    // MARK: - Custom sheet
    
    private var customSheet: some View {
        NavigationStack {
            List {
                Section(header: Text("Choose an amount")) {
                    ForEach(customOptions, id: \.self) { glasses in
                        Button {
                            addGlasses(glasses)
                            showCustomSheet = false
                        } label: {
                            HStack {
                                Text("\(formatted(glasses)) glass\(glasses == 1 ? "" : "es")")
                                    .font(.body)
                                Spacer()
                                Text("\(Int(glasses * HydrationDayLog.mlPerGlass)) ml")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Custom amount")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        showCustomSheet = false
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func addGlasses(_ glasses: Double) {
        guard glasses > 0 else { return }
        let ml = Int(glasses * HydrationDayLog.mlPerGlass)
        viewModel.logWater(amountMl: ml)
        preferredGlasses = glasses
    }
    
    private func formatted(_ value: Double) -> String {
        if abs(value.rounded() - value) < 0.01 {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.1f", value)
        }
    }
}

