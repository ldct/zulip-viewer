# Fetch a Single Message Zulip API Endpoint

## Overview
Retrieve a specific message by its unique ID from Zulip.

## Endpoint Details
- **HTTP Method**: GET
- **URL Path**: `/api/v1/messages/{message_id}`

## Parameters

### Path Parameters
- `message_id` (integer, required): The unique ID of the message to fetch

### Query Parameters
- `apply_markdown` (boolean, optional):
  - Default: `true`
  - Controls message content rendering format
  - `true`: Returns HTML-rendered content
  - `false`: Returns raw Markdown text

- `allow_empty_topic_name` (boolean, optional):
  - Default: `false`
  - Determines handling of empty topic names

## Usage Examples

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc")
result = client.get_raw_message(message_id)
print(result)
```

### curl
```bash
curl -sSX GET -G https://yourZulipDomain.zulipchat.com/api/v1/messages/43 \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode apply_markdown=false \
     --data-urlencode allow_empty_topic_name=true
```

## Response Format
A JSON object containing:
- `message`: Detailed message object
- `raw_content`: Raw Markdown content of the message

## Response Example
```json
{
    "message": {
        "id": 16,
        "content": "<p>Message content</p>",
        "sender_email": "user@example.com",
        "timestamp": 1527921326
    },
    "raw_content": "**Message** content",
    "result": "success"
}
```