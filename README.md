# GitAuthManager 🔐

A modern macOS application that simplifies Git authentication management with a beautiful, native SwiftUI interface.

## Overview

GitAuthManager eliminates the complexity of managing Git credentials through command-line tools by providing an intuitive graphical interface for macOS users. Whether you're switching between multiple GitHub accounts, setting up new development environments, or managing personal access tokens, this app streamlines the entire process.

## ✨ Features

- **🎨 Native macOS Design**: Built with SwiftUI for a clean, modern interface that feels right at home on macOS
- **🔒 Secure Authentication**: Safely manage usernames, emails, and personal access tokens
- **🔑 Keychain Integration**: Leverages macOS Keychain for secure credential storage
- **🧪 Connection Testing**: Test Git connectivity before committing to authentication changes
- **📊 Real-time Status**: Monitor your current Git authentication state at a glance
- **⚙️ Advanced Settings**: Clear credentials, refresh status, and manage advanced configurations
- **📚 Built-in Help**: Integrated guidance for obtaining and using personal access tokens
- **🚀 Easy Setup**: Simplified workflow for both beginners and experienced developers

## 🛠️ Installation

### Requirements
- macOS 11.0 or later
- Git installed on your system

### Quick Install (Recommended)
1. **Download**: Go to [Releases](../../releases) and download the latest `GitAuthManager.app.zip`
2. **Extract**: Double-click the zip file to extract the app
3. **Install**: Drag `GitAuthManager.app` to your Applications folder
4. **Launch**: Open the app from Applications or Spotlight search
5. **First Run**: macOS may ask for permission - click "Open" to allow

### Alternative: Build from Source
For developers who want to build from source:

**Prerequisites:**
- macOS 10.15 or later
- Xcode Command Line Tools installed
- Git installed on your system

**Build Steps:**
1. Clone this repository: `git clone https://github.com/yourusername/GitAuthManager.git`
2. Navigate to the project directory: `cd GitAuthManager`
3. Build the application: `swift build -c release`
4. Create the app bundle: `./build.sh`
5. Run the app: `open GitAuthManager.app`

**Quick Build and Run:**
```bash
git clone https://github.com/yourusername/GitAuthManager.git
cd GitAuthManager
./build.sh --run
```

### Getting Started
1. Launch GitAuthManager
2. Go to the "Authentication" tab
3. Enter your GitHub username and email
4. [Get a personal access token](https://github.com/settings/tokens) from GitHub
5. Enter your token and click "Test Connection"
6. Click "Sign In" to save your credentials

## 🎯 Use Cases

- **Multi-Account Management**: Easily switch between different GitHub accounts
- **Development Environment Setup**: Streamline Git configuration for new machines
- **Token Management**: Securely store and manage personal access tokens
- **Team Onboarding**: Simplify Git setup for new team members
- **Troubleshooting**: Quickly diagnose and fix authentication issues

## 🔧 Technical Details

- **Framework**: SwiftUI for UI, Foundation for core logic
- **Security**: macOS Keychain Services for credential storage
- **Architecture**: MVVM pattern with ObservableObject for state management
- **Compatibility**: Native macOS application with system integration
- **Build System**: Swift Package Manager with custom build script
- **Validation**: Real-time input validation with comprehensive error handling
- **Features**: Multi-account support, connection testing, configuration export/import

## 📁 Project Structure

```
GitAuthManager/
├── Sources/
│   ├── main.swift                 # App entry point
│   ├── ContentView.swift          # Main navigation and layout
│   ├── AuthenticationView.swift   # Authentication form and token management
│   ├── StatusView.swift          # Real-time status monitoring
│   ├── SettingsView.swift        # Settings and configuration management
│   ├── HelpView.swift            # Comprehensive help system
│   ├── AuthenticationManager.swift # Core business logic and state management
│   ├── KeychainService.swift     # Secure credential storage
│   ├── GitService.swift          # Git integration and connection testing
│   └── Extensions.swift          # Utility extensions and helpers
├── Package.swift                 # Swift Package Manager configuration
├── Info.plist                   # macOS app configuration
├── build.sh                     # Build and packaging script
└── README.md                    # This file
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built for developers who want a better Git authentication experience on macOS
- Inspired by the need to simplify complex command-line Git operations

---

**Made with ❤️ for the macOS developer community**
--- 

Author: Donnell Reuben
