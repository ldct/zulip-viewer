# Zulip API: Update Personal Topic Preferences

## Endpoint Overview
- **HTTP Method**: `POST`
- **URL Path**: `/api/v1/user_topics`

## Description
Updates personal preferences for a specific topic in a channel, such as muting, unmuting, or following the topic.

## Parameters

### Required Parameters
| Name | Type | Required | Description |
|------|------|----------|-------------|
| `stream_id` | integer | Yes | The ID of the channel |
| `topic` | string | Yes | The topic to update preferences for |
| `visibility_policy` | integer | Yes | Controls topic visibility policy |

### Visibility Policy Values
| Value | Description |
|-------|-------------|
| `0` | None (remove previous policy) |
| `1` | Muted |
| `2` | Unmuted |
| `3` | Followed |

## Example Request

### Python
```python
request = {
    "stream_id": stream_id,
    "topic": "dinner",
    "visibility_policy": 1,
}
result = client.call_endpoint(
    url="user_topics",
    method="POST",
    request=request
)
```

### curl
```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/user_topics \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode stream_id=1 \
     --data-urlencode topic=dinner \
     --data-urlencode visibility_policy=1
```

## Response Format
```json
{
    "msg": "",
    "result": "success"
}
```

## Key Notes
- New in Zulip 7.0 (feature level 170)
- Replaces the deprecated topic muting mechanism
- Supports more granular topic preferences beyond just muting
- Only affects the current user's topic preferences
- Following topics provides enhanced notifications
- Unmuting overrides channel-level muting for specific topics