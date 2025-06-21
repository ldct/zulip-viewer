import SwiftUI

struct ChannelsView: View {
    let subscribedChannels: [Stream]
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("All Channels")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title2)
                    .padding(.top)
                
                List {
                    ForEach(subscribedChannels) { c in
                        NavigationLink(value: c, label: {
                            StreamSummaryView(stream: c)
                        })
                    }
                }
            }
            .navigationDestination(for: Stream.self) { x in
                StreamTopicsView(stream: x)
            }
            .navigationDestination(for: WrappedTopic.self) { x in
                TopicsDetailView(streamId: x.parentStreamID, streamName: x.parentStreamName, topic: x.topic)
            }
            .navigationDestination(for: String.self) {x in
                Text("fallback \(x)")
            }
        }
    }
    
}

#Preview {
    ChannelsView(
        subscribedChannels: [
            Stream(
                streamId: 458659,
                name: "Equational",
                description: "Coordination for the Equational Project"
            ),
            Stream(
                streamId: 416277,
                name: "FLT",
                description: "Fermat\'s Last Theorem"
            )
        ]
    )
}
