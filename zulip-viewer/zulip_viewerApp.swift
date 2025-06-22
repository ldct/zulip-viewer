//
//  zulip_viewerApp.swift
//  zulip-viewer
//
//  Created by Li Xuanji on 12/10/24.
//

import SwiftUI

@main
struct zulip_viewerApp: App {
    
    @State private var subscribedChannels: [Stream] = []
    @State private var allChannels: [Stream] = []
    @State private var isAuthenticated = false
    @State private var networkClient = NetworkClient()

    var body: some Scene {
        WindowGroup {
            Group {
                if isAuthenticated {
                    StreamsView(subscribedChannels: subscribedChannels, allChannels: allChannels)
                } else {
                    LoginView(isAuthenticated: $isAuthenticated,
                              subscribedChannels: $subscribedChannels,
                              allChannels: $allChannels)
                }
            }
            .environment(networkClient)
            .task {
                do {
                    try await networkClient.authenticate()
                    subscribedChannels = try await networkClient.getSubscriptions()
                    allChannels = try await networkClient.getAllStreams()
                    
                    // Mark streams as subscribed
                    let subscribedIds = Set(subscribedChannels.map { $0.streamId })
                    allChannels = allChannels.map { stream in
                        var updatedStream = stream
                        updatedStream.isSubscribed = subscribedIds.contains(stream.streamId)
                        return updatedStream
                    }
                    
                    // Update subscribed channels to also have isSubscribed = true
                    subscribedChannels = subscribedChannels.map { stream in
                        var updatedStream = stream
                        updatedStream.isSubscribed = true
                        return updatedStream
                    }
                    
                    isAuthenticated = true
                } catch {
                }
            }
        }
    }
}
