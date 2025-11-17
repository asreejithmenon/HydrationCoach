// File: SettingsView.swift

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: HydrationViewModel
    
    @State private var localSettings: HydrationSettings = HydrationSettings.defaultSettings()
    @State private var bottleSizeText: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Units")) {
                    Picker("Weight unit", selection: $localSettings.weightUnit) {
                        ForEach(WeightUnit.allCases) { unit in
                            Text(unit.displayName).tag(unit)
                        }
                    }
                }
                
                Section(header: Text("Bottle")) {
                    TextField("Bottle size in oz (e.g. 64)", text: $bottleSizeText)
                    Text("1 glass = 8 oz. This helps translate your daily drinks into bottles.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Reminders")) {
                    Toggle("Hydration reminders", isOn: $localSettings.remindersEnabled)
                    
                    Picker("Frequency", selection: $localSettings.reminderFrequencyMinutes) {
                        Text("Every 60 minutes").tag(60)
                        Text("Every 90 minutes").tag(90)
                        Text("Every 120 minutes").tag(120)
                    }
                    .disabled(!localSettings.remindersEnabled)
                    
                    DatePicker("Wake time", selection: $localSettings.wakeTime, displayedComponents: .hourAndMinute)
                    DatePicker("Sleep time", selection: $localSettings.sleepTime, displayedComponents: .hourAndMinute)
                }
                
                Section(footer: Text("Changes take effect immediately. Notifications are local to your device and do not use any server.")) {
                    Button {
                        var updated = localSettings
                        if let value = Double(bottleSizeText), value > 0 {
                            updated.bottleSizeOz = value
                        } else {
                            updated.bottleSizeOz = nil
                        }
                        viewModel.updateSettings(updated)
                    } label: {
                        Text("Save changes")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                localSettings = viewModel.settings
                if let b = viewModel.settings.bottleSizeOz {
                    bottleSizeText = String(format: "%.0f", b)
                } else {
                    bottleSizeText = ""
                }
            }
        }
    }
}


