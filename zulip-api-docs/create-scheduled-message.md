# Create a Scheduled Message - Zulip API

## Endpoint Details

- **HTTP Method**: `POST`
- **URL Path**: `/api/v1/scheduled_messages`

## Description

Create a new scheduled message in Zulip that will be sent at a specified future time.

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `type` | string | Yes | Message type: `"direct"`, `"channel"`, `"stream"`, or `"private"` |
| `to` | integer or integer[] | Yes | Channel ID or list of user IDs to send message to |
| `content` | string | Yes | Message text content |
| `topic` | string | Conditional | Required for channel messages, ignored for direct messages |
| `scheduled_delivery_timestamp` | integer | Yes | UNIX timestamp for message delivery (UTC seconds) |
| `read_by_sender` | boolean | No | Whether message is initially marked read by sender |

## Example Usage

### Channel Message
```bash
curl -X POST https://yourZulipDomain.zulipchat.com/api/v1/scheduled_messages \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode type=stream \
     --data-urlencode to=9 \
     --data-urlencode topic=Hello \
     --data-urlencode 'content=Nice to meet everyone!' \
     --data-urlencode scheduled_delivery_timestamp=3165826990
```

### Direct Message
```bash
curl -X POST https://yourZulipDomain.zulipchat.com/api/v1/messages \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode type=direct \
     --data-urlencode 'to=[9, 10]' \
     --data-urlencode 'content=Can we meet on Monday?' \
     --data-urlencode scheduled_delivery_timestamp=3165826990
```

## Response

Successful Response:
```json
{
    "msg": "",
    "result": "success",
    "scheduled_message_id": 42
}
```