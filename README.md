# Mac Tomato Reminder

A productivity app for macOS that helps you maintain focus using customizable reminder intervals and break periods.

## Features

🍅 **Focus Sessions**: 90-minute focused work periods  
🔔 **Random Reminders**: Audio alerts every 3-5 minutes during focus sessions  
👀 **Rest Periods**: 10-second eye rest breaks when reminders play  
☕ **Break Management**: Automatic 20-minute breaks after each focus session  
🔄 **Continuous Cycles**: Automatic cycling between focus and break periods  

## Requirements

- macOS 10.15 or later
- Xcode 16.2 or later (for development)
- Swift 6.1 or later

## Installation

### Option 1: Build with Swift Package Manager (Command Line)

1. Clone the repository:
```bash
git clone https://github.com/blue7zz/Mac-tomato-remind.git
cd Mac-tomato-remind
```

2. Build the project:
```bash
swift build
```

3. Run the application:
```bash
swift run
```

### Option 2: Open in Xcode

1. Clone the repository
2. Open `Package.swift` in Xcode 16.2+
3. Build and run the project (⌘+R)

## Usage

### Commands

- `start` - Begin a 90-minute focus session
- `stop` - End the current session
- `skip` - Skip the current rest period (only during 10-second breaks)
- `status` - Show current session status and remaining time
- `demo` - Run demo mode with shorter timers for testing
- `help` - Show available commands
- `quit` - Exit the application

### How it Works

1. **Start a Focus Session**: Type `start` to begin a 90-minute focus period
2. **Random Reminders**: The app will play a sound at random intervals (3-5 minutes)
3. **Take Rest Breaks**: When you hear the sound, close your eyes for 10 seconds
4. **Continue Focusing**: After the rest period, continue your work
5. **Automatic Breaks**: After 90 minutes, take a 20-minute break
6. **Repeat**: Start another focus session when ready

### Demo Mode

For testing purposes, use `demo` command to run with shorter timers:
- Focus session: 30 seconds
- Break period: 15 seconds  
- Random reminders: 5-10 seconds

## Development

### Project Structure

```
Sources/
├── main.swift           # Application entry point
├── TomatoTimer.swift    # Core timer logic and state management
└── TomatoRemindCLI.swift # Command-line interface

Package.swift            # Swift Package Manager configuration
README.md               # This file
```

### Building for Xcode

To create an Xcode project:

1. Open Xcode
2. File → Open → Select `Package.swift`
3. Xcode will automatically generate the project structure

### Architecture

- **TomatoTimer**: Core business logic for managing focus sessions, reminders, and breaks
- **TomatoRemindCLI**: User interface layer handling command input and display
- **Timer Management**: Uses Foundation Timer for precise timing
- **Audio Feedback**: System sound alerts for reminders and phase transitions

## Customization

You can modify the timer durations by editing the constants in `TomatoTimer.swift`:

```swift
// Production durations
focusDuration = 90 * 60     // 90 minutes
breakDuration = 20 * 60     // 20 minutes  
reminderMinInterval = 3 * 60 // 3 minutes
reminderMaxInterval = 5 * 60 // 5 minutes
restDuration = 10           // 10 seconds
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is available under the MIT License.

## Productivity Method

This app implements a variation of the Pomodoro Technique with:
- **Longer focus periods** (90 minutes vs traditional 25 minutes)
- **Random reminder intervals** (prevents anticipation and maintains surprise)
- **Brief rest periods** (eye rest without breaking flow)
- **Longer breaks** (20 minutes for better recovery)

The random reminders help maintain awareness of your physical state without disrupting deep focus, while the longer sessions allow for more substantial work periods.
