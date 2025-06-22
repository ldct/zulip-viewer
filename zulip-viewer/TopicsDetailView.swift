import SwiftUI
import WebKit

/// Pure UI view for displaying topic details without network calls
struct TopicsDetailContentView: View {
    let streamName: String
    let topicName: String
    let messages: [Message]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(streamName) > \(topicName)")
                .frame(maxWidth: .infinity, alignment: .center)

            List {
                ForEach(messages) { message in
                    MessageView(message: message)
                }
            }
        }
    }
}

/// Wrapper view that handles network calls and data loading
struct TopicsDetailView: View {
    let streamId: Int
    let streamName: String
    let topic: Topic
    
    @Environment(NetworkClient.self) private var networkClient
    
    @State var messages = [Message]()
    
    var body: some View {
        TopicsDetailContentView(
            streamName: streamName,
            topicName: topic.name,
            messages: messages
        )
        .task {
            let narrowResponse = try! await networkClient.getNarrow(
                anchor: topic.maxId,
                channelID: streamId,
                topicName: topic.name
            )
            messages = narrowResponse.messages
        }
    }
}
