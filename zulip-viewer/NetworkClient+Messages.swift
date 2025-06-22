import Foundation

// Message functions for NetworkClient
// API documentation: ../zulip-api-docs/get-messages.md

extension NetworkClient {
    /// Get messages for a specific channel and topic with narrow filtering
    /// API docs: ../zulip-api-docs/get-messages.md
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
} 