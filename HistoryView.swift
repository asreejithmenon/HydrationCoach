// File: HistoryView.swift

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: HydrationViewModel
    
    private var allLogs: [HydrationDayLog] {
        var logs = viewModel.recentLogs
        logs.append(viewModel.todayLog)
        return logs.sorted { $0.startOfDay() < $1.startOfDay() }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(allLogs) { log in
                    historyRow(for: log)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(
                LinearGradient(
                    colors: [Color.cyan.opacity(0.2), Color.blue.opacity(0.5)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationTitle("History")
        }
    }
    
    private func historyRow(for log: HydrationDayLog) -> some View {
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: log.date)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        let label = formatter.string(from: date)
        let percentage = Int(log.progress * 100)
        let glasses = log.totalGlasses
        
        return HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("\(String(format: "%.1f", glasses)) glasses (\(percentage)%)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(log.totalIntakeMl) ml / \(log.goalMl) ml")
                    .font(.caption)
                    .foregroundColor(.secondary.opacity(0.8))
            }
            
            Spacer()
            
            GeometryReader { geometry in
                let maxWidth = geometry.size.width
                let barWidth = maxWidth * min(CGFloat(log.progress), 1.0)
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(height: 8)
                        .foregroundColor(Color.white.opacity(0.3))
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: barWidth, height: 8)
                        .foregroundColor(log.reached80Percent ? .green : .blue)
                }
            }
            .frame(width: 120, height: 16)
        }
        .padding(10)
        .background(.ultraThinMaterial)
        .cornerRadius(14)
    }
}

