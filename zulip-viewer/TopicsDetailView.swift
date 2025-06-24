import SwiftUI
import WebKit

/// Pure UI view for displaying topic details without network calls
struct TopicsDetailContentView: View {
    let streamName: String
    let topicName: String
    let messages: [Message]
    let unreadCount: Int
    let onMarkTopicAsRead: () -> Void
    let onMarkMessageAsRead: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(topicName)")
                    .frame(maxWidth: .infinity, alignment: .center)
                
                if unreadCount > 0 {
                    Button(action: onMarkTopicAsRead) {
                        Text("\(unreadCount)")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)

            List {
                ForEach(messages) { message in
                    MessageView(message: message, onMarkAsRead: onMarkMessageAsRead)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
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
    @State var unreadCount = 0
    
    var body: some View {
        TopicsDetailContentView(
            streamName: streamName,
            topicName: topic.name,
            messages: messages,
            unreadCount: unreadCount,
            onMarkTopicAsRead: markTopicAsRead,
            onMarkMessageAsRead: markMessageAsRead
        )
        .task {
            await loadContent()
        }
    }
    
    private func loadContent() async {
        do {
            // Load all messages
            let narrowResponse = try await networkClient.getNarrow(
                anchor: topic.maxId,
                channelID: streamId,
                topicName: topic.name
            )
            messages = narrowResponse.messages
            
            // Get unread count
            unreadCount = try await networkClient.getUnreadMessagesCount(
                channelID: streamId,
                topicName: topic.name
            )
            print("unreadcount=\(unreadCount)")
        } catch {
            print("Error loading content: \(error)")
        }
    }
    
    private func markTopicAsRead() {
        Task {
            do {
                try await networkClient.markTopicAsRead(
                    channelID: streamId,
                    topicName: topic.name
                )
                // Refresh the unread count after marking as read
                unreadCount = try await networkClient.getUnreadMessagesCount(
                    channelID: streamId,
                    topicName: topic.name
                )
            } catch {
                print("Error marking as read: \(error)")
            }
        }
    }
    
    private func markMessageAsRead(messageId: Int) {
        Task {
            do {
                try await networkClient.markMessageAsRead(messageId: messageId)
                // Refresh the unread count after marking individual message as read
                unreadCount = try await networkClient.getUnreadMessagesCount(
                    channelID: streamId,
                    topicName: topic.name
                )
            } catch {
                print("Error marking message as read: \(error)")
            }
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
                reactions: [],
                flags: ["read"]
            ),
            Message(
                _id: 2,
                content: "Yesterday I worked on the user authentication system. Today I'll be focusing on the API integration.",
                senderFullName: "Bob Smith",
                timestamp: 1640995300,
                avatarUrl: nil,
                reactions: [],
                flags: nil // Unread message
            ),
            Message(
                _id: 3,
                content: "I finished the UI mockups and got approval from the design team. Moving on to implementation now.",
                senderFullName: "Carol Davis",
                timestamp: 1640995400,
                avatarUrl: nil,
                reactions: [],
                flags: ["read"]
            )
        ],
        unreadCount: 1,
        onMarkTopicAsRead: {},
        onMarkMessageAsRead: { _ in }
    )
}
