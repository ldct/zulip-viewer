# Update Personal Message Flags for Narrow

## Endpoint Details

- **HTTP Method**: POST
- **URL Path**: `/api/v1/messages/flags/narrow`

## Description

Add or remove personal message flags like `read` and `starred` on a range of messages within a narrow.

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `anchor` | string | Yes | Message ID to anchor flag updates. Supports special values: `newest`, `oldest`, `first_unread` |
| `include_anchor` | boolean | No | Whether to include the anchor message (default: `true`) |
| `num_before` | integer | Yes | Number of messages before anchor to update |
| `num_after` | integer | Yes | Number of messages after anchor to update |
| `narrow` | array | Yes | Narrow filter to specify message range |
| `op` | string | Yes | Operation: `add` or `remove` |
| `flag` | string | Yes | Flag to add/remove (e.g., `read`) |

## Example Request

```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/messages/flags/narrow \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode anchor=43 \
     --data-urlencode num_before=4 \
     --data-urlencode num_after=8 \
     --data-urlencode 'narrow=[{"operand": "Denmark", "operator": "channel"}]' \
     --data-urlencode op=add \
     --data-urlencode flag=read
```

## Response Format

```json
{
    "processed_count": integer,
    "updated_count": integer,
    "first_processed_id": integer | null,
    "last_processed_id": integer | null,
    "found_oldest": boolean,
    "found_newest": boolean,
    "ignored_because_not_subscribed_channels": [integer]
}
```

## Notes

- New in Zulip 6.0 (feature level 155)