# Zulip API: Archive a Channel

## Endpoint Overview
- **HTTP Method**: `DELETE`
- **URL Path**: `/api/v1/streams/{stream_id}`

## Description
Archive a Zulip channel by providing its stream ID. Only available to organization administrators.

## Parameters
| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| `stream_id` | integer | Path | Yes | The ID of the channel to archive |

## Example Request

### Python
```python
import zulip
client = zulip.Client(config_file="~/zuliprc-admin")
result = client.delete_stream(stream_id)
print(result)
```

### curl
```bash
curl -sSX DELETE https://yourZulipDomain.zulipchat.com/api/v1/streams/1 \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY
```

## Response Format

### Success Response
```json
{
    "msg": "",
    "result": "success"
}
```

### Error Response (Invalid Channel)
```json
{
    "code": "BAD_REQUEST",
    "msg": "Invalid channel ID",
    "result": "error"
}
```

## Key Notes
- Only available to organization administrators
- Archived channels are no longer accessible to regular users
- Channel data is preserved but hidden from the interface
- Archiving is typically irreversible through the API
- As of Zulip 7.0, successful responses may include an `ignored_parameters_unsupported` array
- Use with caution as this affects all channel members