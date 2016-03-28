# hubot-super-confluence

A hubot script for searching and browsing Confluence. Very super.

See [`src/super-confluence.coffee`](src/super-confluence.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-super-confluence --save`

Then add **hubot-super-confluence** to your `external-scripts.json`:

```json
[
  "hubot-super-confluence"
]
```

### Configuration:

You'll need to set the following environment variables to get started:

```
HUBOT_CONFLUENCE_USERNAME - Confluence username.
HUBOT_CONFLUENCE_PASSWORD - Confluence password.
HUBOT_CONFLUENCE_HOST - Hostname of the Confluence instance.
HUBOT_CONFLUENCE_CONTEXT (optional) - Often '/wiki', defaults to ''
```

## Sample Interaction

```
user1>> hubot wiki deploy
hubot>> 1 match found (limit: 5)
hubot>> ...
```
