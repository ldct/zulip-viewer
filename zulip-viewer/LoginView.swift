import SwiftUI

/// A view that prompts the user to enter their Zulip credentials and logs in.
struct LoginView: View {
    @Environment(NetworkClient.self) private var networkClient
    @Binding var isAuthenticated: Bool
    @Binding var subscribedChannels: [Stream]
    @Binding var allChannels: [Stream]

    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Credentials")) {
                    TextField("Username (email)", text: $username)
                        .textContentType(.username)
                        .autocapitalization(.none)

                    SecureField("Password", text: $password)
                        .textContentType(.password)
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }

                Section {
                    Button {
                        login()
                    } label: {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Log In")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .disabled(username.isEmpty || password.isEmpty || isLoading)
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Zulip Login")
        }
    }

    private func login() {
        errorMessage = nil
        isLoading = true
        Task {
            do {
                try await networkClient.login(username: username, password: password)
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
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    LoginView(isAuthenticated: .constant(false),
              subscribedChannels: .constant([]),
              allChannels: .constant([]))
        .environment(NetworkClient())
}