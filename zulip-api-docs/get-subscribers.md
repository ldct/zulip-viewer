# Zulip API: Get Channel Subscribers

## Endpoint Overview
- **HTTP Method**: `GET`
- **URL Path**: `/api/v1/streams/{stream_id}/members`

## Description
Get all users subscribed to a channel.

## Parameters
| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| `stream_id` | integer | Path | Yes | The ID of the channel to access |

## Example Request

### Python
```python
import zulip
client = zulip.Client(config_file="~/zuliprc")
result = client.get_subscribers(stream="python-test")
print(result)
```

### curl
```bash
curl -sSX GET -G https://yourZulipDomain.zulipchat.com/api/v1/streams/1/members \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY
```

## Response Format

### Success Response
```json
{
    "msg": "",
    "result": "success",
    "subscribers": [11, 26]
}
```

### Failure Response
```json
{
    "code": "BAD_REQUEST",
    "msg": "Invalid channel ID",
    "result": "error"
}
```

### Response Fields
- `subscribers`: List of integer user IDs subscribed to the channel

## Key Notes
- Requires authentication
- Returns active user IDs subscribed to the specified channel
- Returns error if channel ID is invalid or access is denied