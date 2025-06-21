# Get a Message's Edit History

## Endpoint Details
- **HTTP Method**: `GET`
- **URL Path**: `/api/v1/messages/{message_id}/history`

## Description
Fetch the edit history of a previously edited message. Note that edit history may be disabled in some organizations.

## Parameters
| Name | Type | Required | Description |
|------|------|----------|-------------|
| `message_id` | integer | Yes | The target message's ID |
| `allow_empty_topic_name` | boolean | No | Whether topic names can be empty string (default: false) |

## Response Format
```json
{
  "message_history": [
    {
      "content": "string",
      "rendered_content": "string",
      "timestamp": integer,
      "topic": "string",
      "user_id": integer
    }
  ]
}
```

## Example Usage

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc")
result = client.get_message_history(message_id)
print(result)
```

### curl
```bash
curl -sSX GET -G https://yourZulipDomain.zulipchat.com/api/v1/messages/43/history \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode allow_empty_topic_name=true
```

## Notes
- Edit history may include additional fields like `prev_content`, `prev_topic`, etc.
- The original message snapshot contains minimal fields.