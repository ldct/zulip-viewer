import Foundation

// Message functions for NetworkClient
// API documentation: ../zulip-api-docs/get-messages.md

extension NetworkClient {
    /// Get messages for a specific channel and topic with narrow filtering
    /// API docs: ../zulip-api-docs/get-messages.md
    func getNarrow(anchor: Int, channelID: Int, topicName: String) async throws -> NarrowResponse {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "anchor", value: "\(anchor)"))
        queryItems.append(URLQueryItem(name: "num_before", value: "1000"))
        queryItems.append(URLQueryItem(name: "num_after", value: "0"))
        queryItems.append(URLQueryItem(name: "apply_markdown", value: "false"))
        queryItems.append(URLQueryItem(name: "client_gravatar", value: "false"))

        // URL-encode the topic name to handle quotes and special characters
        let encodedTopicName = topicName.replacingOccurrences(of: "\"", with: "\\\"")
        
        
        
        let narrow = """
[
{"negated":false,"operator":"channel","operand":\(channelID)},
{"negated":false,"operator":"topic","operand":"\(encodedTopicName)"}
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
        
//        print(url)
        
        let (data, _) = try await session.data(from: url)
        
//        print(String(data: data, encoding: .utf8)!)

        let response = try decoder.decode(NarrowResponse.self, from: data)

        return response
    }
    
    /// Get unread messages count for a specific channel and topic
    func getUnreadMessagesCount(channelID: Int, topicName: String) async throws -> Int {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "anchor", value: "newest"))
        queryItems.append(URLQueryItem(name: "num_before", value: "5000")) // Max allowed
        queryItems.append(URLQueryItem(name: "num_after", value: "0"))
        queryItems.append(URLQueryItem(name: "apply_markdown", value: "false"))
        queryItems.append(URLQueryItem(name: "client_gravatar", value: "false"))

        // URL-encode the topic name to handle quotes and special characters
        let encodedTopicName = topicName.replacingOccurrences(of: "\"", with: "\\\"")
        
        // Narrow to unread messages in specific channel and topic
        let narrow = """
[
{"negated":false,"operator":"channel","operand":\(channelID)},
{"negated":false,"operator":"topic","operand":"\(encodedTopicName)"},
{"negated":false,"operator":"is","operand":"unread"}
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
        
        let (data, _) = try await session.data(from: url)
        let response = try decoder.decode(NarrowResponse.self, from: data)
        
        return response.messages.count
    }
    
    /// Get unread messages for a specific channel and topic
    func getUnreadMessages(channelID: Int, topicName: String) async throws -> [Message] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "anchor", value: "newest"))
        queryItems.append(URLQueryItem(name: "num_before", value: "5000")) // Max allowed
        queryItems.append(URLQueryItem(name: "num_after", value: "0"))
        queryItems.append(URLQueryItem(name: "apply_markdown", value: "false"))
        queryItems.append(URLQueryItem(name: "client_gravatar", value: "false"))

        // URL-encode the topic name to handle quotes and special characters
        let encodedTopicName = topicName.replacingOccurrences(of: "\"", with: "\\\"")
        
        // Narrow to unread messages in specific channel and topic
        let narrow = """
[
{"negated":false,"operator":"channel","operand":\(channelID)},
{"negated":false,"operator":"topic","operand":"\(encodedTopicName)"},
{"negated":false,"operator":"is","operand":"unread"}
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
        
        let (data, _) = try await session.data(from: url)
        let response = try decoder.decode(NarrowResponse.self, from: data)
        
        return response.messages
    }
    
    /// Mark all messages in a topic as read
    func markTopicAsRead(channelID: Int, topicName: String) async throws {
        // First get all unread messages in the topic
        let unreadMessages = try await getUnreadMessages(channelID: channelID, topicName: topicName)
        
        guard !unreadMessages.isEmpty else {
            return // No unread messages to mark
        }
        
        // Create message IDs array
        let messageIds = unreadMessages.map { $0._id }
        
        // Prepare request body
        var request = URLRequest(url: URL(string: "https://leanprover.zulipchat.com/api/v1/messages/flags")!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Create form data
        var formData = "op=add&flag=read"
        let messageIdsString = messageIds.map { String($0) }.joined(separator: ",")
        formData += "&messages=[\(messageIdsString)]"
        
        request.httpBody = formData.data(using: .utf8)
        
        let session = URLSession(configuration: sessionConfig)
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
} 
