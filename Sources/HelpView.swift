import SwiftUI

struct HelpView: View {
    @State private var selectedTopic: HelpTopic = .gettingStarted
    
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar
            VStack(alignment: .leading, spacing: 0) {
                Text("Help Topics")
                    .font(.headline)
                    .padding()
                
                List(HelpTopic.allCases, id: \.self, selection: $selectedTopic) { topic in
                    HStack {
                        Image(systemName: topic.icon)
                            .foregroundColor(.blue)
                            .frame(width: 20)
                        Text(topic.title)
                            .font(.subheadline)
                    }
                    .padding(.vertical, 2)
                }
                .listStyle(SidebarListStyle())
            }
            .frame(width: 200)
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HelpContent(topic: selectedTopic)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct HelpContent: View {
    let topic: HelpTopic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: topic.icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                Text(topic.title)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            switch topic {
            case .gettingStarted:
                GettingStartedContent()
            case .tokenManagement:
                TokenManagementContent()
            case .troubleshooting:
                TroubleshootingContent()
            case .advancedUsage:
                AdvancedUsageContent()
            case .faq:
                FAQContent()
            }
        }
    }
}

struct GettingStartedContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Welcome to GitAuthManager! This guide will help you get started with managing your Git authentication.")
                .font(.body)
            
            HelpSection(title: "Quick Start") {
                VStack(alignment: .leading, spacing: 8) {
                    HelpStep(number: 1, text: "Go to the Authentication tab")
                    HelpStep(number: 2, text: "Enter your GitHub username and email")
                    HelpStep(number: 3, text: "Get a personal access token from GitHub")
                    HelpStep(number: 4, text: "Test your connection and sign in")
                }
            }
            
            HelpSection(title: "What is GitAuthManager?") {
                Text("GitAuthManager is a macOS application that simplifies the process of managing Git credentials. Instead of using command-line tools, you can manage your authentication through a beautiful, intuitive interface.")
            }
            
            HelpSection(title: "Why use GitAuthManager?") {
                VStack(alignment: .leading, spacing: 8) {
                    HelpFeature(text: "Secure storage using macOS Keychain")
                    HelpFeature(text: "Easy switching between multiple accounts")
                    HelpFeature(text: "Real-time connection testing")
                    HelpFeature(text: "Native macOS design and feel")
                }
            }
        }
    }
}

struct TokenManagementContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Personal Access Tokens are the secure way to authenticate with GitHub. Here's everything you need to know about managing them.")
                .font(.body)
            
            HelpSection(title: "Creating a Personal Access Token") {
                VStack(alignment: .leading, spacing: 8) {
                    HelpStep(number: 1, text: "Go to GitHub.com and sign in to your account")
                    HelpStep(number: 2, text: "Click your profile picture → Settings")
                    HelpStep(number: 3, text: "In the left sidebar, click 'Developer settings'")
                    HelpStep(number: 4, text: "Click 'Personal access tokens' → 'Tokens (classic)'")
                    HelpStep(number: 5, text: "Click 'Generate new token' → 'Generate new token (classic)'")
                    HelpStep(number: 6, text: "Give your token a descriptive name")
                    HelpStep(number: 7, text: "Select the 'repo' scope for full repository access")
                    HelpStep(number: 8, text: "Click 'Generate token' and copy it immediately")
                }
            }
            
            HelpSection(title: "Token Security") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Important security considerations:")
                        .font(.headline)
                    HelpFeature(text: "Never share your token with anyone")
                    HelpFeature(text: "Don't commit tokens to version control")
                    HelpFeature(text: "Use different tokens for different purposes")
                    HelpFeature(text: "Regularly rotate your tokens")
                    HelpFeature(text: "Revoke unused tokens")
                }
            }
            
            HelpSection(title: "Token Scopes") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Common scopes you might need:")
                        .font(.headline)
                    HelpFeature(text: "repo - Full access to repositories")
                    HelpFeature(text: "workflow - Update GitHub Action workflows")
                    HelpFeature(text: "write:packages - Upload packages to GitHub Package Registry")
                    HelpFeature(text: "delete:packages - Delete packages from GitHub Package Registry")
                }
            }
        }
    }
}

