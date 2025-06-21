.PHONY: open build test clean

open:
	open zulip-viewer.xcodeproj

build:
	xcodebuild -project zulip-viewer.xcodeproj -scheme zulip-viewer -destination 'platform=iOS Simulator,name=iPhone 16' build

test:
	xcodebuild -project zulip-viewer.xcodeproj -scheme zulip-viewer -destination 'platform=iOS Simulator,name=iPhone 16' test

clean:
	xcodebuild -project zulip-viewer.xcodeproj -scheme zulip-viewer clean