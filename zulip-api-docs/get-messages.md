GET https://yourZulipDomain.zulipchat.com/api/v1/messages/{message_id}

Given a message ID, return the message object.

Additionally, a raw_content field is included. This field is useful for clients that primarily work with HTML-rendered messages but might need to occasionally fetch the message's raw Markdown (e.g. for view source or prefilling a message edit textarea).

Changes: Before Zulip 5.0 (feature level 120), this endpoint only returned the raw_content field.

Python curl
#!/usr/bin/env python3

import zulip

# Pass the path to your zuliprc file here.
client = zulip.Client(config_file="~/zuliprc")

# Get the raw content of a message given the message's ID.
result = client.get_raw_message(message_id)
print(result)
message_id integer required in path 

Example: 43
The target message's ID.

apply_markdown boolean optional 

Example: false
If true, message content is returned in the rendered HTML format. If false, message content is returned in the raw Markdown-format text that user entered.

Changes: New in Zulip 5.0 (feature level 120).

Defaults to true.

allow_empty_topic_name boolean optional 

Example: true
Whether the client supports processing the empty string as a topic in the topic name fields in the returned data, including in returned edit_history data.

If false, the server will use the value of realm_empty_topic_display_name found in the POST /register response instead of empty string to represent the empty string topic in its response.

Changes: New in Zulip 10.0 (feature level 334). Previously, the empty string was not a valid topic.

Defaults to false.

Return values
raw_content: string

The raw Markdown content of the message.

Deprecated and to be removed once no longer required for legacy clients. Modern clients should prefer passing "apply_markdown": false to request raw message content.

message: object

An object containing details of the message.

Changes: New in Zulip 5.0 (feature level 120).

avatar_url: string | null

The URL of the message sender's avatar. Can be null only if the current user has access to the sender's real email address and client_gravatar was true.

If null, then the sender has not uploaded an avatar in Zulip, and the client can compute the gravatar URL by hashing the sender's email address, which corresponds in this case to their real email address.

Changes: Before Zulip 7.0 (feature level 163), access to a user's real email address was a realm-level setting. As of this feature level, email_address_visibility is a user setting.

client: string

A Zulip "client" string, describing what Zulip client sent the message.

content: string

The content/body of the message.

content_type: string

The HTTP content_type for the message content. This will be text/html or text/x-markdown, depending on whether apply_markdown was set.

display_recipient: string | (object)[]

Data on the recipient of the message; either the name of a channel or a dictionary containing basic data on the users who received the message.

edit_history: (object)[]

An array of objects, with each object documenting the changes in a previous edit made to the message, ordered chronologically from most recent to least recent edit.

Not present if the message has never been edited or moved, or if viewing message edit history is not allowed in the organization.

Every object will contain user_id and timestamp.

The other fields are optional, and will be present or not depending on whether the channel, topic, and/or message content were modified in the edit event. For example, if only the topic was edited, only prev_topic and topic will be present in addition to user_id and timestamp.

Changes: In Zulip 10.0 (feature level 284), removed the prev_rendered_content_version field as it is an internal server implementation detail not used by any client.

prev_content: string

Only present if message's content was edited.

The content of the message immediately prior to this edit event.

prev_rendered_content: string

Only present if message's content was edited.

The rendered HTML representation of prev_content.

prev_stream: integer

Only present if message's channel was edited.

The channel ID of the message immediately prior to this edit event.

Changes: New in Zulip 3.0 (feature level 1).

prev_topic: string

Only present if message's topic was edited.

The topic of the message immediately prior to this edit event.

Changes: New in Zulip 5.0 (feature level 118). Previously, this field was called prev_subject; clients are recommended to rename prev_subject to prev_topic if present for compatibility with older Zulip servers.

stream: integer

Only present if message's channel was edited.

The ID of the channel containing the message immediately after this edit event.

Changes: New in Zulip 5.0 (feature level 118).

timestamp: integer

The UNIX timestamp for the edit.

topic: string

Only present if message's topic was edited.

The topic of the message immediately after this edit event.

Changes: New in Zulip 5.0 (feature level 118).

user_id: integer | null

The ID of the user that made the edit.

Will be null only for edit history events predating March 2017.

Clients can display edit history events where this is null as modified by either the sender (for content edits) or an unknown user (for topic edits).

id: integer

The unique message ID. Messages should always be displayed sorted by ID.

is_me_message: boolean

Whether the message is a /me status message

last_edit_timestamp: integer

The UNIX timestamp for when the message's content was last edited, in UTC seconds.

Not present if the message's content has never been edited.

Clients should use this field, rather than parsing the edit_history array, to display an indicator that the message has been edited.

Changes: Prior to Zulip 10.0 (feature level 365), this was the time when the message was last edited or moved.

last_moved_timestamp: integer

The UNIX timestamp for when the message was last moved to a different channel or topic, in UTC seconds.

Not present if the message has never been moved, or if the only topic moves for the message are resolving or unresolving the message's topic.

Clients should use this field, rather than parsing the edit_history array, to display an indicator that the message has been moved.

Changes: New in Zulip 10.0 (feature level 365). Previously, parsing the edit_history array was required in order to correctly display moved message indicators.

reactions: (object)[]

Data on any reactions to the message.

emoji_name: string

Name of the emoji.

emoji_code: string

