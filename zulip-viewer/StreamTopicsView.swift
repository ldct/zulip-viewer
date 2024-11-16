import SwiftUI

/// List of topics in a stream
struct StreamTopicsView: View {
    let stream: Stream
    
    @State var topics: [Topic] = []
    
    @EnvironmentObject private var networkClient: NetworkClient
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(stream.name)")
            List {
                ForEach(topics) { topic in
                    NavigationLink(value: topic, label: {
                        Text("\(topic.name) (?)")
                    })
                }
            }
        }
        .task {
            topics = try! await networkClient.getTopics(streamId: stream.streamId)
        }
    }
}

/// Detail view of a topic
struct TopicsDetailView: View {
    let topic: Topic
    
    @EnvironmentObject private var networkClient: NetworkClient
    
    @State var messages = [Message]()
    
    var body: some View {
        List {
            Text(topic.name)
            ForEach(messages) { message in
                HTMLText(html: message.content)
            }
        }
            .task {
                let narrowResponse = try! await networkClient.getNarrow(anchor: topic.maxId, topicName: topic.name)
                print(narrowResponse.messages)
                messages = narrowResponse.messages
            }
    }
}

@available(iOS 15, *)
struct HTMLText: View {
    let html: String
    
    var body: some View {
        if let nsAttributedString = try? NSAttributedString(data: Data(html.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil),
           let attributedString = try? AttributedString(nsAttributedString, including: \.uiKit) {
            Text(attributedString)
        } else {
            // fallback...
            Text(html)
        }
    }
}
