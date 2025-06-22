import Foundation

struct TopicsResponse: Codable {
    let result: String
    let topics: [Topic]
}

struct SubscriptionsResponse: Codable {
    let result: String
    let streams: [Stream]
}

struct UserSubscriptionsResponse: Codable {
    let result: String
    let subscriptions: [Stream]
}

struct NarrowResponse: Codable {
    let result: String
    let messages: [Message]
}

struct APIKeyResponse: Codable {
    let result: String
    let msg: String
    let apiKey: String?
}

struct SubscribeResponse: Codable {
    let result: String
    let subscribed: [String: [String]]?
    let alreadySubscribed: [String: [String]]?
    
    enum CodingKeys: String, CodingKey {
        case result, subscribed
        case alreadySubscribed = "already_subscribed"
    }
}

struct UnsubscribeResponse: Codable {
    let result: String
    let removed: [String]?
    let notRemoved: [String]?
    
    enum CodingKeys: String, CodingKey {
        case result, removed
        case notRemoved = "not_removed"
    }
}

struct SubscriptionStatusResponse: Codable {
    let result: String
    let msg: String
    let isSubscribed: Bool
    
    enum CodingKeys: String, CodingKey {
        case result, msg
        case isSubscribed = "is_subscribed"
    }
}