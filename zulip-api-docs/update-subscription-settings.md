# Zulip API: Update Subscription Settings

## Endpoint Overview
- **HTTP Method**: `POST`
- **URL Path**: `/api/v1/users/me/subscriptions/properties`

## Description
Update user's personal settings for subscribed channels, including muting, color, pinning, and per-channel notification settings.

## Parameters

### Required Parameters
- `subscription_data` (array of objects): Configuration data for subscription updates

### subscription_data Object Structure
Each object in the array must contain:
- `stream_id` (integer, required): Unique channel ID
- `property` (string, required): Channel property to modify
- `value` (boolean or string, required): New property value

### Allowed Properties
- `"color"`: Channel color (hex string)
- `"is_muted"`: Mute/unmute channel (boolean)
- `"pin_to_top"`: Pin channel to top (boolean)
- `"desktop_notifications"`: Desktop notification setting (boolean)
- `"audible_notifications"`: Audible notification setting (boolean)
- `"push_notifications"`: Push notification setting (boolean)
- `"email_notifications"`: Email notification setting (boolean)
- `"wildcard_mentions_notify"`: Wildcard mention notifications (boolean)

## Example Request

### Python
```python
request = [
    {
        "stream_id": stream_a_id,
        "property": "pin_to_top",
        "value": True,
    },
    {
        "stream_id": stream_b_id,
        "property": "color",
        "value": "#f00f00",
    },
]
result = client.update_subscription_settings(request)
```

### curl
```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/users/me/subscriptions/properties \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode 'subscription_data=[{"property": "pin_to_top", "stream_id": 1, "value": true}, {"property": "color", "stream_id": 3, "value": "#f00f00"}]'
```

## Response Format
```json
{
    "ignored_parameters_unsupported": [
        "invalid_param_1",
        "invalid_param_2"
    ],
    "msg": "",
    "result": "success"
}
```

## Key Notes
- Allows batch updates of multiple subscription properties
- Unsupported parameters are ignored and listed in response
- Changes are applied immediately to the user's subscription settings
- Only affects the current user's personal settings, not global channel settings