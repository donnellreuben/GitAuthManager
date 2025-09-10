import Foundation
import Combine

class AuthenticationManager: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var token: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var connectionStatus: ConnectionStatus = .unknown
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var validationErrors: [ValidationError] = []
    
    private let keychainService = KeychainService()
    private let gitService = GitService()
    
    init() {
        loadCredentials()
        checkAuthenticationStatus()
    }
    
    func loadCredentials() {
        username = keychainService.getUsername() ?? ""
        email = keychainService.getEmail() ?? ""
        token = keychainService.getToken() ?? ""
    }
    
    func saveCredentials() {
        keychainService.saveUsername(username)
        keychainService.saveEmail(email)
        keychainService.saveToken(token)
    }
    
    func validateInputs() -> Bool {
        validationErrors.removeAll()
        
        if username.isEmpty {
            validationErrors.append(.usernameRequired)
        } else if !username.isValidGitHubUsername {
            validationErrors.append(.invalidUsername)
        }
        
        if email.isEmpty {
            validationErrors.append(.emailRequired)
        } else if !email.isValidEmail {
            validationErrors.append(.invalidEmail)
        }
        
        if token.isEmpty {
            validationErrors.append(.tokenRequired)
        } else if !token.isValidToken {
            validationErrors.append(.invalidToken)
        }
        
        return validationErrors.isEmpty
    }
    
    func testConnection() {
        guard validateInputs() else {
            errorMessage = "Please fix the validation errors below"
            return
        }
        
        isLoading = true
        errorMessage = ""
        connectionStatus = .testing
        
        gitService.testConnection(username: username, email: email, token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let status):
                    self?.connectionStatus = status
                    if status == .connected {
                        self?.isAuthenticated = true
                    }
                case .failure(let error):
                    self?.connectionStatus = .failed
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signIn() {
        saveCredentials()
        testConnection()
    }
    
    func signOut() {
        keychainService.clearCredentials()
        username = ""
        email = ""
        token = ""
        isAuthenticated = false
        connectionStatus = .unknown
    }
    
    func checkAuthenticationStatus() {
        gitService.checkCurrentStatus { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let status):
                    self?.connectionStatus = status
                    self?.isAuthenticated = (status == .connected)
                case .failure:
                    self?.connectionStatus = .unknown
                    self?.isAuthenticated = false
                }
            }
        }
    }
    
    func refreshStatus() {
        checkAuthenticationStatus()
    }
}

enum ConnectionStatus {
    case unknown
    case connected
    case failed
    case testing
    
    var displayText: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .connected:
            return "Connected"
        case .failed:
            return "Failed"
        case .testing:
            return "Testing..."
        }
    }
    
    var color: Color {
        switch self {
        case .unknown:
            return .secondary
        case .connected:
            return .green
        case .failed:
            return .red
        case .testing:
            return .orange
        }
    }
}

enum ValidationError: LocalizedError {
    case usernameRequired
    case invalidUsername
    case emailRequired
    case invalidEmail
    case tokenRequired
    case invalidToken
    
    var errorDescription: String? {
        switch self {
        case .usernameRequired:
            return "Username is required"
        case .invalidUsername:
            return "Invalid GitHub username format"
        case .emailRequired:
            return "Email is required"
        case .invalidEmail:
            return "Invalid email format"
        case .tokenRequired:
            return "Personal access token is required"
        case .invalidToken:
            return "Invalid token format"
        }
    }
}
