# Get Subscribed Channels Zulip API Endpoint

## Endpoint Details
- **Method**: `GET`
- **URL**: `https://yourZulipDomain.zulipchat.com/api/v1/users/me/subscriptions`

## Description
Get all channels that the current user is subscribed to.

## Parameters
- **include_subscribers** (optional, boolean)
  - Default: `false`
  - Whether to include a list of subscriber user IDs for each channel
  - Example: `true`

## Usage Examples

### Python
```python
import zulip
client = zulip.Client(config_file="~/zuliprc")
result = client.get_subscriptions()
print(result)
```

### JavaScript
```javascript
const zulipInit = require("zulip-js");
const config = { zuliprc: "zuliprc" };

(async () => {
    const client = await zulipInit(config);
    console.log(await client.streams.subscriptions.retrieve());
})();
```

### curl
```bash
curl -sSX GET -G https://yourZulipDomain.zulipchat.com/api/v1/users/me/subscriptions \
    -u BOT_EMAIL_ADDRESS:BOT_API_KEY
```

## Response Format
A JSON object containing:
- `subscriptions`: List of channel subscription objects
  - Each object includes details like:
    - `stream_id`
    - `name`
    - `description`
    - `invite_only`
    - `is_muted`
    - And many other channel-specific settings

## Example Response
```json
{
    "result": "success",
    "msg": "",
    "subscriptions": [
        {
            "name": "Denmark",
            "stream_id": 1,
            "invite_only": false,
            "is_muted": false
        }
    ]
}
```