struct TroubleshootingContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Having trouble with GitAuthManager? Here are solutions to common problems.")
                .font(.body)
            
            HelpSection(title: "Connection Test Fails") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("If your connection test fails, try these steps:")
                        .font(.headline)
                    HelpFeature(text: "Verify your username and email are correct")
                    HelpFeature(text: "Check that your token has the correct scopes")
                    HelpFeature(text: "Ensure your token hasn't expired")
                    HelpFeature(text: "Try generating a new token")
                    HelpFeature(text: "Check your internet connection")
                }
            }
            
            HelpSection(title: "Git Commands Not Working") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("If Git commands fail after configuration:")
                        .font(.headline)
                    HelpFeature(text: "Make sure Git is installed on your system")
                    HelpFeature(text: "Check that Git is in your PATH")
                    HelpFeature(text: "Try running 'git config --list' to verify settings")
                    HelpFeature(text: "Restart your terminal after configuration")
                }
            }
            
            HelpSection(title: "Credentials Not Saving") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("If credentials aren't being saved:")
                        .font(.headline)
                    HelpFeature(text: "Check that you have permission to access Keychain")
                    HelpFeature(text: "Try signing out and signing back in")
                    HelpFeature(text: "Restart the application")
                    HelpFeature(text: "Check macOS Keychain Access app for entries")
                }
            }
        }
    }
}

struct AdvancedUsageContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Learn about advanced features and customization options in GitAuthManager.")
                .font(.body)
            
            HelpSection(title: "Multiple Accounts") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Managing multiple GitHub accounts:")
                        .font(.headline)
                    HelpFeature(text: "Use different tokens for different accounts")
                    HelpFeature(text: "Switch between accounts by updating credentials")
                    HelpFeature(text: "Use Git's conditional includes for different repositories")
                    HelpFeature(text: "Consider using SSH keys for better security")
                }
            }
            
            HelpSection(title: "Configuration Export/Import") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Backup and restore your settings:")
                        .font(.headline)
                    HelpFeature(text: "Export configuration to save your current settings")
                    HelpFeature(text: "Import configuration to restore settings on a new machine")
                    HelpFeature(text: "Configuration files are stored in JSON format")
                    HelpFeature(text: "Tokens are never exported for security reasons")
                }
            }
            
            HelpSection(title: "Command Line Integration") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Using GitAuthManager with command line:")
                        .font(.headline)
                    HelpFeature(text: "Configure Git globally using the app")
                    HelpFeature(text: "Test connections before making changes")
                    HelpFeature(text: "Monitor status through the Status tab")
                    HelpFeature(text: "Use 'git config --list' to verify settings")
                }
            }
        }
    }
}

struct FAQContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Frequently Asked Questions about GitAuthManager.")
                .font(.body)
            
            HelpSection(title: "Is GitAuthManager secure?") {
                Text("Yes! GitAuthManager uses macOS Keychain Services to securely store your credentials. Your tokens are encrypted and protected by your system's security features.")
            }
            
            HelpSection(title: "Does it work with other Git providers?") {
                Text("Currently, GitAuthManager is optimized for GitHub, but the underlying Git configuration works with any Git provider that supports personal access tokens.")
            }
            
            HelpSection(title: "Can I use it with SSH keys?") {
                Text("GitAuthManager focuses on HTTPS authentication with personal access tokens. For SSH key management, you'll need to use other tools or the command line.")
            }
            
            HelpSection(title: "What happens if I lose my token?") {
                Text("If you lose your token, you'll need to generate a new one from GitHub and update it in GitAuthManager. The app will help you test the new token to ensure it works correctly.")
            }
            
            HelpSection(title: "Does it work offline?") {
                Text("GitAuthManager can store and manage credentials offline, but connection testing requires an internet connection to verify your token with GitHub.")
            }
        }
    }
}

struct HelpSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            content
        }
    }
}

struct HelpStep: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\(number)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Circle().fill(.blue))
            
            Text(text)
                .font(.subheadline)
        }
    }
}

struct HelpFeature: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.caption)
                .frame(width: 16)
            
            Text(text)
                .font(.subheadline)
        }
    }
}

enum HelpTopic: CaseIterable {
    case gettingStarted
    case tokenManagement
    case troubleshooting
    case advancedUsage
    case faq
    
    var title: String {
        switch self {
        case .gettingStarted:
            return "Getting Started"
        case .tokenManagement:
            return "Token Management"
        case .troubleshooting:
            return "Troubleshooting"
        case .advancedUsage:
            return "Advanced Usage"
        case .faq:
            return "FAQ"
        }
    }
    
    var icon: String {
        switch self {
        case .gettingStarted:
            return "play.circle"
        case .tokenManagement:
            return "key.fill"
        case .troubleshooting:
            return "wrench.and.screwdriver"
        case .advancedUsage:
            return "gearshape.2"
        case .faq:
            return "questionmark.circle"
        }
    }
}

#Preview {
    HelpView()
}
