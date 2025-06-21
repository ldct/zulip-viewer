# Subscribe to a Channel

## Endpoint Details

- **HTTP Method**: POST
- **URL Path**: `/api/v1/users/me/subscriptions`

## Description

Subscribe one or more users to one or more channels. If channels do not exist, they are automatically created. Channel settings can be configured using optional parameters.

## Parameters

### Required Parameters

- **subscriptions** (object[]): List of channels to subscribe to
  - `name` (string, required): Channel name
  - `description` (string, optional): Channel description

### Optional Parameters

- **principals** (string[] | integer[]): Users to subscribe to channels
- **authorization_errors_fatal** (boolean): Handle authorization errors
- **announce** (boolean): Send notification for new channel creation
- **invite_only** (boolean): Create as private channel
- **is_web_public** (boolean): Create as web-public channel
- **history_public_to_subscribers** (boolean): Share channel history

## Example Usage

### Python

```python
import zulip

client = zulip.Client(config_file="~/zuliprc")
result = client.add_subscriptions(
    streams=[{
        "name": "python-test",
        "description": "Channel for testing Python"
    }]
)
```

### JavaScript

```javascript
const zulipInit = require("zulip-js");

const config = { zuliprc: "zuliprc" };
const client = await zulipInit(config);

const params = {
    subscriptions: JSON.stringify([{name: "Verona"}])
};
console.log(await client.users.me.subscriptions.add(params));
```

### curl

```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/users/me/subscriptions \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode 'subscriptions=[{"name": "Verona"}]'
```

## Response Format

```json
{
    "subscribed": {
        "2": ["testing-help"]
    },
    "already_subscribed": {
        "2": []
    },
    "result": "success"
}
```