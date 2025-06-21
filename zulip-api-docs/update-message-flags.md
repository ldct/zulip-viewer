# Update Personal Message Flags API

## Endpoint Details

- **HTTP Method**: POST
- **URL Path**: `/api/v1/messages/flags`
- **Description**: Add or remove personal message flags like `read` and `starred` on a collection of message IDs

## Parameters

| Parameter | Type | Required | Description | Allowed Values |
|-----------|------|----------|-------------|----------------|
| `messages` | integer[] | Yes | Message IDs to modify | Example: `[4, 8, 15]` |
| `op` | string | Yes | Operation to perform | `"add"` or `"remove"` |
| `flag` | string | Yes | Flag to modify | Examples: `"read"`, `"starred"` |

## Available Flags

| Flag | Purpose |
|------|---------|
| `read` | Whether user has read the message |
| `starred` | Whether user has starred the message |
| `collapsed` | Whether message is collapsed |
| `mentioned` | Whether user was mentioned |

## Example Usage

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc")

# Add "read" flag
request = {
    "messages": message_ids,
    "op": "add",
    "flag": "read",
}
result = client.update_message_flags(request)
```

### JavaScript
```javascript
const zulipInit = require("zulip-js");

(async () => {
    const client = await zulipInit({ zuliprc: "zuliprc" });
    
    const addflag = {
        messages: message_ids,
        flag: "read",
    };
    console.log(await client.messages.flags.add(addflag));
})();
```

### curl
```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/messages/flags \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode 'messages=[4, 8, 15]' \
     --data-urlencode op=add \
     --data-urlencode flag=read
```