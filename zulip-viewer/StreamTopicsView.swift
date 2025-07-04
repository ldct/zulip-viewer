import SwiftUI

/// List of topics in a stream
struct StreamTopicsView: View {
    let stream: Stream
    
    @State var topics: [Topic] = []
    @State private var isSubscribed: Bool = false
    @State private var showingError: Bool = false
    @State private var errorMessage: String = ""
    
    @Environment(NetworkClient.self) private var networkClient
    
    var body: some View {
        VStack(alignment: .leading) {
            // Stream header with subscription toggle
            HStack {
                VStack(alignment: .leading) {
                    Text(stream.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    Task {
                        await toggleSubscription()
                    }
                }) {
                    Image(systemName: isSubscribed ? "radiowaves.right" : "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSubscribed ? .blue : .gray)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill((isSubscribed ? Color.blue : Color.gray).opacity(0.1))
                        )
                        .overlay(
                            Circle()
                                .stroke(isSubscribed ? .blue : .gray)
                        )
                }
                .contentTransition(
                    .symbolEffect(.replace)
                )
            }
            .padding()
            
            List {
                ForEach(topics) { topic in
                    NavigationLink(value: WrappedTopic(parentStreamID: stream.streamId, parentStreamName: stream.name, topic: topic), label: {
                        Text("\(topic.name)")
                    })
                }
            }
            .navigationTitle(stream.name)
        }
        .task {
            await loadData()
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func loadData() async {
        do {
            // Load topics
            topics = try await networkClient.getTopics(streamId: stream.streamId)
            
            // Check subscription status - using a placeholder user ID (we'd need to get current user ID in real app)
            // For now, we'll determine subscription status based on the stream.isSubscribed property
            isSubscribed = stream.isSubscribed
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
            showingError = true
        }
    }
    
    private func toggleSubscription() async {
        do {
            if isSubscribed {
                let response = try await networkClient.unsubscribe(from: stream.name)
                if response.result == "success" {
                    withAnimation {
                        isSubscribed = false
                    }
                }
            } else {
                let response = try await networkClient.subscribe(to: stream.name)
                if response.result == "success" {
                    withAnimation {
                        isSubscribed = true
                    }
                }
            }
        } catch {
            errorMessage = "Failed to \(isSubscribed ? "unsubscribe from" : "subscribe to") channel: \(error.localizedDescription)"
            showingError = true
        }
    }
}

