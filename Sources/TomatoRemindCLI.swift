import Foundation

/// Command-line interface for the Tomato Reminder app
final class TomatoRemindCLI: @unchecked Sendable {
    private let timer: TomatoTimer
    private var isRunning = true
    
    init(demoMode: Bool = false) {
        timer = TomatoTimer(demoMode: demoMode)
    }
    
    func run() {
        print("🍅 Welcome to Mac Tomato Reminder!")
        print("This app helps you focus with random reminders and break periods.")
        print("")
        printInstructions()
        print("Type a command:")
        
        // Handle user input in the main loop
        while isRunning {
            print("> ", terminator: "")
            if let input = readLine() {
                processCommand(input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
    
    private func printInstructions() {
        print("Instructions:")
        print("- Type 'start' to begin a 90-minute focus session")
        print("- Random reminders will play every 3-5 minutes")
        print("- When you hear a reminder, close your eyes for 10 seconds")
        print("- After 90 minutes, take a 20-minute break")
        print("- Type 'stop' to end current session")
        print("- Type 'skip' to skip current rest period")
        print("- Type 'status' to see current status")
        print("- Type 'demo' to run demo mode with shorter timers")
        print("- Type 'quit' to exit")
        print("- Type 'help' to see these instructions again")
        print("")
    }
    
    private func processCommand(_ command: String) {
        switch command {
        case "start":
            if timer.currentPhase == .idle {
                timer.startFocusSession()
                print("✅ Focus session started! You'll get random reminders every 3-5 minutes.")
            } else {
                print("⚠️  Session already in progress. Type 'stop' to end current session.")
            }
            
        case "stop":
            if timer.isRunning || timer.currentPhase != .idle {
                timer.stopSession()
                print("🛑 Session stopped.")
            } else {
                print("ℹ️  No active session to stop.")
            }
            
        case "skip":
            if timer.currentPhase == .resting {
                timer.skipRest()
                print("⏭️ Rest period skipped.")
            } else {
                print("ℹ️  Can only skip during rest periods.")
            }
            
        case "status":
            let phase: String
            let timeDisplay: String
            
            switch timer.currentPhase {
            case .idle:
                phase = "🟢 Ready"
                timeDisplay = "Type 'start' to begin"
            case .focusing:
                phase = "🍅 Focusing"
                timeDisplay = "Time left: \(timer.formatTime(timer.timeRemaining))"
            case .resting:
                phase = "👀 Rest (close eyes)"
                timeDisplay = "Rest time: \(timer.formatTime(timer.timeRemaining))"
            case .breaking:
                phase = "☕ Break Time"
                timeDisplay = "Break time left: \(timer.formatTime(timer.timeRemaining))"
            }
            
            print("Current Status: \(phase) | \(timeDisplay)")
            if timer.currentPhase == .focusing && timer.reminderTimeRemaining > 0 {
                print("Next reminder in: \(timer.formatTime(timer.reminderTimeRemaining))")
            }
            
        case "help":
            printInstructions()
            
        case "quit", "exit", "q":
            print("👋 Goodbye! Stay focused!")
            timer.stopSession()
            isRunning = false
            
        case "":
            // Empty input, ignore
            break
            
        default:
            print("❓ Unknown command: '\(command)'. Type 'help' for available commands.")
        }
    }
}