# Zulip API: Upload a File

## Endpoint Details
- **HTTP Method**: POST
- **URL Path**: `/api/v1/user_uploads`

## Description
Upload a single file and obtain its URL. Initially, only the uploader can access the link. To share, send a message containing the uploaded file's link.

## Parameters
File to upload must be provided in the request body.

## File Upload Constraints
- Maximum file size determined by `max_file_upload_size_mib`
- Large files (25MB+) may fail due to network timeouts
- Resumable uploads supported via `/api/v1/tus` endpoint

## Response Format
```json
{
    "filename": "string",
    "url": "string",
    "result": "success"
}
```

### Response Fields
- `filename`: Stored filename
- `url`: Uploaded file's URL

## Example Usage

### Python
```python
import zulip

client = zulip.Client(config_file="~/zuliprc")

with open(path_to_file, "rb") as fp:
    result = client.upload_file(fp)
```

### cURL
```bash
curl -sSX POST https://yourZulipDomain.zulipchat.com/api/v1/user_uploads \
     -u BOT_EMAIL_ADDRESS:BOT_API_KEY \
     -F filename=@/path/to/file
```