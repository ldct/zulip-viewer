# Delete a Scheduled Message - Zulip API

## Endpoint Details

- **HTTP Method**: `DELETE`
- **URL Path**: `/api/v1/scheduled_messages/{scheduled_message_id}`

## Description

Delete and cancel a previously scheduled message in Zulip.

## Parameters

| Parameter | Type | Location | Required | Description |
|-----------|------|----------|----------|-------------|
| `scheduled_message_id` | integer | Path | Yes | The ID of the scheduled message to delete |

## Example Request

```bash
curl -sSX DELETE https://yourZulipDomain.zulipchat.com/api/v1/scheduled_messages/1 \
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

### Error Response
```json
{
    "code": "BAD_REQUEST",
    "msg": "Scheduled message does not exist",
    "result": "error"
}
```

## Notes

- New in Zulip 7.0 (feature level 173)
- The `scheduled_message_id` is different from the message's unique ID after sending