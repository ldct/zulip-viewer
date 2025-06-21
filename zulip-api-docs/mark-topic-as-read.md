# Mark Messages in a Topic as Read

## Endpoint Details

- **HTTP Method**: POST
- **URL Path**: `/api/v1/mark_topic_as_read`
- **Description**: Mark all unread messages in a specific topic as read

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `stream_id` | integer | Yes | The ID of the channel to access |
| `topic_name` | string | Yes | The name of the topic whose messages should be marked as read |

## Usage Examples

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc")
result = client.mark_topic_as_read(stream_id, topic_name)
print(result)
```

### curl
```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/mark_topic_as_read \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode stream_id=43 \
     --data-urlencode 'topic_name=new coffee machine'
```

## Response Format

```json
{
    "msg": "",
    "result": "success"
}
```

## Notes
- Deprecated; recommended to use "update personal message flags for narrow" endpoint
- Empty topic names are supported in Zulip 10.0+ (feature level 334)