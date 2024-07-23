import Combine
import SwiftUI

class RestTimer: ObservableObject {
    @Published var timeRemaining: TimeInterval
    @Published var isPaused: Bool
    private var timer: Timer?
    let initialTimeRemaining: TimeInterval

    init(timeRemaining: TimeInterval, isPaused: Bool) {
        self.timeRemaining = timeRemaining
        self.isPaused = isPaused
        self.initialTimeRemaining = timeRemaining
    }
    
    static func getDefaultRestTimer(isPaused: Bool) -> RestTimer {
        return RestTimer(timeRemaining: 60, isPaused: true)
    }
    
    func start() {
        if isPaused {
            isPaused = false
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                self?.updateTimeRemaining()
            }
        }
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        isPaused = true
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        timeRemaining = 0
        isPaused = true
    }
    
    private func updateTimeRemaining() {
        if timeRemaining == 0 {
            timer?.invalidate()
            timer = nil
        }
        timeRemaining = timeRemaining - 1
        print("time remaining: \(timeRemaining)")
    }
}
