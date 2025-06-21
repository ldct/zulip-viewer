import SwiftUI

struct StreamsView: View {
    let subscribedChannels: [Stream]
    let allChannels: [Stream]
    
    @State private var path = NavigationPath()
    @State private var searchText = ""
    @State private var showingSubscribedOnly = true
    
    var currentChannels: [Stream] {
        showingSubscribedOnly ? subscribedChannels : allChannels
    }
    
    var filteredChannels: [Stream] {
        if searchText.isEmpty {
            return currentChannels
        } else {
            return currentChannels.filter { stream in
                stream.name.localizedCaseInsensitiveContains(searchText) ||
                stream.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // Toggle for subscribed vs all channels
                Picker("Channel View", selection: $showingSubscribedOnly) {
                    Text("Subscribed").tag(true)
                    Text("All Channels").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
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
            .navigationTitle("Channels")
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
        ],
        allChannels: [
            Stream(
                streamId: 458659,
                name: "Equational",
                description: "Coordination for the Equational Project"
            ),
            Stream(
                streamId: 416277,
                name: "FLT",
                description: "Fermat\'s Last Theorem"
            ),
            Stream(
                streamId: 123456,
                name: "General",
                description: "General discussion channel"
            ),
            Stream(
                streamId: 789012,
                name: "Random",
                description: "Random topics and off-topic discussions"
            )
        ]
    )
}
