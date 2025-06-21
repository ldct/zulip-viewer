# Zulip API: Delete a Topic

## Endpoint Overview
- **HTTP Method**: `POST`
- **URL Path**: `/api/v1/streams/{stream_id}/delete_topic`

## Description
Deletes all messages in a specified topic. Deleting messages effectively removes the topic from Zulip. Only available to organization administrators.

## Parameters
| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| `stream_id` | integer | Path | Yes | ID of the channel containing the topic |
| `topic_name` | string | Body | Yes | Name of the topic to delete |

## Example Request

### Python
```python
client = zulip.Client(config_file="~/zuliprc-admin")
request = {
    "topic_name": topic,
}
result = client.call_endpoint(
    url=f"/streams/{stream_id}/delete_topic", 
    method="POST", 
    request=request
)
```

### curl
```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/streams/1/delete_topic \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode 'topic_name=new coffee machine'
```

## Response Format
```json
{
    "complete": true,
    "msg": "",
    "result": "success"
}
```

### Response Fields
- `complete`: Boolean indicating if all messages were deleted successfully

## Key Notes
- Only available to organization administrators
- Deletion happens in batches to prevent timeout issues
- If request times out, `complete` will be `false`
- Clients should retry if `complete` is `false`
- Permanently removes all messages in the topic
- This action cannot be undone
- Use with extreme caution as it affects all users in the channel