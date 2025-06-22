import Foundation

struct Stream: Codable, Identifiable, Hashable {
    let streamId: Int
    let name: String
    let description: String
    var isSubscribed: Bool = false
    
    var id: String {
        "\(streamId)"
    }
    
    enum CodingKeys: String, CodingKey {
        case streamId, name, description
    }
}