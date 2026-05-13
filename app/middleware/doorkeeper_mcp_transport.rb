# frozen_string_literal: true

class DoorkeeperMcpTransport < FastMcp::Transports::AuthenticatedRackTransport
  private

  def auth_enabled?
    true
  end

  def valid_token?(token)
    return false if token.blank?

    access_token = Doorkeeper::AccessToken.by_token(token)
    access_token&.acceptable?(nil)
  end
end
