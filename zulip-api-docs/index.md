# Zulip API Documentation Index

This directory contains comprehensive documentation for all Zulip API endpoints, converted from the official documentation at https://zulip.com/api/.

## Messages API Endpoints (Completed: 19/19)

- [Send a Message](send-message.md) - POST `/api/v1/messages`
- [Upload a File](upload-file.md) - POST `/api/v1/user_uploads`
- [Update/Edit a Message](update-message.md) - PATCH `/api/v1/messages/{message_id}`
- [Delete a Message](delete-message.md) - DELETE `/api/v1/messages/{message_id}`
- [Get Messages](get-messages.md) - GET `/api/v1/messages`
- [Construct a Narrow](construct-narrow.md) - Narrow construction for message filtering
- [Add Emoji Reaction](add-reaction.md) - POST `/api/v1/messages/{message_id}/reactions`
- [Remove Emoji Reaction](remove-reaction.md) - DELETE `/api/v1/messages/{message_id}/reactions`
- [Render a Message](render-message.md) - POST `/api/v1/messages/render`
- [Get a Single Message](get-message.md) - GET `/api/v1/messages/{message_id}`
- [Check Messages Match Narrow](check-messages-match-narrow.md) - GET `/api/v1/messages/matches_narrow`
- [Get Message History](get-message-history.md) - GET `/api/v1/messages/{message_id}/history`
- [Update Message Flags](update-message-flags.md) - POST `/api/v1/messages/flags`
- [Update Message Flags for Narrow](update-message-flags-for-narrow.md) - POST `/api/v1/messages/flags/narrow`
- [Mark All as Read](mark-all-as-read.md) - POST `/api/v1/mark_all_as_read`
- [Mark Stream as Read](mark-stream-as-read.md) - POST `/api/v1/mark_stream_as_read`
- [Mark Topic as Read](mark-topic-as-read.md) - POST `/api/v1/mark_topic_as_read`
- [Get Read Receipts](get-read-receipts.md) - GET `/api/v1/messages/{message_id}/read_receipts`
- [Report a Message](report-message.md) - POST `/api/v1/messages/{message_id}/report`

## Scheduled Messages API Endpoints (Completed: 4/4)

- [Get Scheduled Messages](get-scheduled-messages.md) - GET `/api/v1/scheduled_messages`
- [Create Scheduled Message](create-scheduled-message.md) - POST `/api/v1/scheduled_messages`
- [Update Scheduled Message](update-scheduled-message.md) - PATCH `/api/v1/scheduled_messages/{scheduled_message_id}`
- [Delete Scheduled Message](delete-scheduled-message.md) - DELETE `/api/v1/scheduled_messages/{scheduled_message_id}`

## Message Reminders/Drafts API Endpoints (Pending: 0/5)

- Create Message Reminder - [TODO]
- Get Drafts - [TODO]
- Create Drafts - [TODO]
- Edit Draft - [TODO]
- Delete Draft - [TODO]

## Channels/Streams API Endpoints (Pending: 0/17)

- Get Subscriptions - [TODO]
- Subscribe to Channels - [TODO]
- Unsubscribe from Channels - [TODO]
- Get Subscription Status - [TODO]
- Get Channel Subscribers - [TODO]
- Update Subscription Settings - [TODO]
- Get All Channels - [TODO]
- Get Channel by ID - [TODO]
- Get Channel ID - [TODO]
- Create a Channel - [TODO]
- Update a Channel - [TODO]
- Archive a Channel - [TODO]
- Get Channel Email Address - [TODO]
- Get Channel Topics - [TODO]
- Mute a Topic - [TODO]
- Update User Topic Settings - [TODO]
- Delete a Topic - [TODO]

## Users API Endpoints (Pending: 0/23+)

- Get User - [TODO]
- Get User by Email - [TODO]
- Get Own User - [TODO]
- Get All Users - [TODO]
- Create User - [TODO]
- Update User - [TODO]
- Deactivate User - [TODO]
- Get User Status - [TODO]
- Update User Status - [TODO]
- Get User Groups - [TODO]
- Create User Group - [TODO]
- Update User Group - [TODO]
- Deactivate User Group - [TODO]
- Update User Group Members - [TODO]
- Update User Group Subgroups - [TODO]
- Get User Group Membership Status - [TODO]
- Get User Group Members - [TODO]
- Get User Group Subgroups - [TODO]
- Mute User - [TODO]
- Unmute User - [TODO]
- Get Alert Words - [TODO]
- Add Alert Words - [TODO]
- Remove Alert Words - [TODO]

## Real-time Events API Endpoints (Pending: 0/4)

- Real-time Events API Overview - [TODO]
- Register Event Queue - [TODO]
- Get Events from Queue - [TODO]
- Delete Event Queue - [TODO]

## Server & Organization Settings API Endpoints (Pending: 0/18+)

- Get Server Settings - [TODO]
- Get Linkifiers - [TODO]
- Add Linkifier - [TODO]
- Update Linkifier - [TODO]
- Remove Linkifier - [TODO]
- Reorder Linkifiers - [TODO]
- Add Code Playground - [TODO]
- Remove Code Playground - [TODO]
- Get Custom Emoji - [TODO]
- Upload Custom Emoji - [TODO]
- Deactivate Custom Emoji - [TODO]
- Get Custom Profile Fields - [TODO]
- Reorder Custom Profile Fields - [TODO]
- Create Custom Profile Field - [TODO]
- Update Realm User Settings Defaults - [TODO]
- Get Data Exports - [TODO]
- Create Data Export - [TODO]
- Get Data Export Consent State - [TODO]

## Invitations API Endpoints (Pending: 0/6)

- Get Invitations - [TODO]
- Send Invitations - [TODO]
- Create Reusable Invitation Link - [TODO]
- Resend Email Invitation - [TODO]
- Revoke Email Invitation - [TODO]
- Revoke Reusable Invitation Link - [TODO]

## Specialty API Endpoints (Pending: 0/8)

- Fetch API Key (Production) - [TODO]
- Fetch API Key (Development) - [TODO]
- Send Test Notification - [TODO]
- Add APNs Device Token - [TODO]
- Remove APNs Device Token - [TODO]
- Add FCM Registration Token - [TODO]
- Remove FCM Registration Token - [TODO]
- Create BigBlueButton Video Call - [TODO]

---

## Progress Summary

- **Completed**: 23 endpoints
- **Pending**: 60+ endpoints
- **Total Estimated**: 90+ endpoints

Last updated: 2025-06-21