import SwiftUI
import WebKit

/// List of topics in a stream
struct StreamTopicsView: View {
    let stream: Stream
    
    @State var topics: [Topic] = []
    
    @Environment(NetworkClient.self) private var networkClient
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(stream.name)")
            List {
                ForEach(topics) { topic in
                    NavigationLink(value: WrappedTopic(parentStreamID: stream.streamId, topic: topic), label: {
                        Text("\(topic.name)")
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
    let streamId: Int
    let topic: Topic
    
    @Environment(NetworkClient.self) private var networkClient
    
    @State var messages = [Message]()
    
    var body: some View {
        List {
            Text(topic.name)
            ForEach(messages) { message in
                VStack(alignment: .leading) {
                    Text("\(message.senderFullName)")
                        .bold()
                        .padding(.bottom, 2)
                    HTMLText(html: message.content)
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

@available(iOS 15, *)
struct HTMLText: View {
    let html: String
    
    var body: some View {
        let attrS = try! AttributedString(markdown: html)
        Text(attrS)
    }
}
