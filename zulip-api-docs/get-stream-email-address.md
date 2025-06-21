# Zulip API: Get Channel's Email Address

## Endpoint Overview
- **HTTP Method**: `GET`
- **URL Path**: `/api/v1/streams/{stream_id}/email_address`

## Description
Get the email address for a channel, which can be used to send messages to the channel via email.

## Parameters

### Required Parameters
| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| `stream_id` | integer | Path | Yes | The ID of the channel to access |

### Optional Parameters
| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| `sender_id` | integer | Query | No | The ID of a user or bot to appear as the sender |

### sender_id Options
- Current user's ID
- Email gateway bot ID (default if not specified)
- Bot owned by current user

## Example Request

### curl
```bash
curl -sSX GET -G https://yourZulipDomain.zulipchat.com/api/v1/streams/1/email_address \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     --data-urlencode sender_id=1
```

## Response Format

### Success Response
```json
{
    "email": "test.af64447e9e39374841063747ade8e6b0.show-sender@testserver",
    "msg": "",
    "result": "success"
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

### Response Fields
- `email`: The email address for the channel

## Key Notes
- New in Zulip 8.0 (feature level 226)
- Sender parameter expanded in Zulip 10.0 (feature level 335)
- Email address can be used to post messages to the channel via email
- Useful for integrating external systems that can send emails
- The generated email address is unique and includes security tokens