A unique identifier, defining the specific emoji codepoint requested, within the namespace of the reaction_type.

reaction_type: string

A string indicating the type of emoji. Each emoji reaction_type has an independent namespace for values of emoji_code.

Must be one of the following values:

unicode_emoji : In this namespace, emoji_code will be a dash-separated hex encoding of the sequence of Unicode codepoints that define this emoji in the Unicode specification.

realm_emoji : In this namespace, emoji_code will be the ID of the uploaded custom emoji.

zulip_extra_emoji : These are special emoji included with Zulip. In this namespace, emoji_code will be the name of the emoji (e.g. "zulip").

user_id: integer

The ID of the user who added the reaction.

Changes: New in Zulip 3.0 (feature level 2). The user object is deprecated and will be removed in the future.

In Zulip 10.0 (feature level 328), the deprecated user object was removed which contained the following properties: id, email, full_name and is_mirror_dummy.

recipient_id: integer

A unique ID for the set of users receiving the message (either a channel or group of users). Useful primarily for hashing.

Changes: Before Zulip 10.0 (feature level 327), recipient_id was the same across all incoming 1:1 direct messages. Now, each incoming message uniquely shares a recipient_id with outgoing messages in the same conversation.

sender_email: string

The Zulip API email address of the message's sender.

sender_full_name: string

The full name of the message's sender.

sender_id: integer

The user ID of the message's sender.

sender_realm_str: string

A string identifier for the realm the sender is in. Unique only within the context of a given Zulip server.

E.g. on example.zulip.com, this will be example.

stream_id: integer

Only present for channel messages; the ID of the channel.

subject: string

The topic of the message. Currently always "" for direct messages, though this could change if Zulip adds support for topics in direct message conversations.

The field name is a legacy holdover from when topics were called "subjects" and will eventually change.

For clients that don't support the empty_topic_name client capability, the empty string value is replaced with the value of realm_empty_topic_display_name found in the POST /register response, for channel messages.

Changes: Before Zulip 10.0 (feature level 334), empty_topic_name client capability didn't exist and empty string as the topic name for channel messages wasn't allowed.

submessages: (object)[]

Data used for certain experimental Zulip integrations.

msg_type: string

The type of the message.

content: string

The new content of the submessage.

message_id: integer

The ID of the message to which the submessage has been added.

sender_id: integer

The ID of the user who sent the message.

id: integer

The ID of the submessage.

timestamp: integer

The UNIX timestamp for when the message was sent, in UTC seconds.

topic_links: (object)[]

Data on any links to be included in the topic line (these are generated by custom linkification filters that match content in the message's topic.)

Changes: This field contained a list of urls before Zulip 4.0 (feature level 46).

New in Zulip 3.0 (feature level 1). Previously, this field was called subject_links; clients are recommended to rename subject_links to topic_links if present for compatibility with older Zulip servers.

text: string

The original link text present in the topic.

url: string

The expanded target url which the link points to.

type: string

The type of the message: "stream" or "private".

flags: (string)[]

The user's message flags for the message.

Changes: In Zulip 8.0 (feature level 224), the wildcard_mentioned flag was deprecated in favor of the stream_wildcard_mentioned and topic_wildcard_mentioned flags. The wildcard_mentioned flag exists for backwards compatibility with older clients and equals stream_wildcard_mentioned || topic_wildcard_mentioned. Clients supporting older server versions should treat this field as a previous name for the stream_wildcard_mentioned flag as topic wildcard mentions were not available prior to this feature level.

Example response(s)
Changes: As of Zulip 7.0 (feature level 167), if any parameters sent in the request are not supported by this endpoint, a successful JSON response will include an ignored_parameters_unsupported array.

A typical successful JSON response may look like:

{
    "message": {
        "avatar_url": "https://secure.gravatar.com/avatar/6d8cad0fd00256e7b40691d27ddfd466?d=identicon&version=1",
        "client": "ZulipDataImport",
        "content": "<p>Security experts agree that relational algorithms are an interesting new topic in the field of networking, and scholars concur.</p>",
        "content_type": "text/html",
        "display_recipient": [
            {
                "email": "hamlet@zulip.com",
                "full_name": "King Hamlet",
                "id": 4,
                "is_mirror_dummy": false
            },
            {
                "email": "iago@zulip.com",
                "full_name": "Iago",
                "id": 5,
                "is_mirror_dummy": false
            },
            {
                "email": "prospero@zulip.com",
                "full_name": "Prospero from The Tempest",
                "id": 8,
                "is_mirror_dummy": false
            }
        ],
        "flags": [
            "read"
        ],
        "id": 16,
        "is_me_message": false,
        "reactions": [],
        "recipient_id": 27,
        "sender_email": "hamlet@zulip.com",
        "sender_full_name": "King Hamlet",
        "sender_id": 4,
        "sender_realm_str": "zulip",
        "subject": "",
        "submessages": [],
        "timestamp": 1527921326,
        "topic_links": [],
        "type": "private"
    },
    "msg": "",
    "raw_content": "**Don't** forget your towel!",
    "result": "success"
}
An example JSON response for when the specified message does not exist or it is not visible to the user making the query (e.g. it was a direct message between two other users):

{
    "code": "BAD_REQUEST",
    "msg": "Invalid message(s)",
    "result": "error"
}

