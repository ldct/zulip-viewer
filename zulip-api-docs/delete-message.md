# Delete a Message - Zulip API

## Endpoint Description
This endpoint permanently deletes a message and is only available to organization administrators.

## HTTP Method and URL
`DELETE https://yourZulipDomain.zulipchat.com/api/v1/messages/{message_id}`

## Parameters
| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| message_id | integer | Path | Yes | The target message's ID |

## Usage Examples

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc-admin")
result = client.delete_message(message_id)
print(result)
```

### curl
```bash
curl -sSX DELETE https://yourZulipDomain.zulipchat.com/api/v1/messages/43 \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY
```

## Response Formats

### Success Response
```json
{
    "msg": "",
    "result": "success"
}
```

### Error Responses
#### Message Does Not Exist
```json
{
    "code": "BAD_REQUEST",
    "msg": "Invalid message(s)",
    "result": "error"
}
```

#### Insufficient Permissions
```json
{
    "code": "BAD_REQUEST",
    "msg": "You don't have permission to delete this message",
    "result": "error"
}
```

**Note**: As of Zulip 7.0, successful responses may include an `ignored_parameters_unsupported` array.