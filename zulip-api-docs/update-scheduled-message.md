# Edit a Scheduled Message - Zulip API

## Endpoint Details

- **HTTP Method**: `PATCH`
- **URL Path**: `/api/v1/scheduled_messages/{scheduled_message_id}`

## Description

Edit an existing scheduled message in Zulip. Available in Zulip 7.0 (feature level 184).

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `scheduled_message_id` | integer | Yes | ID of the scheduled message to update |
| `type` | string | No | Message type: `"direct"`, `"channel"`, `"stream"`, `"private"` |
| `to` | integer/array | Conditional | Target channel ID or user IDs |
| `content` | string | No | Updated message content |
| `topic` | string | Conditional | Updated message topic (required for channel messages) |
| `scheduled_delivery_timestamp` | integer | Conditional | UNIX timestamp for message delivery |

## Example Request

```bash
curl -sSX PATCH https://yourZulipDomain.zulipchat.com/api/v1/scheduled_messages/2 \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode type=stream \
     --data-urlencode to=11 \
     --data-urlencode content=Hello \
     --data-urlencode topic=Castle \
     --data-urlencode scheduled_delivery_timestamp=3165826990
```

## Response

### Success Response
```json
{
    "msg": "",
    "result": "success"
}
```

### Error Response Examples
```json
{
    "code": "STREAM_DOES_NOT_EXIST",
    "msg": "Channel with ID '9' does not exist",
    "result": "error"
}
```