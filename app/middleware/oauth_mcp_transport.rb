# frozen_string_literal: true

require "fast_mcp"

class OauthMcpTransport < FastMcp::Transports::AuthenticatedRackTransport
  private

  def valid_token?(token)
    return false if token.blank?
    OauthAccessToken.valid.exists?(token: token)
  end
end
