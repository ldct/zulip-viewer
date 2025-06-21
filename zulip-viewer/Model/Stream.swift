import Foundation

struct Stream: Codable, Identifiable, Hashable {
    let streamId: Int
    let name: String
    let description: String 
    
    var id: String {
        "\(streamId)"
    }
}