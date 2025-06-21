# Get a Message's Read Receipts

## Endpoint Details

- **HTTP Method**: `GET`
- **URL Path**: `/api/v1/messages/{message_id}/read_receipts`

## Description

Returns a list of user IDs who have marked a specific message as read, subject to privacy settings.

## Parameters

| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| `message_id` | integer | Path | Yes | The target message's ID |

## Response

### Return Values

- `user_ids`: Array of integer user IDs who have read the message

### Response Notes
- Excludes message sender
- Excludes users with `send_read_receipts` disabled
- Excludes muted users

## Example Usage

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc")
result = client.call_endpoint(f"/messages/{message_id}/read_receipts", method="GET")
print(result)
```

### curl
```bash
curl -sSX GET -G https://yourZulipDomain.zulipchat.com/api/v1/messages/43/read_receipts \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY
```

## Response Example

```json
{
    "msg": "",
    "result": "success",
    "user_ids": [3, 7, 9]
}
```

**Note**: Introduced in Zulip 6.0 (feature level 137)