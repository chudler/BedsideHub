//
//  SettingsManager.swift
//  Bedside Hub
//
//  Created by Colin Hudler on 2/3/24.
//

import Foundation
import Combine

class SettingsManager : ObservableObject{
    static let intervalsInSeconds: [Double] = [3, 30, 60, // Seconds
                                              300, 600, 900, 1800, // Minutes
                                              3600, 7200,  // Hours
                                              43200, 86400, 172800, 259200] // Days
    static let sleepTimerIntervals: [Double] = [60, // Seconds
                                              120, 300, 600, 720, 900, 1800, // Minutes
                                              3600, 7200,  // Hours
                                              43200, 86400] // Days

    init() {
        self.weatherInterval = UserDefaults.standard.double(forKey: "weatherInterval")
        self.lullabyInterval = UserDefaults.standard.double(forKey: "lullabyInterval")
        self.imageRotationInterval = UserDefaults.standard.double(forKey: "imageRotationInterval")
        UserDefaults.standard.register(defaults: [
            "sleepTimer": false,
            "secondsEnabled": false,
            "weatherInterval" : 3600,
            "lullabyInterval" : 60,
            "scaleFactor": 300,
            "imageRotationInterval" :3,
            "brightness": 29,
            "imageAutoRotateEnabled": true,
            "selectedTheme": "System Default (all)",
            "selectedSoundCategory" : "System Default (all)"
        ])
        self.sleepTimer = UserDefaults.standard.bool(forKey: "sleepTimer")
        self.imageRotationInterval = UserDefaults.standard.double(forKey: "imageRotationInterval")
        self.secondsEnabled = UserDefaults.standard.bool(forKey: "secondsEnabled")
        self.brightness = UserDefaults.standard.double(forKey: "brightness")
        self.secondsEnabled = UserDefaults.standard.bool(forKey: "secondsEnabled")
        self.imageAutoRotateEnabled = UserDefaults.standard.bool(forKey: "imageAutoRotateEnabled")
        self.selectedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? "System Default (all)"
        self.selectedSoundCategory = UserDefaults.standard.string(forKey: "selectedSoundCategory") ?? "System Default (all)"
        self.scaleFactor = UserDefaults.standard.double(forKey: "scaleFactor")

        self.clockInterval = 60
        if self.secondsEnabled {
            self.clockInterval = 1
        }
        if self.weatherInterval == 0 { self.weatherInterval = 3600 }
        if self.lullabyInterval == 0 { self.lullabyInterval = 60 }
        if self.imageRotationInterval == 0 { self.imageRotationInterval = 3 }
        if self.brightness < 1 { self.brightness = 30 }
    }
    
    @Published var sleepTimer: Bool {
        didSet {
            UserDefaults.standard.set(sleepTimer, forKey: "sleepTimer")
        }
    }

    @Published var clockInterval: Double {
           didSet {
               UserDefaults.standard.set(clockInterval, forKey: "clockInterval")
           }
       }

    @Published var weatherInterval: Double {
        didSet {
            UserDefaults.standard.set(weatherInterval, forKey: "weatherInterval")
        }
    }

    @Published var imageRotationInterval: Double {
        didSet {
            UserDefaults.standard.set(imageRotationInterval, forKey: "imageRotationInterval")
        }
    }
    
    @Published var lullabyInterval: Double {
        didSet {
            UserDefaults.standard.set(lullabyInterval, forKey: "lullabyInterval")
        }
    }

    @Published var secondsEnabled: Bool {
        didSet {
            if secondsEnabled {
                self.clockInterval = 1 // update the clock more than a minute
            } else {
                self.clockInterval = 60
            }
            UserDefaults.standard.set(secondsEnabled, forKey: "secondsEnabled")
        }
    }
    
    @Published var scaleFactor: Double {
        didSet { UserDefaults.standard.set(scaleFactor, forKey: "scaleFactor") }
    }

    @Published var brightness: Double {
        didSet { UserDefaults.standard.set(brightness, forKey: "brightness") }
    }

    @Published var imageAutoRotateEnabled: Bool {
        didSet { UserDefaults.standard.set(imageAutoRotateEnabled, forKey: "imageAutoRotateEnabled") }
    }

    @Published var selectedTheme: String {
        didSet { UserDefaults.standard.set(selectedTheme, forKey: "selectedTheme") }
    }
    
    @Published var selectedSoundCategory : String {
        didSet { UserDefaults.standard.set(selectedSoundCategory, forKey: "selectedSoundCategory") }
    }
    
    // Helper function to convert seconds into a more readable format
    func intervalDescription(_ seconds: Int) -> String {
        switch seconds {
        case 0..<60:
            let label = seconds == 1 ? "sec" : "sec"
            return "\(seconds) \(label)"
        case 60..<3600:
            let minutes = seconds / 60
            let label = minutes == 1 ? "min" : "min"
            return "\(minutes) \(label)"
        case 3600..<86400:
            let hours = seconds / 3600
            let label = hours == 1 ? "hr" : "hrs"
            return "\(hours) \(label)"
        default:
            let days = seconds / 86400
            let label = days == 1 ? "day" : "days"
            return "\(days) \(label)"        }
    }

}
