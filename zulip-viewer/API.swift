import Foundation
import Observation

struct WrappedTopic: Identifiable, Hashable {
    let parentStreamID: Int
    let parentStreamName: String
    let topic: Topic
    
    var id: String {
        topic.id
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

struct NarrowResponse: Codable {
    let result: String
    let messages: [Message]
}

struct Message: Codable, Identifiable {
    let _id: Int
    let content: String
    let senderFullName: String
    let timestamp: Int
    let avatarUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case _id = "id"
        case content = "content"
        case senderFullName = "senderFullName"
        case timestamp
        case avatarUrl
    }
    
    var id: String {
        "\(_id)"
    }
}

struct APIKeyResponse: Codable {
    let result: String
    let msg: String
    let apiKey: String?
}

@MainActor
@Observable class NetworkClient {
    var apiKey: String = ""
    
    func authenticate() async throws {
        if let apiKey = try? KeychainManager.getSavedAPIKey() {
            self.apiKey = apiKey
        } else {
            try await self.apiKey = getAPIKeyWithSavedCredentials()
                    
            print("apiKey=\(apiKey)")

            _ = try? KeychainManager.removeFromKeychain(tag: KeychainManager.tag)
            try! KeychainManager.storeAPIKey(self.apiKey)
        }
    }
    
    func getAPIKeyWithSavedCredentials() async throws  -> String {
        let credentials = try KeychainManager.getSavedPasswords()
        return try await getAPIKeyFromNetwork(credentials)
    }
    
    func getNarrow(anchor: Int, channelID: Int, topicName: String) async throws -> NarrowResponse {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "anchor", value: "\(anchor)"))
        queryItems.append(URLQueryItem(name: "num_before", value: "5"))
        queryItems.append(URLQueryItem(name: "num_after", value: "5"))
        queryItems.append(URLQueryItem(name: "apply_markdown", value: "false"))

        let narrow = """
[
{"negated":false,"operator":"channel","operand":\(channelID)},
{"negated":false,"operator":"topic","operand":"\(topicName)"}
]
"""
        queryItems.append(URLQueryItem(name: "narrow", value: narrow))

        var components = URLComponents()
        components.queryItems = queryItems
        let queryParameters = components.string!
        
        let session = URLSession(configuration: sessionConfig)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        
        let url = URL(string: "https://leanprover.zulipchat.com/api/v1/messages\(queryParameters)")!
        
        print(url)
        
        let (data, _) = try await session.data(from: url)
        
        print(String(data: data, encoding: .utf8)!)

        let response = try decoder.decode(NarrowResponse.self, from: data)

        return response
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
    
    /// Perform login with given username and password, store credentials and API key in keychain.
    func login(username: String, password: String) async throws {
        let credentials = LoginCredentials(username: username, password: password)
        let apiKey = try await getAPIKeyFromNetwork(credentials)
        try KeychainManager.storePassword(credentials)
        _ = try? KeychainManager.removeFromKeychain(tag: KeychainManager.tag)
        try KeychainManager.storeAPIKey(apiKey)
        self.apiKey = apiKey
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
