import Foundation

// Subscription functions for NetworkClient

extension NetworkClient {
    /// Subscribe to a stream
    /// API docs: ../zulip-api-docs/subscribe.md
    func subscribe(to streamName: String) async throws -> SubscribeResponse {
        let session = URLSession(configuration: sessionConfig)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let url = URL(string: "https://leanprover.zulipchat.com/api/v1/users/me/subscriptions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let subscriptions = [["name": streamName]]
        let subscriptionsData = try JSONSerialization.data(withJSONObject: subscriptions)
        let subscriptionsString = String(data: subscriptionsData, encoding: .utf8)!
        
        let bodyString = "subscriptions=\(subscriptionsString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        request.httpBody = bodyString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await session.data(for: request)
        
        let response = try decoder.decode(SubscribeResponse.self, from: data)
        return response
    }
    
    /// Unsubscribe from a stream
    /// API docs: ../zulip-api-docs/unsubscribe.md
    func unsubscribe(from streamName: String) async throws -> UnsubscribeResponse {
        let session = URLSession(configuration: sessionConfig)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let url = URL(string: "https://leanprover.zulipchat.com/api/v1/users/me/subscriptions")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let subscriptions = [streamName]
        let subscriptionsData = try JSONSerialization.data(withJSONObject: subscriptions)
        let subscriptionsString = String(data: subscriptionsData, encoding: .utf8)!
        
        let bodyString = "subscriptions=\(subscriptionsString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        request.httpBody = bodyString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await session.data(for: request)
        
        let response = try decoder.decode(UnsubscribeResponse.self, from: data)
        return response
    }
    
    /// Get subscription status for a user and stream
    /// API docs: ../zulip-api-docs/get-subscription-status.md
    func getSubscriptionStatus(for streamId: Int, userId: Int) async throws -> SubscriptionStatusResponse {
        let session = URLSession(configuration: sessionConfig)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let url = URL(string: "https://leanprover.zulipchat.com/api/v1/users/\(userId)/subscriptions/\(streamId)")!
        let (data, _) = try await session.data(from: url)
        
        let response = try decoder.decode(SubscriptionStatusResponse.self, from: data)
        return response
    }
} 