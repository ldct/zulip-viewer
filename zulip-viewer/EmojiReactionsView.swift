import SwiftUI

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
                        .font(.system(size: 12))
                    Text("\(reactionData.count)")
                        .font(.caption2)
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