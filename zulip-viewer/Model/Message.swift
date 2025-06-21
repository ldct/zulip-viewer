import Foundation

struct Message: Codable, Identifiable {
    let _id: Int
    let content: String
    let senderFullName: String
    let timestamp: Int
    let avatarUrl: URL?
    let reactions: [EmojiReaction]
    
    enum CodingKeys: String, CodingKey {
        case _id = "id"
        case content = "content"
        case senderFullName = "senderFullName"
        case timestamp
        case avatarUrl
        case reactions
    }
    
    var id: String {
        "\(_id)"
    }
}