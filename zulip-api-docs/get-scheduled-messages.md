# Get Scheduled Messages API

## Endpoint Details

- **HTTP Method**: `GET`
- **URL Path**: `/api/v1/scheduled_messages`
- **Description**: Fetch all scheduled messages for the current user

## Usage Example

```bash
curl -sSX GET -G https://yourZulipDomain.zulipchat.com/api/v1/scheduled_messages \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY
```

## Parameters

This endpoint does not accept any parameters.

## Response Format

### Scheduled Message Object

- `scheduled_message_id` (integer): Unique ID of the scheduled message
- `type` (string): Message type (`"stream"` or `"private"`)
- `to` (integer or integer array): Target audience (channel ID or user IDs)
- `topic` (string, optional): Channel message topic
- `content` (string): Message body in text/markdown
- `rendered_content` (string): Message body in HTML
- `scheduled_delivery_timestamp` (integer): UNIX timestamp for message delivery
- `failed` (boolean): Whether message sending previously failed

## Example Response

```json
{
    "result": "success",
    "msg": "",
    "scheduled_messages": [
        {
            "content": "Hi",
            "failed": false,
            "rendered_content": "<p>Hi</p>",
            "scheduled_delivery_timestamp": 1681662420,
            "scheduled_message_id": 27,
            "to": 14,
            "topic": "Introduction",
            "type": "stream"
        }
    ]
}
```

**Note**: Introduced in Zulip 7.0 (feature level 173)