# Zulip API: Get Messages

## Endpoint Overview

**HTTP Method:** `GET`
**URL Path:** `/api/v1/messages`

### Description

The primary endpoint for fetching messages in Zulip. Used by official Zulip clients and API integrations to retrieve messages with various filtering options.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `anchor` | string/integer | Optional | Message ID to anchor fetching. Supports special values like "newest", "oldest", "first_unread" |
| `num_before` | integer | Optional | Number of messages before the anchor to retrieve |
| `num_after` | integer | Optional | Number of messages after the anchor to retrieve |
| `narrow` | array | Optional | Filters to apply when fetching messages |
| `client_gravatar` | boolean | Optional | Whether client supports computing gravatar URLs (default: true) |
| `apply_markdown` | boolean | Optional | Return message content in HTML or raw Markdown (default: true) |

### Example Request (Python)

```python
import zulip

client = zulip.Client(config_file="~/zuliprc")

request = {
    "anchor": "newest",
    "num_before": 100,
    "num_after": 0,
    "narrow": [
        {"operator": "sender", "operand": "iago@zulip.com"},
        {"operator": "channel", "operand": "Verona"},
    ],
}

result = client.get_messages(request)
print(result)
```

### Response Format

The response includes:
- `anchor`: The message ID used as reference
- `found_newest`: Boolean indicating if newest messages are included
- `messages`: Array of message objects with detailed metadata

### Key Message Object Fields

- `id`: Unique message ID
- `content`: Message body
- `sender_email`: Sender's email
- `sender_full_name`: Sender's full name
- `timestamp`: Message send time
- `type`: Message type ("stream" or "private")

### Notes

- Maximum of 5000 messages per request
- Use narrowing to filter messages effectively
- Consider pagination for large message sets