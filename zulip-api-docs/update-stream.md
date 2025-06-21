# Zulip API: Update a Channel

## Endpoint Overview
- **HTTP Method**: `PATCH`
- **URL Path**: `/api/v1/streams/{stream_id}`

## Description
Configure a channel with the specified stream_id. Supports organization administrators editing channel properties including name, description, permissions, privacy settings, and posting policies.

## Parameters

### Required Parameters
| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| `stream_id` | integer | Path | Yes | The ID of the channel to modify |

### Optional Parameters
| Name | Type | Description |
|------|------|-------------|
| `description` | string | New channel description |
| `new_name` | string | New channel name |
| `is_private` | boolean | Change channel privacy |
| `is_web_public` | boolean | Make channel web-public |
| `history_public_to_subscribers` | boolean | Control message history visibility |
| `is_default_stream` | boolean | Add/remove as default channel |
| `message_retention_days` | string/integer | Set message retention policy |
| `is_archived` | boolean | Archive/unarchive channel |
| `folder_id` | integer/null | Set channel folder |

### Permission Group Settings
- `can_add_subscribers_group`: Control who can add subscribers
- `can_remove_subscribers_group`: Control who can remove subscribers  
- `can_administer_channel_group`: Control who can administer the channel
- `can_send_message_group`: Control who can send messages
- `can_subscribe_group`: Control who can subscribe to the channel

## Example Request

### Python
```python
client = zulip.Client(config_file="~/zuliprc")
request = {
    "stream_id": stream_id,
    "is_private": True,
}
result = client.update_stream(request)
```

### curl
```bash
curl -sSX PATCH https://yourZulipDomain.zulipchat.com/api/v1/streams/1 \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode 'description=Discuss Italian history and travel destinations.' \
     --data-urlencode new_name=Italy \
     --data-urlencode is_private=true
```

## Response Format
```json
{
    "msg": "",
    "result": "success"
}
```

## Key Notes
- Only available to organization administrators
- Changes take effect immediately
- Some changes (like privacy settings) may have restrictions
- Supports batch updates of multiple channel properties
- Permission changes affect all channel members