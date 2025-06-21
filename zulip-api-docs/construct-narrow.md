# Construct a Narrow in Zulip API

## Overview

A narrow is a set of filters for Zulip messages based on various factors like sender, channel, topic, and search keywords.

## Narrow Encoding Example

### Query
```
channel:announce -sender:iago@zulip.com cool sunglasses
```

### JSON Encoded Narrow
```json
[
    {
        "operator": "channel",
        "operand": "announce"
    },
    {
        "operator": "sender", 
        "operand": "iago@zulip.com",
        "negated": true
    },
    {
        "operator": "search",
        "operand": "cool sunglasses"
    }
]
```

## Supported Narrow Operators

### Message ID Operators
- `id:12345`: Search for specific message by ID
- `with:12345`: Search for conversation containing message

### Channel and User ID Operators
- `channel:1234`: Search messages in channel with ID 1234
- `sender:1234`: Search messages from user ID 1234
- `dm:1234`: Direct message conversation with user ID 1234
- `dm:1234,5678`: Direct message conversation with multiple users
- `dm-including:1234`: All direct messages including you and user 1234

## Key Notes
- Many narrows search the current user's personal message history
- `is:unread` filter uses a database index for optimization
- Empty topic names are supported in recent Zulip versions

## Recent Changes
- Added `is:muted` operator in Zulip 10.0
- Added `with`, `has:reaction`, and `is:followed` filters in Zulip 9.0
- Updated direct message search operators in Zulip 7.0