import Foundation

class GitService {
    
    func testConnection(username: String, email: String, token: String, completion: @escaping (Result<ConnectionStatus, Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1.0) {
            // For demo purposes, we'll simulate a connection test
            // In a real implementation, this would make an actual API call to GitHub
            
            if username.isEmpty || email.isEmpty || token.isEmpty {
                completion(.failure(GitError.missingCredentials))
                return
            }
            
            // Simulate token validation
            if token.count < 20 {
                completion(.failure(GitError.invalidToken))
                return
            }
            
            // Simulate successful connection
            completion(.success(.connected))
        }
    }
    
    func checkCurrentStatus(completion: @escaping (Result<ConnectionStatus, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) {
            // Check if Git is configured and working
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
            process.arguments = ["config", "--global", "user.name"]
            
            do {
                try process.run()
                process.waitUntilExit()
                
                if process.terminationStatus == 0 {
                    completion(.success(.connected))
                } else {
                    completion(.success(.unknown))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func configureGit(username: String, email: String) {
        // Configure Git with the provided credentials
        let nameProcess = Process()
        nameProcess.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        nameProcess.arguments = ["config", "--global", "user.name", username]
        
        let emailProcess = Process()
        emailProcess.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        emailProcess.arguments = ["config", "--global", "user.email", email]
        
        do {
            try nameProcess.run()
            nameProcess.waitUntilExit()
            
            try emailProcess.run()
            emailProcess.waitUntilExit()
        } catch {
            print("Failed to configure Git: \(error)")
        }
    }
    
    func getCurrentGitConfig() -> (name: String?, email: String?) {
        let nameProcess = Process()
        nameProcess.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        nameProcess.arguments = ["config", "--global", "user.name"]
        
        let emailProcess = Process()
        emailProcess.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        emailProcess.arguments = ["config", "--global", "user.email"]
        
        var name: String?
        var email: String?
        
        do {
            let namePipe = Pipe()
            nameProcess.standardOutput = namePipe
            try nameProcess.run()
            nameProcess.waitUntilExit()
            
            if nameProcess.terminationStatus == 0 {
                let nameData = namePipe.fileHandleForReading.readDataToEndOfFile()
                name = String(data: nameData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            let emailPipe = Pipe()
            emailProcess.standardOutput = emailPipe
            try emailProcess.run()
            emailProcess.waitUntilExit()
            
            if emailProcess.terminationStatus == 0 {
                let emailData = emailPipe.fileHandleForReading.readDataToEndOfFile()
                email = String(data: emailData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        } catch {
            print("Failed to get Git config: \(error)")
        }
        
        return (name: name, email: email)
    }
}

enum GitError: LocalizedError {
    case missingCredentials
    case invalidToken
    case connectionFailed
    
    var errorDescription: String? {
        switch self {
        case .missingCredentials:
            return "Please fill in all required fields"
        case .invalidToken:
            return "Invalid token format"
        case .connectionFailed:
            return "Failed to connect to GitHub"
        }
    }
}
