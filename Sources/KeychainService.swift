import Foundation
import Security

class KeychainService {
    private let serviceName = "GitAuthManager"
    
    // MARK: - Username
    func saveUsername(_ username: String) {
        saveToKeychain(key: "username", value: username)
    }
    
    func getUsername() -> String? {
        return getFromKeychain(key: "username")
    }
    
    // MARK: - Email
    func saveEmail(_ email: String) {
        saveToKeychain(key: "email", value: email)
    }
    
    func getEmail() -> String? {
        return getFromKeychain(key: "email")
    }
    
    // MARK: - Token
    func saveToken(_ token: String) {
        saveToKeychain(key: "token", value: token)
    }
    
    func getToken() -> String? {
        return getFromKeychain(key: "token")
    }
    
    // MARK: - Clear All
    func clearCredentials() {
        deleteFromKeychain(key: "username")
        deleteFromKeychain(key: "email")
        deleteFromKeychain(key: "token")
    }
    
    // MARK: - Private Methods
    private func saveToKeychain(key: String, value: String) {
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Delete existing item first
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Failed to save to keychain: \(status)")
        }
    }
    
    private func getFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
           let data = result as? Data,
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        
        return nil
    }
    
    private func deleteFromKeychain(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
