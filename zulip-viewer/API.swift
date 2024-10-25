import Foundation
import Security

class KeychainManager {
    
    enum KeychainError: Error {
        case duplicateItem
        case noPassword
        case unknown(OSStatus)
    }
    
    static func getSavedPasswords() throws -> String {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: "xuanji@gmail.com",
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
        return password
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

struct Subscription: Codable, Identifiable {
    let streamId: Int
    let name: String
    let description: String 
    let renderedDescription: String
    
    var id: String {
        "\(streamId)"
    }
}

struct SubscriptionsResponse: Codable {
    let result: String
    let streams: [Subscription]
}

struct APIKeyResponse: Codable {
    let result: String
    let msg: String
    let apiKey: String?
}

class NetworkClient {
    var apiKey: String = ""
    
    func authenticate() async throws {
        try await self.apiKey = getAPIKeyWithSavedCredentials()
    }
    
    func getAPIKeyWithSavedCredentials() async throws  -> String {
        let password = try KeychainManager.getSavedPasswords()
        return try await getAPIKeyFromNetwork(email: "xuanji@gmail.com", password: password)
    }
    
    func getAPIKeyFromNetwork(email: String, password: String) async throws -> String {
        func encode(_ s: String) -> String {
            s.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        }
        
        let url = URL(string: "https://leanprover.zulipchat.com/api/v1/fetch_api_key?username=\(encode(email))&password=\(encode(password))")!
        
        let session = URLSession(configuration: .default)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let (data, _) = try await session.data(for: urlRequest)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(APIKeyResponse.self, from: data)

        return response.apiKey!
    }
    
    func getSubscriptions() async throws -> [Subscription] {
        
        let sessionConfig = URLSessionConfiguration.default
        let loginString = "xuanji@gmail.com:\(apiKey)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        sessionConfig.httpAdditionalHeaders = ["Authorization": "Basic \(base64LoginString)"]
        let session = URLSession(configuration: sessionConfig)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        
        let url = URL(string: "https://leanprover.zulipchat.com/api/v1/streams")!
        let (data, _) = try await session.data(from: url)

        let response = try decoder.decode(SubscriptionsResponse.self, from: data)
        
        return response.streams
    }
}

