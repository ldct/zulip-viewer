# Zulip API: Remove a Default Channel

## Endpoint Overview
- **HTTP Method**: `DELETE`
- **URL Path**: `/api/v1/default_streams`

## Description
Remove a channel from the set of default channels for new users joining the organization. Only available to organization administrators.

## Parameters
| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| `stream_id` | integer | Body | Yes | The ID of the target channel to remove |

## Example Request

### Python
```python
import zulip
client = zulip.Client(config_file="~/zuliprc-admin")
request = {"stream_id": stream_id}
result = client.call_endpoint(
    url="/default_streams",
    method="DELETE",
    request=request
)
```

### curl
```bash
curl -sSX DELETE https://yourZulipDomain.zulipchat.com/api/v1/default_streams \
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

### Error Response
```json
{
    "code": "BAD_REQUEST",
    "msg": "Invalid channel ID",
    "result": "error"
}
```

## Key Notes
- Only available to organization administrators
- Removes channel from the default set for new users
- Existing users who joined via default channels remain subscribed
- As of Zulip 7.0, successful responses may include an `ignored_parameters_unsupported` array
- Changes only affect future users joining the organization
- Channel continues to exist and function normally after removal from defaults