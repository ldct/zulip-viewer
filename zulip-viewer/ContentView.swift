//
//  ContentView.swift
//  zulip-viewer
//
//  Created by Li Xuanji on 12/10/24.
//

import SwiftUI

struct StreamSummaryView: View {
    let stream: Stream
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(stream.name)")
            Text("\(stream.streamId)")
            Text(try! AttributedString(markdown: stream.description))
                .font(.caption)
        }
    }
}


struct StreamDetailsView: View {
    let stream: Stream
    
    @State var topics: [Topic] = []
    
    @EnvironmentObject private var networkClient: NetworkClient
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(stream.name)")
            List {
                ForEach(topics) { topic in
                    NavigationLink(value: topic.name, label: {
                        Text(topic.name)
                    })
                }
            }
        }
        .task {
            topics = try! await networkClient.getTopics(streamId: stream.streamId)
        }
    }
}

struct ChannelsView: View {
    let subscribedChannels: [Stream]
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(subscribedChannels) {c in
                    NavigationLink(value: c, label: {
                        StreamSummaryView(stream: c)
                    })
                }
            }
            .navigationDestination(for: Stream.self) { x in
                StreamDetailsView(stream: x)
            }
            .navigationDestination(for: String.self) {x in
                Text(x)
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
