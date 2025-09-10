import SwiftUI
import Foundation

// MARK: - Color Extensions
extension Color {
    static let systemBackground = Color(NSColor.controlBackgroundColor)
    static let secondarySystemBackground = Color(NSColor.windowBackgroundColor)
}

// MARK: - String Extensions
extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidGitHubUsername: Bool {
        // GitHub usernames can only contain alphanumeric characters and hyphens
        // Cannot start or end with a hyphen
        let usernameRegex = "^[a-zA-Z0-9]([a-zA-Z0-9]|-(?=[a-zA-Z0-9])){0,38}$"
        let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: self)
    }
    
    var isValidToken: Bool {
        // GitHub tokens are typically 40 characters (classic) or start with ghp_ (fine-grained)
        return (self.count == 40 && self.allSatisfy { $0.isHexDigit }) || 
               (self.hasPrefix("ghp_") && self.count > 20)
    }
}

// MARK: - Character Extensions
extension Character {
    var isHexDigit: Bool {
        return ("0"..."9").contains(self) || 
               ("a"..."f").contains(self) || 
               ("A"..."F").contains(self)
    }
}

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color.systemBackground)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .buttonStyle(.bordered)
            .controlSize(.large)
    }
}

// MARK: - Date Extensions
extension Date {
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

// MARK: - Process Extensions
extension Process {
    static func runGitCommand(_ arguments: [String]) -> (output: String?, error: String?, exitCode: Int32) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.arguments = arguments
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            
            let output = String(data: outputData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
            let error = String(data: errorData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            return (output: output, error: error, exitCode: process.terminationStatus)
        } catch {
            return (output: nil, error: error.localizedDescription, exitCode: -1)
        }
    }
}
