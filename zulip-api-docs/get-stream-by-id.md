# Zulip API: Get a Channel by ID

## Endpoint Overview
- **HTTP Method**: `GET`
- **URL Path**: `/api/v1/streams/{stream_id}`

## Description
Fetch details for the channel with the specified ID.

## Parameters
| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| `stream_id` | integer | Path | Yes | The ID of the channel to access |

## Example Request

### curl
```bash
curl -sSX GET -G https://yourZulipDomain.zulipchat.com/api/v1/streams/1 \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY
```

## Response Format

### Success Response
```json
{
    "msg": "",
    "result": "success",
    "stream": {
        "stream_id": 7,
        "name": "Denmark",
        "invite_only": false,
        "description": "A channel to discuss Denmark",
        "creator_id": 15,
        "is_archived": false,
        "is_web_public": false,
        "can_administer_channel_group": 2,
        "can_add_subscribers_group": 2,
        "can_remove_subscribers_group": 2,
        "can_send_message_group": 2,
        "can_subscribe_group": 2,
        "is_default_stream": false,
        "message_retention_days": null,
        "history_public_to_subscribers": true,
        "first_message_id": null,
        "stream_post_policy": 1,
        "date_created": 1691057093,
        "folder_id": null
    }
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

### Stream Object Fields
- `stream_id`: Unique channel ID
- `name`: Channel name
- `is_archived`: Whether channel is archived
- `description`: Channel description
- `invite_only`: Whether channel is private
- `creator_id`: ID of channel creator
- `is_web_public`: Whether channel is web-public
- `is_default_stream`: Whether channel is a default stream for new users
- `message_retention_days`: Message retention policy
- `history_public_to_subscribers`: Message history visibility setting
- `date_created`: Channel creation timestamp
- Various permission group settings

## Key Notes
- New in Zulip 6.0 (feature level 132)
- Returns detailed channel metadata and configuration
- Requires appropriate permissions to access channel information