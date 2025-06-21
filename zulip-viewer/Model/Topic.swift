import Foundation

struct Topic: Codable, Identifiable, Hashable {
    let maxId: Int
    let name: String
    
    var id: String {
        "\(name)"
    }
}