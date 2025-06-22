import Foundation

// Stream functions for NetworkClient

extension NetworkClient {
    /// Get user's subscriptions
    /// API docs: ../zulip-api-docs/get-subscriptions.md
    func getSubscriptions() async throws -> [Stream] {
        let session = URLSession(configuration: sessionConfig)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        
        let url = URL(string: "https://leanprover.zulipchat.com/api/v1/users/me/subscriptions")!
        let (data, _) = try await session.data(from: url)

        let response = try decoder.decode(UserSubscriptionsResponse.self, from: data)
        
        return response.subscriptions
    }
    
    /// Get all streams
    /// API docs: ../zulip-api-docs/get-streams.md
    func getAllStreams() async throws -> [Stream] {
        let session = URLSession(configuration: sessionConfig)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        
        let url = URL(string: "https://leanprover.zulipchat.com/api/v1/streams")!
        let (data, _) = try await session.data(from: url)

        let response = try decoder.decode(SubscriptionsResponse.self, from: data)
        
        return response.streams
    }
    
    /// Get topics for a specific stream
    /// API docs: ../zulip-api-docs/get-stream-topics.md
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