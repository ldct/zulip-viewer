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
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Left-aligned message text
            VStack(alignment: .leading, spacing: 8) {
                Markdown(message.content)
                    .multilineTextAlignment(.leading)
                
                if !message.reactions.isEmpty {
                    EmojiReactionsView(reactions: message.reactions)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct EmojiReactionsView: View {
    let reactions: [EmojiReaction]
    
    private var reactionCounts: [String: (emoji: String, count: Int)] {
        var counts: [String: (emoji: String, count: Int)] = [:]
        
        for reaction in reactions {
            let key = reaction.emojiName
            if let existing = counts[key] {
                counts[key] = (emoji: existing.emoji, count: existing.count + 1)
            } else {
                counts[key] = (emoji: reaction.unicodeEmoji, count: 1)
            }
        }
        
        return counts
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 5), spacing: 4) {
            ForEach(Array(reactionCounts.keys.sorted()), id: \.self) { key in
                let reactionData = reactionCounts[key]!
                HStack(spacing: 2) {
                    Text(reactionData.emoji)
                        .font(.system(size: 14))
                    Text("\(reactionData.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
}

@available(iOS 15, *)
struct HTMLText: View {
    let html: String
    
    var body: some View {
        let attrS = try! AttributedString(markdown: html)
        Text(attrS)
    }
}
