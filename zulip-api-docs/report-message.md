# Report a Message API Endpoint

## Overview
Sends a notification to the organization's moderation request channel to report a message for review.

## Endpoint Details
- **HTTP Method**: POST
- **URL Path**: `/api/v1/messages/{message_id}/report`

## Parameters

### Path Parameters
- `message_id` (integer, required): The target message's ID

### Request Body Parameters
- `report_type` (string, required): Reason for reporting
  - Allowed values: `"spam"`, `"harassment"`, `"inappropriate"`, `"norms"`, `"other"`
- `description` (string, optional): Additional context about the report
  - Maximum 1000 characters
  - Required if `report_type` is `"other"`

## Example Usage

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc")
request = {
    "report_type": "harassment",
    "description": "Boromir is bullying Frodo.",
}
result = client.call_endpoint(f"/messages/{message_id}/report", method="POST", request=request)
```

### curl
```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/messages/43/report \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode report_type=harassment \
     --data-urlencode 'description=Message violates code of conduct.'
```

## Response

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
    "msg": "Moderation request channel must be specified to enable message reporting.",
    "result": "error"
}
```

## Notes
- Requires moderation request channel to be configured
- Added in Zulip 11.0 (feature level 382)