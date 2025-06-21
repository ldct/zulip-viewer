//
//  zulip_viewerApp.swift
//  zulip-viewer
//
//  Created by Li Xuanji on 12/10/24.
//

import SwiftUI

@main
struct zulip_viewerApp: App {
    
    @State var subscribedChannels: [Stream] = []
    
    let networkClient = NetworkClient()

    var body: some Scene {
        WindowGroup {
            ChannelsView(subscribedChannels: subscribedChannels)
                .environmentObject(networkClient)
                .task {
//                    _ = try? KeychainManager.storePassword()
                    try! await networkClient.authenticate()
                    subscribedChannels = try! await networkClient.getSubscriptions()
                }
        }
    }
}
