# Zulip API: Get Subscription Status

## Endpoint Overview
- **HTTP Method**: `GET`
- **URL Path**: `/api/v1/users/{user_id}/subscriptions/{stream_id}`

## Description
Check whether a user is subscribed to a channel.

## Parameters
| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| `user_id` | integer | Path | Yes | The target user's ID |
| `stream_id` | integer | Path | Yes | The ID of the channel to access |

## Example Request

### Python
```python
import zulip
client = zulip.Client(config_file="~/zuliprc")
result = client.call_endpoint(
    url=f"/users/{user_id}/subscriptions/{stream_id}",
    method="GET"
)
```

### curl
```bash
curl -sSX GET -G https://yourZulipDomain.zulipchat.com/api/v1/users/12/subscriptions/1 \
    -u BOT_EMAIL_ADDRESS:BOT_API_KEY
```

## Response Format
```json
{
    "is_subscribed": false,
    "msg": "",
    "result": "success"
}
```

### Response Fields
- `is_subscribed`: boolean indicating whether the user is subscribed to the channel
- `msg`: message string
- `result`: status of the API call

## Key Notes
- Introduced in Zulip 3.0 (feature level 12)
- Requires authentication
- Returns subscription status for a specific user and channel combination