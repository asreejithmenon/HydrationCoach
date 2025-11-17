# HydrationCoach


HydrationCoach is a modern, lightweight, AI-like hydration tracking app built for iOS using SwiftUI, MVVM, local notifications, and UserDefaults persistence.
The app helps users track water intake using glasses (8oz) instead of milliliters, shows progress toward daily hydration goals, includes gamification (streaks and badges), and translates water intake into user-defined bottle sizes for easier understanding.

App Overview
HydrationCoach allows users to:


Track water intake using glasses rather than raw ml.


Log water quickly using large, easy-to-tap buttons.


Customize bottle size (e.g., 64 oz) and see “X bottles per day” equivalents.


Set reminders using local notifications.


View streaks, badges, and hydration insights.


Save all data locally into persistence.


Experience a modern, clean, gradient UI with material cards.


The app does not use external dependencies or servers.

🧱 Tech Stack


iOS 16+


Xcode 16


Swift 5 / SwiftUI


MVVM architecture


UserDefaults for persistence


UNUserNotificationCenter for reminders


Combine for reactive updates


No third-party packages.

🏛 Project Architecture
HydrationCoach/
│
├── Models/
│   ├── UserProfile.swift
│   ├── HydrationSettings.swift
│   ├── HydrationDayLog.swift
│   ├── HydrationEntry.swift
│   ├── HydrationGoalCalculator.swift
│   ├── HydrationTipEngine.swift
│   ├── GamificationEngine.swift
│
├── ViewModels/
│   └── HydrationViewModel.swift
│
├── Services/
│   ├── PersistenceManager.swift
│   ├── NotificationManager.swift
│
├── Views/
│   ├── DashboardView.swift
│   ├── SetupView.swift
│   ├── SettingsView.swift
│   ├── HistoryView.swift
│   ├── BadgeListView.swift
│   ├── CircularProgressView.swift
│   ├── CelebrationOverlayView.swift
│   ├── MainTabView.swift
│
├── Assets.xcassets/
│   └── AppIcon.appiconset
│
└── HydrationCoachApp.swift


🧩 Core Concepts Explained
1. Hydration Unit System
Internally, the app tracks total hydration in milliliters.
However, the UI uses:


Glasses → 1 glass = 8 oz = 240 ml


User-defined Bottle (optional) → e.g., 64 oz bottle


Formula:
glasses = totalIntakeMl / 240
bottles = (glasses * 8oz) / userBottleSize

If the user does not set a bottle size, bottle mapping is hidden.

2. Daily Goal Engine
Daily water goal is calculated based on:


Weight


Activity level


Age


Gender


Weight units (kg/lbs)


Goal is stored in dailyGoalMl inside HydrationSettings.
Every new day automatically:


Creates a new HydrationDayLog


Saves yesterday's log to history


Recomputes streaks and badges



3. Logging System
Each log event is stored as:
HydrationEntry(amountMl: Int, timestamp: Date)

When a user logs glasses:
ml = glasses * 240
todayLog.adding(amountMl)

User can log using three methods:
✔ Quick-log buttons
Large +0.5, +1.0, +2.0 glass buttons
Optimized for thumb reach and low cognitive load.
✔ One-tap preferred log


Remembers last log amount (e.g., always logs 1 glass)


Encourages habit formation


✔ Custom amount sheet
User selects from a list (0.25–3 glasses).
No typing needed.

4. Gamification
Streak rules:


Day counts if user reaches ≥80% of the hydration goal.


Streak increments only if consecutive days meet threshold.


Badges include:


Hydration Rookie – 3 days


Consistency Champ – 7 days


Hydration Hero – 30 days


Gamification is stateless and computed dynamically from logs.

5. Hydration Insight Engine (AI-like tips)
The rule-based tips depend on:


How far user is from daily goal


Time of day


Whether user is behind schedule


Whether user is almost done


Examples:


“Hydrating now supports kidney function.”


“You’re halfway there — keep it steady!”


“Nice! You’re ahead of pace today.”


No API calls. No machine learning. Pure deterministic rules for reproducibility.

6. Reminder Engine
Uses UNUserNotificationCenter.
User can configure:


Reminder frequency (60/90/120 minutes)


Wake time


Sleep time


On/off toggle


When enabled:


App schedules notifications across the user's awake window.


Each notification includes progress text (if allowed).



🎨 UI/UX Design System
Visual Style:


Gradient backgrounds (cyan → blue → indigo)


Ultra-thin material cards


Rounded corners (16–20px)


Subtle shadows


Large-text emphasis on hydration data


High contrast quick-buttons


Modern neon app icon


Interaction Design:


“Low cognitive load” principle


Large, thumb-friendly targets


Minimal typing required


“Quick log” and “One-tap log”


Sheet-based custom logging


Clear progress indicators


Encouraging, friendly language



🕹 Main Screens
Dashboard


Today’s progress


Glasses and bottles view


Progress ring


Quick-log buttons


One-tap logging


Hydration insights


Streak summary


History


Last 30 days


Glasses + ml + % goal achieved


Bottle equivalents if bottle size set


Settings


Units


Bottle size


Reminders


Wake/sleep times


Badges


Shows unlocked and locked badges


Users can see streak requirements


Onboarding


Weight, age, gender


Activity level


Sleep/wake time


Bottle size (optional)



📦 Data Persistence
Stored using UserDefaults with Codable wrappers:


UserProfile


HydrationSettings


Array<HydrationDayLog>


Persistence Manager ensures:


No duplicate days


Logs capped to last 30 days


Safe decoding and fallback defaults



🔄 Daily Auto-Rollover Logic
At app launch or foreground:


Compare today’s date to todayLog.date


If a new day:


Move old log to history


Create new log with updated goal


Recompute streaks and badges




This prevents streak-breaking due to app inactivity.

🧪 Version History
MVP 1.0


Hydration goal calculation


Daily logging in ml


Local notifications


Basic streaks & history


MVP 1.1


UI modernization


Full switch from ml → glasses (8oz)


Gradient UI & card layout


MVP 1.2


Low-tap logging improvements


Large quick-log buttons


Sheet-based custom logging


One-tap preferred log button


MVP 1.3


App icon added (neon pro look)


AppIcon.appiconset support


MVP 1.4


Bottle size mapping:


User enters bottle size (e.g., 64 oz)


Dashboard shows “≈ X bottles”


Glasses → bottle ratio applied throughout UI





🧭 Where Future Features Should Be Added
1. Analytics / Trends
(HistoryView or new TrendsView)
2. Multiple bottle presets
Extend HydrationSettings.
3. Widget support
Add WidgetKit folder.
4. Apple Health Integration
New service: HealthKitManager.
5. Undo last log
Add in HydrationViewModel.logWater().
6. Smart reminders / ML
Add new file: SmartReminderEngine.swift.

🚀 How to Run


Open the project in Xcode 16.


Set iOS Deployment Target: 16.0+


Ensure signing with your Apple ID.


Select your iPhone → Run (⌘R).


Enable notifications when prompted.



🔐 Security
No analytics, no servers, no remote APIs.
All data stays on-device.

🤝 Contributing
Commit guidelines:


One feature per commit


Use commit messages like:
MVP 1.4 – Added bottle size mapping and UI updates




📄 License
Private project for personal use.

