import SwiftUI
import MarkdownWebView
import MarkdownUI

struct MessageView: View {
    let message: Message
    let onMarkAsRead: ((Int) -> Void)?
    
    @State private var isAnimating = false
    @State private var localIsUnread: Bool
    
    init(message: Message, onMarkAsRead: ((Int) -> Void)? = nil) {
        self.message = message
        self.onMarkAsRead = onMarkAsRead
        self._localIsUnread = State(initialValue: message.isUnread)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Avatar and name on one line
            HStack(alignment: .center, spacing: 12) {
                AsyncImage(url: message.avatarUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                
                Text(message.senderFullName)
                    .bold()
                    .foregroundColor(.primary)
                
                // Unread indicator badge
                if localIsUnread {
                    Button(action: {
                        markAsRead()
                    }) {
                        Text("NEW")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red)
                            .cornerRadius(8)
                            .scaleEffect(isAnimating ? 0.8 : 1.0)
                            .opacity(isAnimating ? 0.6 : 1.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
                
                Text(
                    Date(timeIntervalSince1970: TimeInterval(message.timestamp)),
                    style: .relative
                )
                .font(.body)
                .foregroundColor(localIsUnread ? .primary : .secondary)
                .fontWeight(.regular)
            }
            
            // Left-aligned message text
            VStack(alignment: .leading, spacing: 8) {
                Markdown(message.content)
                    .multilineTextAlignment(.leading)
                    .font(.subheadline)
                    .fontWeight(.regular)
                
                if !message.reactions.isEmpty {
                    EmojiReactionsView(reactions: message.reactions)
                }
            }
        }
        .padding(.vertical, localIsUnread ? 8 : 4)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(localIsUnread ? Color.blue.opacity(0.05) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(localIsUnread ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
    
    private func markAsRead() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isAnimating = true
        }
        
        // Call the network function
        onMarkAsRead?(message._id)
        
        // After a short delay, hide the NEW tag with animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.4)) {
                localIsUnread = false
                isAnimating = false
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        // Read message
        MessageView(message: Message(
            _id: 12345,
            content: "Hello everyone! 👋 This is a read message with some **markdown** formatting.",
            senderFullName: "John Doe",
            timestamp: Int(Date().timeIntervalSince1970) - 3600,
            avatarUrl: URL(string: "https://via.placeholder.com/64x64/007bff/ffffff?text=JD"),
            reactions: [
                EmojiReaction(
                    emojiName: "thumbs_up",
                    emojiCode: "1f44d",
                    reactionType: "unicode_emoji",
                    userID: 1
                )
            ],
            flags: ["read"]
        ))
        
        // Unread message
        MessageView(message: Message(
            _id: 67890,
            content: "This is an **unread message** that should stand out! It has different styling to catch attention.",
            senderFullName: "Jane Smith",
            timestamp: Int(Date().timeIntervalSince1970),
            avatarUrl: URL(string: "https://via.placeholder.com/64x64/28a745/ffffff?text=JS"),
            reactions: [],
            flags: nil // No flags = unread
        ))
    }
    .padding()
}



