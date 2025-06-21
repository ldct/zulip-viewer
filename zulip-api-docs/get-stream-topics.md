# Get Topics in a Channel

## Endpoint Details

- **HTTP Method**: GET
- **URL Path**: `/api/v1/users/me/{stream_id}/topics`

## Description

Retrieve all topics a user has access to in a specific channel. For private channels with protected history, users will only see topics from messages sent after subscribing to the channel.

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `stream_id` | integer | Yes | The ID of the channel to access |
| `allow_empty_topic_name` | boolean | No | Whether to support processing empty topic names (default: `false`) |

## Response Format

```json
{
  "topics": [
    {
      "max_id": integer,
      "name": string
    }
  ]
}
```

## Example Usage

### Python
```python
import zulip
client = zulip.Client(config_file="~/zuliprc")
result = client.get_stream_topics(stream_id)
print(result)
```

### JavaScript
```javascript
const zulipInit = require("zulip-js");
const config = { zuliprc: "zuliprc" };

(async () => {
  const client = await zulipInit(config);
  console.log(await client.streams.topics.retrieve({stream_id: 1}));
})();
```

### curl
```bash
curl -sSX GET -G https://yourZulipDomain.zulipchat.com/api/v1/users/me/1/topics \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode allow_empty_topic_name=true
```

## Sample Response
```json
{
  "msg": "",
  "result": "success",
  "topics": [
    {
      "max_id": 26,
      "name": "Denmark3"
    },
    {
      "max_id": 23,
      "name": "Denmark1"
    },
    {
      "max_id": 6,
      "name": "Denmark"
    }
  ]
}
```