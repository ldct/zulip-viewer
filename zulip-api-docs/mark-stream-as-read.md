# Mark Messages in a Channel as Read

## Endpoint Details

- **HTTP Method**: POST
- **URL Path**: `/api/v1/mark_stream_as_read`
- **Description**: Mark all unread messages in a channel as read

## Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `stream_id` | integer | Yes | The ID of the channel to mark as read |

## Usage Examples

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc")
result = client.mark_stream_as_read(stream_id)
print(result)
```

### curl
```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/mark_stream_as_read \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode stream_id=43
```

## Response Format

```json
{
    "msg": "",
    "result": "success"
}
```

## Notes
- **Deprecation Warning**: This endpoint is deprecated. Clients should use the "update personal message flags for narrow" endpoint instead.
- Will be removed in a future release