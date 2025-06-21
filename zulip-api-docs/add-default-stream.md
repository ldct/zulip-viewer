# Zulip API: Add a Default Channel

## Endpoint Overview
- **HTTP Method**: `POST`
- **URL Path**: `/api/v1/default_streams`

## Description
Add a channel to the set of default channels for new users joining the organization. Only available to organization administrators.

## Parameters
| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| `stream_id` | integer | Body | Yes | The ID of the target channel |

## Example Request

### Python
```python
import zulip
client = zulip.Client(config_file="~/zuliprc-admin")
result = client.add_default_stream(stream_id)
print(result)
```

### curl
```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/default_streams \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode stream_id=10
```

## Response Format

### Success Response
```json
{
    "msg": "",
    "result": "success"
}
```

### Error Response - Invalid Channel ID
```json
{
    "code": "BAD_REQUEST",
    "msg": "Invalid channel ID",
    "result": "error"
}
```

### Error Response - Private Channel
```json
{
    "code": "BAD_REQUEST",
    "msg": "Private channels cannot be made default.",
    "result": "error"
}
```

## Key Notes
- Only available to organization administrators
- Private channels cannot be made default
- Default channels are automatically joined by new users
- As of Zulip 7.0, unsupported parameters are included in an `ignored_parameters_unsupported` array
- Changes affect all future users joining the organization
- Existing users are not automatically subscribed to newly added default channels