// File: BadgeListView.swift

import SwiftUI

struct BadgeListView: View {
    @EnvironmentObject var viewModel: HydrationViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Your streak")) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("Current streak: \(viewModel.streakCount) day(s)")
                    }
                }
                
                Section(header: Text("Badges")) {
                    ForEach(viewModel.allBadges) { badge in
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.blue, Color.cyan],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 40, height: 40)
                                Image(systemName: "star.fill")
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(badge.name)
                                    .font(.headline)
                                Text(badge.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Streak required: \(badge.requiredStreak) days")
                                    .font(.caption)
                                    .foregroundColor(.secondary.opacity(0.8))
                            }
                            
                            Spacer()
                            
                            if viewModel.unlockedBadges.contains(where: { $0.id == badge.id }) {
                                Text("Unlocked")
                                    .font(.caption.weight(.semibold))
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(10)
                            } else {
                                Text("Locked")
                                    .font(.caption)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(Color.gray.opacity(0.15))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Badges")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

