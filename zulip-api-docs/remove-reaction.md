# Remove an Emoji Reaction - Zulip API

## Endpoint Details

- **HTTP Method**: `DELETE`
- **URL Path**: `/api/v1/messages/{message_id}/reactions`

## Description

Remove an emoji reaction from a message.

## Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `message_id` | integer | Yes | The target message's ID |
| `emoji_name` | string | No | The target emoji's human-readable name |
| `emoji_code` | string | No | Unique identifier for the specific emoji codepoint |
| `reaction_type` | string | No | Type of emoji (e.g., `unicode_emoji`, `realm_emoji`, `zulip_extra_emoji`) |

## Example Usage

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc")

request = {
    "message_id": message_id,
    "emoji_name": "octopus",
}
result = client.remove_reaction(request)
print(result)
```

### curl
```bash
curl -sSX DELETE https://yourZulipDomain.zulipchat.com/api/v1/messages/43/reactions \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode emoji_name=octopus
```

## Response

Successful Response:
```json
{
    "msg": "",
    "result": "success"
}
```

Possible Error Responses:
- Invalid emoji code
- Reaction does not exist