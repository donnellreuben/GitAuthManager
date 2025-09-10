import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showingClearConfirmation = false
    @State private var showingAbout = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "gear")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Manage your GitAuthManager preferences and credentials")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top)
            
            // Settings Sections
            VStack(spacing: 24) {
                // Credential Management Section
                SettingsSection(title: "Credential Management", icon: "key.fill") {
                    VStack(spacing: 12) {
                        SettingsRow(
                            title: "Clear All Credentials",
                            subtitle: "Remove all stored usernames, emails, and tokens",
                            icon: "trash.fill",
                            iconColor: .red
                        ) {
                            showingClearConfirmation = true
                        }
                        
                        Divider()
                        
                        SettingsRow(
                            title: "Export Configuration",
                            subtitle: "Save your current settings to a file",
                            icon: "square.and.arrow.up",
                            iconColor: .blue
                        ) {
                            exportConfiguration()
                        }
                        
                        SettingsRow(
                            title: "Import Configuration",
                            subtitle: "Load settings from a previously saved file",
                            icon: "square.and.arrow.down",
                            iconColor: .green
                        ) {
                            importConfiguration()
                        }
                    }
                }
                
                // Git Configuration Section
                SettingsSection(title: "Git Configuration", icon: "terminal") {
                    VStack(spacing: 12) {
                        SettingsRow(
                            title: "Configure Global Git",
                            subtitle: "Set up Git with your current credentials",
                            icon: "gear",
                            iconColor: .orange
                        ) {
                            configureGlobalGit()
                        }
                        
                        Divider()
                        
                        SettingsRow(
                            title: "Test Git Connection",
                            subtitle: "Verify that Git is working correctly",
                            icon: "checkmark.circle",
                            iconColor: .green
                        ) {
                            testGitConnection()
                        }
                    }
                }
                
                // Application Section
                SettingsSection(title: "Application", icon: "app") {
                    VStack(spacing: 12) {
                        SettingsRow(
                            title: "About GitAuthManager",
                            subtitle: "Version information and credits",
                            icon: "info.circle",
                            iconColor: .blue
                        ) {
                            showingAbout = true
                        }
                        
                        Divider()
                        
                        SettingsRow(
                            title: "Check for Updates",
                            subtitle: "Look for newer versions of the app",
                            icon: "arrow.clockwise",
                            iconColor: .purple
                        ) {
                            checkForUpdates()
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert("Clear All Credentials", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                authManager.signOut()
            }
        } message: {
            Text("This will permanently remove all stored credentials from your keychain. This action cannot be undone.")
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
    
    private func exportConfiguration() {
        let config = [
            "username": authManager.username,
            "email": authManager.email,
            "hasToken": !authManager.token.isEmpty
        ]
        
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.json]
        panel.nameFieldStringValue = "GitAuthManager-Config.json"
        
        if panel.runModal() == .OK, let url = panel.url {
            do {
                let data = try JSONSerialization.data(withJSONObject: config, options: .prettyPrinted)
                try data.write(to: url)
            } catch {
                print("Failed to export configuration: \(error)")
            }
        }
    }
    
    private func importConfiguration() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.json]
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK, let url = panel.url {
            do {
                let data = try Data(contentsOf: url)
                let config = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                
                if let username = config?["username"] as? String {
                    authManager.username = username
                }
                if let email = config?["email"] as? String {
                    authManager.email = email
                }
                
                authManager.saveCredentials()
            } catch {
                print("Failed to import configuration: \(error)")
            }
        }
    }
    
    private func configureGlobalGit() {
        let gitService = GitService()
        gitService.configureGit(username: authManager.username, email: authManager.email)
    }
    
    private func testGitConnection() {
        authManager.testConnection()
    }
    
    private func checkForUpdates() {
        // In a real app, this would check for updates
        print("Checking for updates...")
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
            }
            
            content
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 20)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "key.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("GitAuthManager")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Version 1.0.0")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("A modern macOS application that simplifies Git authentication management with a beautiful, native SwiftUI interface.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Features:")
                        .font(.headline)
                    
                    FeatureRow(text: "Secure credential storage with Keychain")
                    FeatureRow(text: "Real-time connection testing")
                    FeatureRow(text: "Native macOS design")
                    FeatureRow(text: "Multi-account support")
                }
                .padding(.horizontal)
                
                Text("Made with ❤️ for the macOS developer community")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top)
                
                Spacer()
            }
            .padding()
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .frame(width: 400, height: 500)
    }
}

struct FeatureRow: View {
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.caption)
            Text(text)
                .font(.subheadline)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthenticationManager())
}
