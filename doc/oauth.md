# Setup in Rails console

## 1. Create a user (for the consent screen login)

User.create!(email: "you@example.com", password: "yourpassword", password_confirmation: "yourpassword")

## 2. Create the OAuth application for claude.ai

app = OauthApplication.create!(
  name: "claude.ai",
  redirect_uri: "https://claude.ai/api/mcp/auth_callback"  # use the exact URI claude.ai gives you
)
puts "Client ID:     #{app.client_id}"
puts "Client Secret: #{app.client_secret}"

In claude.ai connector settings:
- Authorization URL: https://your-domain/oauth/authorization/new
- Token URL: https://your-domain/oauth/token
- Client ID / Secret: from the console output above