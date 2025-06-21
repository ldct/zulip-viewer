# Zulip API: Create a Channel

## Endpoint Overview
- **HTTP Method**: `POST`
- **URL Path**: `/api/v1/users/me/subscriptions` (via subscribe endpoint)

## Description
Create a new channel by submitting a subscribe request with a channel name that doesn't already exist. Channels are created automatically when subscribing to non-existent channel names.

## Parameters

### Required Parameters
| Name | Type | Required | Description |
|------|------|----------|-------------|
| `subscriptions` | array | Yes | List of channels to subscribe to/create |

### Optional Parameters (for new channels)
| Name | Type | Description |
|------|------|-------------|
| `invite_only` | boolean | Whether the channel should be private (default: false) |
| `is_web_public` | boolean | Whether the channel should be web-public |
| `is_default_stream` | boolean | Whether to add as default channel for new users |
| `history_public_to_subscribers` | boolean | Message history access for new subscribers |
| `message_retention_days` | integer/string | Message retention policy |
| `announce` | boolean | Whether to announce the new channel |

### Channel Description
- Use the `description` key in the subscription object to set the channel description

## Example Request

### Python
```python
import zulip
client = zulip.Client(config_file="~/zuliprc")

# Create a new public channel
result = client.subscribe(
    streams=[
        {
            'name': 'New Channel Name',
            'description': 'Description of the new channel'
        }
    ],
    invite_only=False
)
```

### curl
```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/users/me/subscriptions \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode 'subscriptions=[{"name": "New Channel", "description": "A new channel for discussions"}]' \
     --data-urlencode 'invite_only=false'
```

## Response Format
```json
{
    "already_subscribed": {},
    "subscribed": {
        "user@example.com": ["New Channel"]
    },
    "msg": "",
    "result": "success"
}
```

## Key Notes
- Channels are created via the subscribe endpoint when the channel name doesn't exist
- The user creating the channel becomes the channel creator and administrator
- Channel settings are determined by the optional parameters provided
- Private channels require `invite_only=true`
- Web-public channels require server and organization configuration
- Maximum channel name length is determined by server settings