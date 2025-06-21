# Zulip API: Render a Message

## Endpoint Details
- **HTTP Method**: POST
- **URL Path**: `/api/v1/messages/render`
- **Description**: Render a message to HTML

## Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `content` | string | Yes | The content of the message to render |

## Response Format

```json
{
    "msg": "",
    "rendered": "<rendered HTML>",
    "result": "success"
}
```

### Response Fields
- `rendered`: Rendered HTML content of the message

## Example Usage

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc")
request = {
    "content": "**foo**",
}
result = client.render_message(request)
print(result)
```

### JavaScript
```javascript
const zulipInit = require("zulip-js");
const config = { zuliprc: "zuliprc" };

(async () => {
    const client = await zulipInit(config);
    const params = {
        content: "**foo**",
    };
    console.log(await client.messages.render(params));
})();
```

### curl
```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/messages/render \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode content=Hello
```