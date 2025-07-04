import Foundation
import Security

struct LoginCredentials {
    var username: String
    var password: String
}

class KeychainManager {
    enum KeychainError: Error {
        case duplicateItem
        case noPassword
        case unknown(OSStatus)
    }
    
    static let tag = "com.zulip-viewer.keys.apiKey".data(using: .utf8)!
        
    static func storeAPIKey(_ key: String) throws {
        guard !key.isEmpty else {
            throw KeychainError.noPassword
        }
        
        let addquery: [String: Any] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrApplicationTag): tag,
            String(kSecValueData): key.data(using: .utf8)!
        ]
        let status = SecItemAdd(addquery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }

    
    static func removeFromKeychain(tag: Data) throws {
        let attributes: [String: Any] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrApplicationTag): tag
        ]

        let status = SecItemDelete(attributes as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    static func getSavedAPIKey() throws -> String {
        let query: [String: Any] = [String(kSecClass): kSecClassKey,
                                    String(kSecMatchLimit): kSecMatchLimitOne,
                                    String(kSecReturnAttributes): true,
                                    String(kSecReturnData) as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unknown(status) }

        guard let existingItem = item as? [String : Any],
            let apiKeyData = existingItem[kSecValueData as String] as? Data,
            let apiKey = String(data: apiKeyData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.noPassword
        }
        return apiKey
    }
    


    static func getSavedPasswords() throws -> LoginCredentials {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unknown(status) }

        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.noPassword
        }
        return .init(username: account, password: password)
    }
    
    /// Store login credentials (username and password) in the keychain.
    static func storePassword(_ credentials: LoginCredentials) throws {
        let passwordData = credentials.password.data(using: .utf8)!
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: credentials.username
        ]
        SecItemDelete(deleteQuery as CFDictionary)

        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: credentials.username,
            kSecValueData as String: passwordData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateItem
        }
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
}


