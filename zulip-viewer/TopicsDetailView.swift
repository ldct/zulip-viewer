import SwiftUI
import WebKit

/// Detail view of a topic
struct TopicsDetailView: View {
    let streamId: Int
    let streamName: String
    let topic: Topic
    
    @Environment(NetworkClient.self) private var networkClient
    
    @State var messages = [Message]()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(streamName) > \(topic.name)")
                .frame(maxWidth: .infinity, alignment: .center)

            List {
                ForEach(messages) { message in
                    HStack(alignment: .top) {
                        AsyncImage(url: message.avatarUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            HStack {
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
                            .padding(.bottom, 2)
                            HTMLText(html: message.content)
                            
                            if !message.reactions.isEmpty {
                                EmojiReactionsView(reactions: message.reactions)
                                    .padding(.top, 4)
                            }
                        }
                    }
                }
            }
        }
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

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
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
