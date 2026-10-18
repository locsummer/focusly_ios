import Foundation
import Combine
import SwiftUI

@MainActor
public final class FocusTimerViewModel: ObservableObject {
    @Published public var currentSessionType: FocusSessionType = .pomodoro
    @Published public var remainingSeconds: Int = 25 * 60
    @Published public var totalSeconds: Int = 25 * 60
    @Published public var isRunning: Bool = false
    @Published public var isPaused: Bool = false
    @Published public var completedSessionsCount: Int = 0
    @Published public var strictModeEnabled: Bool = true
    
    private var timer: AnyCancellable?
    private let preferences = UserPreferences.shared
    private let shieldManager = ShieldManager.shared
    
    public init() {
        resetTimer()
    }
    
    public func selectSessionType(_ type: FocusSessionType) {
        currentSessionType = type
        totalSeconds = type.defaultMinutes * 60
        remainingSeconds = totalSeconds
        if isRunning {
            stopTimer()
        }
    }
    
    public func startTimer() {
        guard !isRunning else { return }
        isRunning = true
        isPaused = false
        
        // If strict mode, shield distracting apps immediately
        if strictModeEnabled {
            let selection = preferences.loadShieldSelection()
            shieldManager.shield(selection: selection)
            preferences.isFocusActive = true
        }
        
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                } else {
                    self.timerCompleted()
                }
            }
    }
    
    public func pauseTimer() {
        guard isRunning else { return }
        isRunning = false
        isPaused = true
        timer?.cancel()
    }
    
    public func resumeTimer() {
        startTimer()
    }
    
    public func stopTimer() {
        isRunning = false
        isPaused = false
        timer?.cancel()
        resetTimer()
        
        if strictModeEnabled {
            shieldManager.unshieldAll()
            preferences.isFocusActive = false
        }
    }
    
    private func resetTimer() {
        totalSeconds = currentSessionType.defaultMinutes * 60
        remainingSeconds = totalSeconds
    }
    
    private func timerCompleted() {
        stopTimer()
        completedSessionsCount += 1
        
        let session = FocusSession(
            sessionType: currentSessionType,
            durationMinutes: totalSeconds / 60,
            startTime: Date().addingTimeInterval(-Double(totalSeconds)),
            endTime: Date(),
            isCompleted: true
        )
        
        var sessions = preferences.loadFocusSessions()
        sessions.append(session)
        preferences.saveFocusSessions(sessions)
    }
    
    public var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    public var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return 1.0 - (Double(remainingSeconds) / Double(totalSeconds))
    }
}
