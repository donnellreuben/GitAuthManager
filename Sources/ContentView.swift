import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some View {
        NavigationView {
            SidebarView()
                .frame(minWidth: 200)
            
            MainContentView()
                .environmentObject(authManager)
        }
        .navigationTitle("GitAuthManager")
    }
}

struct SidebarView: View {
    var body: some View {
        List {
            NavigationLink(destination: AuthenticationView()) {
                Label("Authentication", systemImage: "key.fill")
            }
            .tag("auth")
            
            NavigationLink(destination: StatusView()) {
                Label("Status", systemImage: "checkmark.circle.fill")
            }
            .tag("status")
            
            NavigationLink(destination: SettingsView()) {
                Label("Settings", systemImage: "gear")
            }
            .tag("settings")
            
            NavigationLink(destination: HelpView()) {
                Label("Help", systemImage: "questionmark.circle")
            }
            .tag("help")
        }
        .listStyle(SidebarListStyle())
    }
}

struct MainContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "key.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Welcome to GitAuthManager")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Manage your Git authentication with ease")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
