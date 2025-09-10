import SwiftUI

struct StatusView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var gitConfig: (name: String?, email: String?) = (nil, nil)
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(authManager.connectionStatus.color)
                
                Text("Authentication Status")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Monitor your current Git authentication state")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top)
            
            // Status Cards
            VStack(spacing: 16) {
                // Connection Status Card
                StatusCard(
                    title: "Connection Status",
                    value: authManager.connectionStatus.displayText,
                    icon: "wifi",
                    color: authManager.connectionStatus.color,
                    isLoading: authManager.isLoading
                )
                
                // Authentication Status Card
                StatusCard(
                    title: "Authentication",
                    value: authManager.isAuthenticated ? "Authenticated" : "Not Authenticated",
                    icon: authManager.isAuthenticated ? "checkmark.shield.fill" : "xmark.shield.fill",
                    color: authManager.isAuthenticated ? .green : .red
                )
                
                // Git Configuration Card
                StatusCard(
                    title: "Git Configuration",
                    value: gitConfig.name != nil ? "Configured" : "Not Configured",
                    icon: "gear",
                    color: gitConfig.name != nil ? .green : .orange
                )
            }
            .padding(.horizontal)
            
            // Detailed Information
            VStack(alignment: .leading, spacing: 12) {
                Text("Current Configuration")
                    .font(.headline)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    if let name = gitConfig.name {
                        ConfigRow(label: "Git Username", value: name)
                    } else {
                        ConfigRow(label: "Git Username", value: "Not set", isError: true)
                    }
                    
                    if let email = gitConfig.email {
                        ConfigRow(label: "Git Email", value: email)
                    } else {
                        ConfigRow(label: "Git Email", value: "Not set", isError: true)
                    }
                    
                    ConfigRow(label: "GitHub Username", value: authManager.username.isEmpty ? "Not set" : authManager.username, isError: authManager.username.isEmpty)
                    
                    ConfigRow(label: "GitHub Email", value: authManager.email.isEmpty ? "Not set" : authManager.email, isError: authManager.email.isEmpty)
                    
                    ConfigRow(label: "Token Status", value: authManager.token.isEmpty ? "Not set" : "Configured", isError: authManager.token.isEmpty)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 12) {
                Button("Refresh Status") {
                    authManager.refreshStatus()
                    loadGitConfig()
                }
                .buttonStyle(.bordered)
                .disabled(authManager.isLoading)
                
                if authManager.isAuthenticated {
                    Button("Configure Git") {
                        configureGit()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            loadGitConfig()
        }
    }
    
    private func loadGitConfig() {
        let gitService = GitService()
        gitConfig = gitService.getCurrentGitConfig()
    }
    
    private func configureGit() {
        let gitService = GitService()
        gitService.configureGit(username: authManager.username, email: authManager.email)
        loadGitConfig()
    }
}

struct StatusCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let isLoading: Bool
    
    init(title: String, value: String, icon: String, color: Color, isLoading: Bool = false) {
        self.title = title
        self.value = value
        self.icon = icon
        self.color = color
        self.isLoading = isLoading
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if isLoading {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Checking...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text(value)
                        .font(.subheadline)
                        .foregroundColor(color)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}

struct ConfigRow: View {
    let label: String
    let value: String
    let isError: Bool
    
    init(label: String, value: String, isError: Bool = false) {
        self.label = label
        self.value = value
        self.isError = isError
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(isError ? .red : .primary)
                .fontWeight(isError ? .medium : .regular)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    StatusView()
        .environmentObject(AuthenticationManager())
}
