# Unsubscribe from a Channel - Zulip API

## Endpoint Details

- **HTTP Method**: DELETE
- **URL Path**: `/api/v1/users/me/subscriptions`

## Description

Unsubscribe yourself or other users from one or more channels. Supports unsubscribing in three scenarios:
- Organization administrators can remove any user from any channel
- Users can remove bots they own from accessible channels
- Users can unsubscribe users from channels with specific group permissions

## Parameters

### Required
- **subscriptions** (string[]): List of channel names to unsubscribe from
  - Example: `["Verona", "Denmark"]`

### Optional
- **principals** (string[] or integer[]): Users to unsubscribe
  - Example: `["ZOE@zulip.com"]`
  - Can use user IDs or email addresses

## Response Format

```json
{
    "not_removed": [],  // Channels already unsubscribed
    "removed": [],      // Channels successfully unsubscribed
    "result": "success"
}
```

## Example Usage

### Python
```python
import zulip
client = zulip.Client(config_file="~/zuliprc")

# Unsubscribe from channel
result = client.remove_subscriptions(["python-test"])

# Unsubscribe another user
result = client.remove_subscriptions(
    ["python-test"],
    principals=["newbie@zulip.com"]
)
```

### curl
```bash
curl -X DELETE https://yourZulipDomain.zulipchat.com/api/v1/users/me/subscriptions \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode 'subscriptions=["Verona", "Denmark"]'
```