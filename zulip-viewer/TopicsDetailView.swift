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
            .listStyle(PlainListStyle())
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

#Preview {
    TopicsDetailContentView(
        streamName: "general",
        topicName: "Daily Standup",
        messages: [
            Message(
                _id: 1,
                content: "Good morning everyone! Ready for today's standup?",
                senderFullName: "Alice Johnson",
                timestamp: 1640995200,
                avatarUrl: nil,
                reactions: []
            ),
            Message(
                _id: 2,
                content: "Yesterday I worked on the user authentication system. Today I'll be focusing on the API integration.",
                senderFullName: "Bob Smith",
                timestamp: 1640995300,
                avatarUrl: nil,
                reactions: []
            ),
            Message(
                _id: 3,
                content: "I finished the UI mockups and got approval from the design team. Moving on to implementation now.",
                senderFullName: "Carol Davis",
                timestamp: 1640995400,
                avatarUrl: nil,
                reactions: []
            )
        ]
    )
}
