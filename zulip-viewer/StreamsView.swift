import SwiftUI

struct StreamsView: View {
    let subscribedChannels: [Stream]
    
    @State private var path = NavigationPath()
    @State private var searchText = ""
    
    var filteredChannels: [Stream] {
        if searchText.isEmpty {
            return subscribedChannels
        } else {
            return subscribedChannels.filter { stream in
                stream.name.localizedCaseInsensitiveContains(searchText) ||
                stream.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List {
                    ForEach(filteredChannels) { c in
                        NavigationLink(value: c, label: {
                            StreamSummaryView(stream: c)
                        })
                    }
                }
                .searchable(text: $searchText, prompt: "Search channels")
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
    StreamsView(
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
