import Foundation
#if canImport(AVFoundation)
import AVFoundation
#endif
#if canImport(AudioToolbox)
import AudioToolbox
#endif

/// Core timer class that handles the tomato reminder functionality
final class TomatoTimer: @unchecked Sendable {
    
    // MARK: - Properties
    var isRunning = false
    var currentPhase: TimerPhase = .idle
    var timeRemaining: TimeInterval = 0
    var reminderTimeRemaining: TimeInterval = 0
    
    private var focusTimer: Timer?
    private var reminderTimer: Timer?
    private var breakTimer: Timer?
    private var restTimer: Timer?
    
    #if canImport(AVFoundation)
    private var audioPlayer: AVAudioPlayer?
    #endif
    
    // MARK: - Constants
    private let focusDuration: TimeInterval
    private let breakDuration: TimeInterval 
    private let restDuration: TimeInterval = 10 // 10 seconds
    private let reminderMinInterval: TimeInterval
    private let reminderMaxInterval: TimeInterval
    
    init(demoMode: Bool = false) {
        if demoMode {
            // Shorter durations for testing
            focusDuration = 30 // 30 seconds
            breakDuration = 15 // 15 seconds
            reminderMinInterval = 5 // 5 seconds
            reminderMaxInterval = 10 // 10 seconds
        } else {
            // Production durations
            focusDuration = 90 * 60 // 90 minutes
            breakDuration = 20 * 60 // 20 minutes
            reminderMinInterval = 3 * 60 // 3 minutes
            reminderMaxInterval = 5 * 60 // 5 minutes
        }
    }
    
    // MARK: - Timer Phases
    enum TimerPhase {
        case idle
        case focusing
        case resting
        case breaking
    }
    
    // MARK: - Public Methods
    
    /// Start a new focus session
    func startFocusSession() {
        guard !isRunning else { return }
        
        currentPhase = .focusing
        timeRemaining = focusDuration
        isRunning = true
        
        startFocusTimer()
        scheduleRandomReminder()
        
        print("🍅 Focus session started! Duration: \(Int(focusDuration/60)) minutes")
    }
    
    /// Stop the current session
    func stopSession() {
        invalidateAllTimers()
        currentPhase = .idle
        isRunning = false
        timeRemaining = 0
        reminderTimeRemaining = 0
        
        print("⏹️ Session stopped")
    }
    
    /// Skip current rest period
    func skipRest() {
        guard currentPhase == .resting else { return }
        
        restTimer?.invalidate()
        currentPhase = .focusing
        scheduleRandomReminder()
        
        print("⏭️ Rest skipped, back to focusing")
    }
    
    // MARK: - Private Methods
    
    private func startFocusTimer() {
        focusTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateFocusTimer()
        }
    }
    
    private func updateFocusTimer() {
        guard timeRemaining > 0 else {
            focusTimer?.invalidate()
            startBreak()
            return
        }
        
        timeRemaining -= 1
    }
    
    private func scheduleRandomReminder() {
        reminderTimer?.invalidate()
        
        let randomInterval = TimeInterval.random(in: reminderMinInterval...reminderMaxInterval)
        reminderTimeRemaining = randomInterval
        
        reminderTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateReminderTimer()
        }
        
        print("🔔 Next reminder scheduled in \(Int(randomInterval/60)):\(String(format: "%02d", Int(randomInterval.truncatingRemainder(dividingBy: 60))))")
    }
    
    private func updateReminderTimer() {
        guard reminderTimeRemaining > 0 else {
            reminderTimer?.invalidate()
            playReminderSound()
            return
        }
        
        reminderTimeRemaining -= 1
    }
    
    private func playReminderSound() {
        guard currentPhase == .focusing else { return }
        
        print("🔔 REMINDER! Close your eyes and rest for 10 seconds...")
        
        // Play system sound as we don't have custom audio files
        playSystemSound()
        
        // Start the 10-second rest period
        startRestPeriod()
    }
    
    private func startRestPeriod() {
        currentPhase = .resting
        timeRemaining = restDuration
        
        restTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateRestTimer()
        }
    }
    
    private func updateRestTimer() {
        guard timeRemaining > 0 else {
            restTimer?.invalidate()
            currentPhase = .focusing
            scheduleRandomReminder()
            print("👀 Rest period complete, continue focusing!")
            return
        }
        
        timeRemaining -= 1
    }
    
    private func startBreak() {
        invalidateAllTimers()
        currentPhase = .breaking
        timeRemaining = breakDuration
        isRunning = false
        
        print("☕ 90-minute focus session complete! Take a 20-minute break.")
        playSystemSound() // Play sound to indicate break time
        
        breakTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateBreakTimer()
        }
    }
    
    private func updateBreakTimer() {
        guard timeRemaining > 0 else {
            breakTimer?.invalidate()
            currentPhase = .idle
            print("🍅 Break complete! Ready for another focus session.")
            playSystemSound() // Play sound to indicate break is over
            return
        }
        
        timeRemaining -= 1
    }
    
    private func playSystemSound() {
        #if canImport(AudioToolbox)
        // Use AudioServicesPlaySystemSound for a simple beep
        AudioServicesPlaySystemSound(SystemSoundID(1000)) // System sound
        #else
        // Fallback for systems without AudioToolbox
        print("🔊 *BEEP*")
        #endif
    }
    
    private func invalidateAllTimers() {
        focusTimer?.invalidate()
        reminderTimer?.invalidate()
        breakTimer?.invalidate()
        restTimer?.invalidate()
    }
    
    // MARK: - Utility Methods
    
    func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}