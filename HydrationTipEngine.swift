//
//  HydrationTipEngine.swift
//  HydrationCoach
//
//  Created by Sreejith Menon on 11/16/25.
//


// File: HydrationTipEngine.swift

import Foundation

struct HydrationTipEngine {
    
    static func tip(for log: HydrationDayLog, now: Date = Date()) -> String {
        let hour = Calendar.current.component(.hour, from: now)
        let progress = log.progress // 0.0 – 2.0
        let percent = Int(progress * 100)
        
        let timeOfDay: String
        switch hour {
        case 5..<12:
            timeOfDay = "morning"
        case 12..<18:
            timeOfDay = "afternoon"
        default:
            timeOfDay = "evening"
        }
        
        if percent < 30 {
            return lowProgressTip(timeOfDay: timeOfDay)
        } else if percent < 70 {
            return midProgressTip(timeOfDay: timeOfDay)
        } else if percent < 100 {
            return highProgressTip(timeOfDay: timeOfDay)
        } else {
            return goalReachedTip(timeOfDay: timeOfDay)
        }
    }
    
    private static func lowProgressTip(timeOfDay: String) -> String {
        switch timeOfDay {
        case "morning":
            return "Nice start! A glass of water in the morning helps wake up your brain and digestion."
        case "afternoon":
            return "You’re still early in your hydration. A drink now can fight that afternoon energy slump."
        default:
            return "You’re a bit behind today. A glass of water this evening still supports your kidneys and circulation."
        }
    }
    
    private static func midProgressTip(timeOfDay: String) -> String {
        switch timeOfDay {
        case "morning":
            return "You’re off to a solid start. Staying hydrated this morning supports focus and mood for the day."
        case "afternoon":
            return "You’re around the halfway mark. Hydration now helps maintain energy and reduces headaches."
        default:
            return "You’re making good progress. Water this evening supports recovery and healthy sleep quality."
        }
    }
    
    private static func highProgressTip(timeOfDay: String) -> String {
        switch timeOfDay {
        case "morning":
            return "Great job! You’re well above average for this morning. Keep sipping steadily through the day."
        case "afternoon":
            return "You’re closing in on your goal. Hydration supports muscle function, especially if you’re active."
        default:
            return "You’re almost there. A bit more water this evening helps your body recover and flush waste."
        }
    }
    
    private static func goalReachedTip(timeOfDay: String) -> String {
        switch timeOfDay {
        case "morning":
            return "Wow, you hit your goal early! Remember to sip slowly and listen to your thirst."
        case "afternoon":
            return "Hydration goal reached! You’re supporting your heart, kidneys, and brain—nice work."
        default:
            return "You’ve reached your goal today. Stay mindful of thirst and enjoy the benefits of steady hydration."
        }
    }
}
