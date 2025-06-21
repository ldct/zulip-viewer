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
                    VStack(alignment: .leading) {
                        Text("\(message.senderFullName)")
                            .bold()
                            .padding(.bottom, 2)
                        HTMLText(html: message.content)
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

@available(iOS 15, *)
struct HTMLText: View {
    let html: String
    
    var body: some View {
        let attrS = try! AttributedString(markdown: html)
        Text(attrS)
    }
}