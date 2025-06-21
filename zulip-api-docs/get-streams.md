# Get All Channels Zulip API Endpoint

## Endpoint Details
- **HTTP Method**: GET
- **URL Path**: `/api/v1/streams`
- **Description**: Get all channels that the user has access to

## Parameters

| Parameter | Type | Optional | Default | Description |
|-----------|------|----------|---------|-------------|
| `include_public` | boolean | Yes | `true` | Include all public channels |
| `include_web_public` | boolean | Yes | `false` | Include all web-public channels |
| `include_subscribed` | boolean | Yes | `true` | Include channels user is subscribed to |
| `exclude_archived` | boolean | Yes | `true` | Exclude archived channels from results |
| `include_all` | boolean | Yes | `false` | Include all channels user has metadata access to |

## Response Format

The response includes an array of channel objects with properties such as:
- `stream_id`: Unique channel ID
- `name`: Channel name
- `is_archived`: Whether channel is archived
- `description`: Channel description
- `invite_only`: Whether channel is private
- `is_web_public`: Whether channel allows unauthenticated web access

## Example Usage

### Python
```python
import zulip
client = zulip.Client(config_file="~/zuliprc")
result = client.get_streams()
print(result)
```

### JavaScript
```javascript
const zulipInit = require("zulip-js");
const config = { zuliprc: "zuliprc" };

(async () => {
    const client = await zulipInit(config);
    console.log(await client.streams.retrieve());
})();
```

### curl
```bash
curl -sSX GET -G https://yourZulipDomain.zulipchat.com/api/v1/streams \
    -u BOT_EMAIL_ADDRESS:BOT_API_KEY
```