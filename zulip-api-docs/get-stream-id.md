# Zulip API: Get Channel ID

## Endpoint Overview
- **HTTP Method**: `GET`
- **URL Path**: `/api/v1/get_stream_id`

## Description
Retrieve the unique ID of a specified channel by name.

## Parameters
| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| `stream` | string | Query | Yes | Name of the channel to access (e.g., "Denmark") |

## Example Request

### Python
```python
import zulip
client = zulip.Client(config_file="~/zuliprc")
result = client.get_stream_id(name)
```

### JavaScript
```javascript
const zulipInit = require("zulip-js");
const config = { zuliprc: "zuliprc" };
const client = await zulipInit(config);
console.log(await client.streams.getStreamId("Denmark"));
```

### curl
```bash
curl -sSX GET -G https://yourZulipDomain.zulipchat.com/api/v1/get_stream_id \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode stream=Denmark
```

## Response Format

### Success Response
```json
{
    "msg": "",
    "result": "success",
    "stream_id": 15
}
```

### Error Response
```json
{
    "code": "BAD_REQUEST",
    "msg": "Invalid channel name 'nonexistent'",
    "result": "error"
}
```

### Response Fields
- `stream_id`: integer (The ID of the specified channel)

## Key Notes
- Useful for converting channel names to IDs for other API calls
- Channel names are case-sensitive
- Returns error if channel doesn't exist or user lacks access
- Essential for API calls that require stream_id parameter