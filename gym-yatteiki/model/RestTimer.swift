import Combine
import SwiftUI

class RestTimer: ObservableObject {
    @Published var timeRemaining: TimeInterval
    @Published var initialTimeRemaining: TimeInterval
    @Published var isPaused: Bool
    private var timer: AnyCancellable?
    private let timerPublisher = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    init(timeRemaining: TimeInterval, isPaused: Bool) {
        self.timeRemaining = timeRemaining
        self.isPaused = isPaused
        self.initialTimeRemaining = timeRemaining
    }
    
    static func getDefaultRestTimer(isPaused: Bool) -> RestTimer {
        return RestTimer(timeRemaining: 60, isPaused: true)
    }
    
    func start() {
        guard isPaused else { return }
        isPaused = false
        timer = timerPublisher.sink { [weak self] _ in
            self?.updateTimeRemaining()
        }
    }
    
    func pause() {
        guard !isPaused else { return }
        timer?.cancel()
        timer = nil
        isPaused = true
    }
    
    func reset() {
        pause()
        timeRemaining = initialTimeRemaining
    }
    
    private func updateTimeRemaining() {
        guard !isPaused else { return }
        if timeRemaining > 0 {
            timeRemaining = max(0, timeRemaining - 0.1)
        } else {
            pause()
        }
    }
    
    static func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
