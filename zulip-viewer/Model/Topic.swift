import Foundation

struct Topic: Codable, Identifiable, Hashable {
    let maxId: Int
    let name: String
    var unreadCount: Int? // Optional unread count that can be loaded separately
    
    var id: String {
        "\(name)"
    }
    
    // Custom coding keys to handle the optional unreadCount
    enum CodingKeys: String, CodingKey {
        case maxId, name, unreadCount
    }
    
    // Custom initializer for creating topics without unread count initially
    init(maxId: Int, name: String, unreadCount: Int? = nil) {
        self.maxId = maxId
        self.name = name
        self.unreadCount = unreadCount
    }
}