import Foundation

struct WrappedTopic: Identifiable, Hashable {
    let parentStreamID: Int
    let parentStreamName: String
    let topic: Topic
    
    var id: String {
        topic.id
    }
}