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
    @State private var isAuthenticated = false
    @State private var networkClient = NetworkClient()

    var body: some Scene {
        WindowGroup {
            Group {
                if isAuthenticated {
                    StreamsView(subscribedChannels: subscribedChannels)
                } else {
                    LoginView(isAuthenticated: $isAuthenticated,
                              subscribedChannels: $subscribedChannels)
                }
            }
            .environment(networkClient)
            .task {
                do {
                    try await networkClient.authenticate()
                    subscribedChannels = try await networkClient.getSubscriptions()
                    isAuthenticated = true
                } catch {
                }
            }
        }
    }
}
