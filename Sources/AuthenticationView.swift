import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showingTokenHelp = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "key.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                
                Text("Git Authentication")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Configure your Git credentials and personal access token")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top)
            
            // Form
            VStack(spacing: 16) {
                // Username Field
                VStack(alignment: .leading, spacing: 4) {
                    Text("GitHub Username")
                        .font(.headline)
                    TextField("Enter your GitHub username", text: $authManager.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(authManager.validationErrors.contains(.usernameRequired) || 
                                       authManager.validationErrors.contains(.invalidUsername) ? Color.red : Color.clear, lineWidth: 1)
                        )
                    
                    if authManager.validationErrors.contains(.usernameRequired) {
                        Text("Username is required")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else if authManager.validationErrors.contains(.invalidUsername) {
                        Text("Invalid GitHub username format")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // Email Field
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email Address")
                        .font(.headline)
                    TextField("Enter your email address", text: $authManager.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(authManager.validationErrors.contains(.emailRequired) || 
                                       authManager.validationErrors.contains(.invalidEmail) ? Color.red : Color.clear, lineWidth: 1)
                        )
                    
                    if authManager.validationErrors.contains(.emailRequired) {
                        Text("Email is required")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else if authManager.validationErrors.contains(.invalidEmail) {
                        Text("Invalid email format")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // Token Field
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Personal Access Token")
                            .font(.headline)
                        Spacer()
                        Button("How to get token?") {
                            showingTokenHelp = true
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    
                    SecureField("Enter your personal access token", text: $authManager.token)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(authManager.validationErrors.contains(.tokenRequired) || 
                                       authManager.validationErrors.contains(.invalidToken) ? Color.red : Color.clear, lineWidth: 1)
                        )
                    
                    if authManager.validationErrors.contains(.tokenRequired) {
                        Text("Token is required")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else if authManager.validationErrors.contains(.invalidToken) {
                        Text("Invalid token format")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal)
            
            // Status Display
            if !authManager.errorMessage.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(authManager.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                .padding(.horizontal)
            }
            
            // Connection Status
            HStack {
                Circle()
                    .fill(authManager.connectionStatus.color)
                    .frame(width: 12, height: 12)
                Text("Status: \(authManager.connectionStatus.displayText)")
                    .font(.subheadline)
                    .foregroundColor(authManager.connectionStatus.color)
            }
            .padding(.horizontal)
            
            // Action Buttons
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Button("Test Connection") {
                        authManager.testConnection()
                    }
                    .buttonStyle(.bordered)
                    .disabled(authManager.isLoading || authManager.username.isEmpty || authManager.email.isEmpty || authManager.token.isEmpty)
                    
                    Button("Sign In") {
                        authManager.signIn()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(authManager.isLoading || authManager.username.isEmpty || authManager.email.isEmpty || authManager.token.isEmpty)
                }
                
                if authManager.isAuthenticated {
                    Button("Sign Out") {
                        authManager.signOut()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showingTokenHelp) {
            TokenHelpView()
        }
    }
}

struct TokenHelpView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("How to Get a Personal Access Token")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HelpStep(number: 1, title: "Go to GitHub Settings", description: "Visit https://github.com/settings/tokens")
                        
                        HelpStep(number: 2, title: "Generate New Token", description: "Click 'Generate new token' → 'Generate new token (classic)'")
                        
                        HelpStep(number: 3, title: "Configure Token", description: "Give it a descriptive name and select the 'repo' scope")
                        
                        HelpStep(number: 4, title: "Copy Token", description: "Copy the generated token and paste it here")
                    }
                    
                    Text("Important: Keep your token secure and never share it publicly!")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top)
                }
                .padding()
            }
            .navigationTitle("Token Help")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .frame(width: 500, height: 400)
    }
}

struct HelpStep: View {
    let number: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Circle().fill(.blue))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationManager())
}
