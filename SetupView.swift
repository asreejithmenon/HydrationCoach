// File: SetupView.swift

import SwiftUI

struct SetupView: View {
    @EnvironmentObject var viewModel: HydrationViewModel
    
    @State private var age: String = ""
    @State private var selectedGender: Gender = .other
    @State private var weight: String = ""
    @State private var selectedUnit: WeightUnit = .kg
    @State private var height: String = ""
    @State private var selectedActivity: ActivityLevel = .moderate
    @State private var wakeTime: Date = Date()
    @State private var sleepTime: Date = Date()
    
    @State private var bottleSize: String = ""   // in ounces
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("About you")) {
                    TextField("Age (years)", text: $age)
                    
                    Picker("Gender", selection: $selectedGender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.displayName).tag(gender)
                        }
                    }
                    
                    TextField("Weight", text: $weight)
                    
                    Picker("Unit", selection: $selectedUnit) {
                        ForEach(WeightUnit.allCases) { unit in
                            Text(unit.displayName).tag(unit)
                        }
                    }
                    
                    TextField("Height (cm, optional)", text: $height)
                    
                    Picker("Activity level", selection: $selectedActivity) {
                        ForEach(ActivityLevel.allCases) { level in
                            Text(level.displayName).tag(level)
                        }
                    }
                }
                
                Section(header: Text("Daily schedule")) {
                    DatePicker("Wake time", selection: $wakeTime, displayedComponents: .hourAndMinute)
                    DatePicker("Sleep time", selection: $sleepTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Bottle (optional)")) {
                    TextField("Bottle size in oz (e.g. 64)", text: $bottleSize)
                    Text("If set, glasses (8 oz) will be translated into how many bottles you’ve finished.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Section(footer: Text("Your hydration goal is a general wellness guideline only and not medical advice. For medical questions, talk to your healthcare provider.")) {
                    Button(action: completeSetup) {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Welcome")
            .onAppear(perform: loadDefaultsFromViewModel)
            .alert("Check your details", isPresented: $showAlert, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text(alertMessage)
            })
        }
    }
    
    private func loadDefaultsFromViewModel() {
        let profile = viewModel.userProfile
        let settings = viewModel.settings
        
        age = profile.age > 0 ? String(profile.age) : ""
        selectedGender = profile.gender
        weight = profile.weight > 0 ? String(format: "%.0f", profile.weight) : ""
        selectedUnit = settings.weightUnit
        if let h = profile.heightCm {
            height = String(format: "%.0f", h)
        }
        selectedActivity = profile.activityLevel
        wakeTime = settings.wakeTime
        sleepTime = settings.sleepTime
        
        if let b = settings.bottleSizeOz {
            bottleSize = String(format: "%.0f", b)
        }
    }
    
    private func completeSetup() {
        guard let ageValue = Int(age), ageValue > 0 else {
            alertMessage = "Please enter a valid age."
            showAlert = true
            return
        }
        
        guard let weightValue = Double(weight), weightValue > 0 else {
            alertMessage = "Please enter a valid weight."
            showAlert = true
            return
        }
        
        let heightValue = Double(height)
        let bottleValue = Double(bottleSize)
        
        let profile = UserProfile(
            age: ageValue,
            gender: selectedGender,
            weight: weightValue,
            heightCm: heightValue,
            activityLevel: selectedActivity
        )
        
        let settings = HydrationSettings(
            weightUnit: selectedUnit,
            dailyGoalMl: 0, // will be calculated in ViewModel
            remindersEnabled: false,
            reminderFrequencyMinutes: 120,
            wakeTime: wakeTime,
            sleepTime: sleepTime,
            bottleSizeOz: (bottleValue ?? 0) > 0 ? bottleValue : nil
        )
        
        viewModel.completeOnboarding(profile: profile, settings: settings)
    }
}

