import Foundation

// Authentication functions for NetworkClient
// API documentation: https://zulip.com/api/

extension NetworkClient {
    /// Authenticate user by retrieving stored API key or getting a new one
    func authenticate() async throws {
        if let apiKey = try? KeychainManager.getSavedAPIKey() {
            self.apiKey = apiKey
        } else {
            try await self.apiKey = getAPIKeyWithSavedCredentials()
                    
//            print("apiKey=\(apiKey)")

            _ = try? KeychainManager.removeFromKeychain(tag: KeychainManager.tag)
            try! KeychainManager.storeAPIKey(self.apiKey)
        }
    }
    
    /// Get API key using saved credentials from keychain
    func getAPIKeyWithSavedCredentials() async throws -> String {
        let credentials = try KeychainManager.getSavedPasswords()
        return try await getAPIKeyFromNetwork(credentials)
    }
    
    /// Fetch API key from Zulip server using credentials
    /// Related API docs: ../zulip-api-docs/index.md
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
    
    /// Perform login with given username and password, store credentials and API key in keychain
    /// Related API docs: ../zulip-api-docs/index.md
    func login(username: String, password: String) async throws {
        let credentials = LoginCredentials(username: username, password: password)
        let apiKey = try await getAPIKeyFromNetwork(credentials)
        try KeychainManager.storePassword(credentials)
        _ = try? KeychainManager.removeFromKeychain(tag: KeychainManager.tag)
        try KeychainManager.storeAPIKey(apiKey)
        self.apiKey = apiKey
    }
} 
