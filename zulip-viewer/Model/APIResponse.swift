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