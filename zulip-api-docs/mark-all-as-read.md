# Mark All Messages as Read - Zulip API

## Endpoint Overview
- **HTTP Method**: POST
- **URL Path**: `/api/v1/mark_all_as_read`

## Description
Marks all of the current user's unread messages as read. Due to batch processing, the request may time out after marking only some messages.

## Parameters
None

## Response Format
```json
{
    "complete": boolean,
    "msg": string,
    "result": "success"
}
```

### Response Fields
- `complete`: Boolean indicating whether all unread messages were marked as read

## Usage Examples

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc")
result = client.mark_all_as_read()
print(result)
```

### curl
```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/mark_all_as_read \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY
```

## Notes
- Deprecated; recommended to use "update personal message flags for narrow" endpoint
- Messages are marked in batches starting with newest messages
- If request times out, `complete` will be `false`