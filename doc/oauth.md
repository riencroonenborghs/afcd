# OAuth Authentication

The MCP endpoint is protected with OAuth 2.0 using the [client credentials grant](https://datatracker.ietf.org/doc/html/rfc6749#section-4.4). Clients exchange a client ID and secret for a short-lived Bearer token, then use that token on every MCP request.

There is no user login or redirect flow — this is machine-to-machine auth only.

## Flow

```
Client                          Server
  |                               |
  |  POST /oauth/token            |
  |  client_id + client_secret    |
  |------------------------------>|
  |                               |
  |  { access_token, expires_in } |
  |<------------------------------|
  |                               |
  |  GET /mcp/sse                 |
  |  Authorization: Bearer <token>|
  |------------------------------>|
  |                               |
  |  SSE stream                   |
  |<------------------------------|
```

Tokens expire after **2 hours**. Request a new one before or after expiry — old tokens are rejected immediately upon revocation or expiry.

## Setting up a new client

Open a Rails console on the server:

```bash
bundle exec rails console
```

Create an application — this generates the client ID (`uid`) and secret:

```ruby
app = Doorkeeper::Application.create!(
  name: "my-client",
  scopes: "mcp"
)

puts "client_id:     #{app.uid}"
puts "client_secret: #{app.secret}"
```

Store both values securely. The secret cannot be retrieved again after this point.

## Requesting a token

```bash
curl -X POST https://your-server/oauth/token \
  -d "grant_type=client_credentials" \
  -d "client_id=<client_id>" \
  -d "client_secret=<client_secret>" \
  -d "scope=mcp"
```

Response:

```json
{
  "access_token": "abc123...",
  "token_type": "Bearer",
  "expires_in": 7200,
  "scope": "mcp",
  "created_at": 1234567890
}
```

## Using the token

Pass the token as a Bearer header on all MCP requests:

```bash
curl -N https://your-server/mcp/sse \
  -H "Authorization: Bearer <access_token>" \
  -H "Accept: text/event-stream"
```

### Claude Desktop

```json
"mcpServers": {
  "afcd": {
    "command": "/path/to/node",
    "args": [
      "/path/to/mcp-remote/dist/proxy.js",
      "https://your-server/mcp/sse",
      "--header",
      "Authorization: Bearer <access_token>"
    ]
  }
}
```

## Revoking a client

```ruby
Doorkeeper::Application.find_by(name: "my-client").destroy
```

This immediately invalidates all tokens issued to that application.
