import Foundation

struct EmojiReaction: Codable, Identifiable {
    let emojiName: String
    let emojiCode: String
    let reactionType: String
    let userID: Int
    
    enum CodingKeys: String, CodingKey {
        case emojiName = "emojiName"
        case emojiCode = "emojiCode"
        case reactionType = "reactionType"
        case userID = "userId"
    }
    
    var id: String {
        "\(emojiName)-\(userID)"
    }
    
    var unicodeEmoji: String {
        guard let codePoint = Int(emojiCode, radix: 16) else { return "?" }
        return String(UnicodeScalar(codePoint) ?? UnicodeScalar(0x3F)!)
    }
}