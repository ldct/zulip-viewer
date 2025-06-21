# Check if Messages Match a Narrow

## Endpoint Overview
- **HTTP Method**: GET
- **URL Path**: `/api/v1/messages/matches_narrow`

## Description
Check whether a set of messages match a specific narrow (filter). Designed to help clients efficiently determine if a message belongs in a particular view.

## Parameters

### Required Parameters
- `msg_ids` (integer[]): List of message IDs to check
  - Example: `[31, 32]`

- `narrow` (object[]): Structure defining the narrow to check
  - Example: `[{"operator": "has", "operand": "link"}]`

## Response Format

### Response Object
- `messages`: Dictionary of matching messages
  - Key: Message ID
  - Value: 
    - `match_content`: HTML content matching the narrow
    - `match_subject`: HTML-escaped topic matching the narrow

## Example Usage

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc")

request = {
    "msg_ids": msg_ids,
    "narrow": [{"operator": "has", "operand": "link"}],
}
result = client.call_endpoint(url="messages/matches_narrow", method="GET", request=request)
print(result)
```

### cURL
```bash
curl -sSX GET -G https://yourZulipDomain.zulipchat.com/api/v1/messages/matches_narrow \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode 'msg_ids=[31, 32]' \
     --data-urlencode 'narrow=[{"operand": "link", "operator": "has"}]'
```

## Example Response
```json
{
    "messages": {
        "31": {
            "match_content": "<p><a href=\"http://foo.com\" target=\"_blank\" title=\"http://foo.com\">http://foo.com</a></p>",
            "match_subject": "test_topic"
        }
    },
    "msg": "",
    "result": "success"
}
```