# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a native iOS SwiftUI application for viewing Zulip chat streams. The app connects to the Lean Prover Zulip instance at `leanprover.zulipchat.com` and provides a mobile interface for browsing channels (streams), topics, and messages.

## Development Commands

### Building and Running
- Build the project: Open `zulip-viewer.xcodeproj` in Xcode and use Cmd+B to build
- Build via command line: `xcodebuild -project zulip-viewer.xcodeproj -scheme zulip-viewer -destination 'platform=iOS Simulator,name=iPhone 16' build`
- Run the app: Use Cmd+R in Xcode or the iOS Simulator
- Run tests: Use Cmd+U in Xcode to run unit tests and UI tests

### Testing
- Unit tests are located in `zulip-viewerTests/`
- UI tests are located in `zulip-viewerUITests/`
- The project uses Swift Testing framework (not XCTest)

## Architecture

### Core Components

**App Entry Point**: `zulip_viewerApp.swift` - Main app struct that manages authentication state and initial data loading

**Authentication Flow**: 
- `LoginView.swift` - Handles user credential input
- `KeychainManager.swift` - Manages secure storage of credentials and API keys
- Authentication is handled automatically on app launch via stored credentials

**Navigation Structure**:
- `ChannelsView.swift` - Root view showing subscribed streams/channels
- `StreamTopicsView.swift` - Shows topics within a selected stream
- Navigation uses SwiftUI's NavigationStack with typed destinations

**Networking**: 
- `API.swift` - Contains `NetworkClient` class with `@Observable` macro
- Implements Zulip REST API integration
- Handles authentication, stream fetching, topic fetching, and message retrieval
- Uses hardcoded Lean Prover Zulip instance URL

### Data Models

All data models are defined in `API.swift`:
- `Stream` - Represents a Zulip channel/stream
- `Topic` - Represents a topic within a stream  
- `Message` - Represents individual messages
- `WrappedTopic` - Navigation helper for topic routing

### Key Technical Details

- Uses SwiftUI's new `@Observable` macro for state management
- Implements secure credential storage via iOS Keychain
- Network requests use basic HTTP authentication with API keys
- JSON decoding uses snake_case to camelCase conversion
- Navigation leverages SwiftUI's NavigationStack with typed routes

### Project Structure

```
zulip-viewer/
├── zulip_viewerApp.swift          # App entry point
├── API.swift                      # Network client and data models
├── LoginView.swift                # Authentication UI
├── ChannelsView.swift             # Stream list view
├── StreamTopicsView.swift         # Topic list view  
├── StreamSummaryView.swift        # Stream cell component
├── KeychainManager.swift          # Secure storage
└── Assets.xcassets/               # App icons and assets
```

## Development Notes

- Target iOS 18.0+ with Swift 5.0
- Uses Swift Concurrency (async/await) for network operations
- No external dependencies - uses only iOS system frameworks
- Hardcoded to connect to Lean Prover Zulip instance
- Basic HTTP authentication using email and API key