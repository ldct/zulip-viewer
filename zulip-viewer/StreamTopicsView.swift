import SwiftUI

/// List of topics in a stream
struct StreamTopicsView: View {
    let stream: Stream
    
    @State var topics: [Topic] = []
    
    @Environment(NetworkClient.self) private var networkClient
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(stream.name)")
                .frame(maxWidth: .infinity, alignment: .center)
            List {
                ForEach(topics) { topic in
                    NavigationLink(value: WrappedTopic(parentStreamID: stream.streamId, parentStreamName: stream.name, topic: topic), label: {
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

