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
    
    static func storePassword() throws {
        let passwordData = "INSERTHERE".data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "xuanji@gmail.com",
            kSecValueData as String: passwordData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]

        // adding the item to keychain here
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        } else if status != errSecSuccess {
            throw KeychainError.unknown(status)
        }
    }
}

struct Topic: Codable, Identifiable, Hashable {
    let maxId: Int
    let name: String
    
    var id: String {
        "\(name)"
    }
}

struct Stream: Codable, Identifiable, Hashable {
    let streamId: Int
    let name: String
    let description: String 
    
    var id: String {
        "\(streamId)"
    }
}

struct TopicsResponse: Codable {
    let result: String
    let topics: [Topic]
}


struct SubscriptionsResponse: Codable {
    let result: String
    let streams: [Stream]
}

struct APIKeyResponse: Codable {
    let result: String
    let msg: String
    let apiKey: String?
}

@MainActor class NetworkClient: ObservableObject {
    var apiKey: String = ""
    
    func authenticate() async throws {
        if let apiKey = try? KeychainManager.getSavedAPIKey() {
            self.apiKey = apiKey
        } else {
            try await self.apiKey = getAPIKeyWithSavedCredentials()
                    

            try! KeychainManager.removeFromKeychain(tag: KeychainManager.tag)
            try! KeychainManager.storeAPIKey(self.apiKey)
        }
    }
    
    func getAPIKeyWithSavedCredentials() async throws  -> String {
        let credentials = try KeychainManager.getSavedPasswords()
        return try await getAPIKeyFromNetwork(credentials)
    }
    
    func getAPIKeyFromNetwork(_ credentials: LoginCredentials) async throws -> String {
        func encode(_ s: String) -> String {
            s.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        }
        
        let url = URL(string: "https://leanprover.zulipchat.com/api/v1/fetch_api_key?username=\(encode(credentials.username))&password=\(encode(credentials.password))")!
        
        let session = URLSession(configuration: .default)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let (data, _) = try await session.data(for: urlRequest)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(APIKeyResponse.self, from: data)

        return response.apiKey!
    }
    
    var sessionConfig: URLSessionConfiguration {
        let sessionConfig = URLSessionConfiguration.default
        let loginString = "xuanji@gmail.com:\(apiKey)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        sessionConfig.httpAdditionalHeaders = ["Authorization": "Basic \(base64LoginString)"]
        return sessionConfig
    }

    func getSubscriptions() async throws -> [Stream] {
        let session = URLSession(configuration: sessionConfig)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        
        let url = URL(string: "https://leanprover.zulipchat.com/api/v1/streams")!
        let (data, _) = try await session.data(from: url)

        let response = try decoder.decode(SubscriptionsResponse.self, from: data)
        
        return response.streams
    }
    
    func getTopics(streamId: Int) async throws -> [Topic] {
        let session = URLSession(configuration: sessionConfig)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        
        let url = URL(string: "https://leanprover.zulipchat.com/api/v1/users/me/\(streamId)/topics")!
        let (data, _) = try await session.data(from: url)

        let response = try decoder.decode(TopicsResponse.self, from: data)
        
        return response.topics
    }
}

