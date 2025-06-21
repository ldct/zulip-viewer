# Send a Message - Zulip API

## Endpoint Details
- **HTTP Method**: `POST`
- **URL Path**: `/api/v1/messages`
- **Description**: Send a channel message or direct message

## Parameters

### Required Parameters
- `type` (string): Message type
  - Options: `"direct"`, `"channel"`, `"stream"`, `"private"`
  - Example: `"direct"`

- `to` (string/integer/array): Recipient channel or user IDs
  - For channel messages: Channel name or ID
  - For direct messages: List of user IDs or email addresses
  - Example: `[9, 10]`

- `content` (string): Message text
  - Example: `"Hello"`

### Optional Parameters
- `topic` (string): Channel message topic
  - Only required for channel messages
  - Example: `"Castle"`

- `queue_id` (string): Event queue ID for local echo
- `local_id` (string): Client-side message identifier
- `read_by_sender` (boolean): Mark message as read by sender

## Response Format
```json
{
    "id": 42,
    "msg": "",
    "result": "success"
}
```

## Example Usage

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc")

# Channel message
request = {
    "type": "stream",
    "to": "Denmark",
    "topic": "Castle",
    "content": "Message content"
}
result = client.send_message(request)

# Direct message
request = {
    "type": "direct",
    "to": [user_id],
    "content": "Direct message content"
}
result = client.send_message(request)
```

### curl
```bash
curl -X POST https://yourZulipDomain.zulipchat.com/api/v1/messages \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode type=stream \
     --data-urlencode 'to="Denmark"' \
     --data-urlencode 'topic="Castle"' \
     --data-urlencode 'content="Message content"'
```