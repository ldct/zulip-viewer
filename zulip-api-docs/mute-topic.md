# Zulip API: Topic Muting (Deprecated)

## Endpoint Overview
- **HTTP Method**: `PATCH`
- **URL Path**: `/api/v1/users/me/subscriptions/muted_topics`

## Description
Mute or unmute a topic within a channel that the current user is subscribed to.

## Deprecation Notice
**Deprecated in Zulip 7.0 (feature level 170).** Use `/api/v1/user_topics` endpoint instead.

## Parameters

### Required Parameters
| Name | Type | Required | Description |
|------|------|----------|-------------|
| `topic` | string | Yes | The topic to (un)mute |
| `op` | string | Yes | Operation type, must be `"add"` or `"remove"` |

### Optional Parameters
| Name | Type | Required | Description |
|------|------|----------|-------------|
| `stream` | string | No | Channel name |
| `stream_id` | integer | No | Channel ID |

**Note**: You must specify either `stream` or `stream_id`.

## Example Request

### Python
```python
request = {
    "stream": "Denmark",
    "topic": "boat party",
    "op": "add",
}
result = client.mute_topic(request)
```

### curl
```bash
curl -sSX PATCH https://yourZulipDomain.zulipchat.com/api/v1/users/me/subscriptions/muted_topics \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode stream=Denmark \
     --data-urlencode topic=dinner \
     --data-urlencode op=add
```

## Response Format
```json
{
    "msg": "",
    "result": "success"
}
```

## Key Notes
- **DEPRECATED**: Use the `/api/v1/user_topics` endpoint instead
- Operation `"add"` mutes the topic
- Operation `"remove"` unmutes the topic
- Only affects the current user's topic preferences
- User must be subscribed to the channel containing the topic