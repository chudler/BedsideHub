//
//  TimerManager.swift
//  Bedside Hub
//
//  Created by Colin Hudler on 2/3/24.
//

import Foundation
import Combine

class TimerManager : ObservableObject {
    private var timers: [String: AnyCancellable] = [:]
    init() {}

    func startTimer(name: String, interval: TimeInterval, onRun: @escaping () -> Void) {
        print("startTimer \(name) interval \(interval)")
        stopTimer(name: name) // Stop existing timer if anyx

        let timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
        timers[name] = timer.sink { _ in
            onRun()
        }
    }

    func stopTimer(name: String) {
        timers[name]?.cancel()
        timers.removeValue(forKey: name)
    }
}
