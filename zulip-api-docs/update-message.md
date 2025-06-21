# Edit a Message - Zulip API

## Endpoint Details

- **HTTP Method**: `PATCH`
- **URL Path**: `/api/v1/messages/{message_id}`

## Description

Update the content, topic, or channel of a specific message by its ID. Users can modify messages based on organization settings and permissions.

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `message_id` | integer | Yes | Target message's unique ID |
| `topic` | string | No | New topic for the message |
| `propagate_mode` | string | No | Determines which messages to edit:<br>- `"change_one"` (default): Only target message<br>- `"change_later"`: Target message and following messages<br>- `"change_all"`: All messages in the topic |
| `content` | string | No | Updated message content |
| `stream_id` | integer | No | Channel ID to move the message |

## Example Usage (Python)

```python
import zulip

client = zulip.Client(config_file="~/zuliprc")

request = {
    "message_id": message_id,
    "content": "New content",
}

result = client.update_message(request)
print(result)
```

## Response Format

Successful responses include:
- `msg`: Confirmation message
- `result`: `"success"`
- Optional `detached_uploads`: Information about uploaded files

## Potential Error Responses

- Permission denied
- Time limit exceeded for message editing
- Wildcard mention restrictions

## Notes

- Message editing is governed by realm settings
- Some edits may require administrative permissions
- Time limits and topic resolution have specific rules