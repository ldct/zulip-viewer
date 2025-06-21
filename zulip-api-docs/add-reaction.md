# Add an Emoji Reaction - Zulip API

## Endpoint Details
- **HTTP Method**: POST
- **URL Path**: `/api/v1/messages/{message_id}/reactions`

## Description
Add an emoji reaction to a message.

## Parameters

### Path Parameters
- `message_id` (integer, required): The target message's ID

### Request Parameters
- `emoji_name` (string, required): The target emoji's human-readable name
- `emoji_code` (string, optional): Unique identifier for the specific emoji codepoint
- `reaction_type` (string, optional): Type of emoji (e.g., `unicode_emoji`, `realm_emoji`, `zulip_extra_emoji`)

## Usage Examples

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc")

request = {
    "message_id": message_id,
    "emoji_name": "octopus",
}
result = client.add_reaction(request)
print(result)
```

### curl
```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/messages/43/reactions \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode emoji_name=octopus
```

## Response Format

### Success Response
```json
{
    "msg": "",
    "result": "success"
}
```

### Error Responses
- Invalid emoji code
- Reaction already exists

## Notes
- To find an emoji's name, hover over a message and click the smiley face icon
- Emoji names can be found by hovering over available reaction emojis