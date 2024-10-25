//
//  ContentView.swift
//  zulip-viewer
//
//  Created by Li Xuanji on 12/10/24.
//

import SwiftUI

struct ChannelsView: View {
    @State var subscribedChannels: [Subscription] = []
    
    var body: some View {
        List {
            ForEach(subscribedChannels) {c in
                VStack(alignment: .leading) {
                    Text("\(c.name)")
                    Text("\(c.streamId)")
                    Text(try! AttributedString(markdown: c.description))
                        .font(.caption)
                }
            }
        }
        .task {
            let c = NetworkClient()
            try! await c.authenticate()
            subscribedChannels = try! await c.getSubscriptions()
        }
    }
    
}

#Preview {
    ChannelsView()
}
