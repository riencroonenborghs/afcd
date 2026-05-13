# frozen_string_literal: true

Doorkeeper.configure do
  orm :active_record

  # Client credentials only — no resource owner (user) needed
  grant_flows %w[client_credentials]

  # No resource owner authentication required for client credentials flow
  skip_authorization { true }

  api_only

  access_token_expires_in 2.hours

  default_scopes :mcp
end
