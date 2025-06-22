import SwiftUI
import MarkdownWebView
import MarkdownUI

struct MessageView: View {
    let message: Message
    
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
                
                Spacer()
                
                Text(
                    Date(timeIntervalSince1970: TimeInterval(message.timestamp)),
                    style: .relative
                )
                .font(.body)
                    .foregroundColor(.secondary)
            }
            
            // Left-aligned message text
            VStack(alignment: .leading, spacing: 8) {
                Markdown(message.content)
                    .multilineTextAlignment(.leading)
                    .font(.subheadline)
                
                if !message.reactions.isEmpty {
                    EmojiReactionsView(reactions: message.reactions)
                }
            }
        }
    }
}

#Preview {
    MessageView(message: Message(
        _id: 12345,
        content: "Hello everyone! 👋 This is a sample message with some **markdown** formatting and a [link](https://zulip.com).",
        senderFullName: "John Doe",
        timestamp: Int(Date().timeIntervalSince1970),
        avatarUrl: URL(string: "https://via.placeholder.com/64x64/007bff/ffffff?text=JD"),
        reactions: [
            EmojiReaction(
                emojiName: "thumbs_up",
                emojiCode: "1f44d",
                reactionType: "unicode_emoji",
                userID: 1
            ),
            EmojiReaction(
                emojiName: "heart",
                emojiCode: "2764",
                reactionType: "unicode_emoji", 
                userID: 2
            )
        ]
    ))
    .border(Color.gray, width: 1)
    .padding()
}



