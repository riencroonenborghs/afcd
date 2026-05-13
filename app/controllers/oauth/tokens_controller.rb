# frozen_string_literal: true

module Oauth
  class TokensController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      case params[:grant_type]
      when "authorization_code"
        handle_authorization_code
      else
        render json: { error: "unsupported_grant_type" }, status: :bad_request
      end
    end

    private

    def handle_authorization_code
      application = authenticate_application
      return unless application

      auth_code = OauthAuthorizationCode.valid.find_by(
        code: params[:code],
        oauth_application: application
      )

      unless auth_code
        render json: { error: "invalid_grant" }, status: :bad_request
        return
      end

      unless application.redirect_uri_valid?(params[:redirect_uri])
        render json: { error: "invalid_grant" }, status: :bad_request
        return
      end

      auth_code.consume!

      token = OauthAccessToken.create!(
        user: auth_code.user,
        oauth_application: application
      )

      render json: {
        access_token: token.token,
        token_type: "Bearer",
        expires_in: token.expires_at ? (token.expires_at - Time.current).to_i : nil
      }
    end

    def authenticate_application
      client_id = params[:client_id]
      client_secret = params[:client_secret]

      # Also support HTTP Basic Auth
      if client_id.blank? && request.headers["Authorization"]&.start_with?("Basic ")
        decoded = Base64.decode64(request.headers["Authorization"].delete_prefix("Basic "))
        client_id, client_secret = decoded.split(":", 2)
      end

      application = OauthApplication.find_by(client_id: client_id)

      unless application && ActiveSupport::SecurityUtils.secure_compare(application.client_secret, client_secret.to_s)
        render json: { error: "invalid_client" }, status: :unauthorized
        return nil
      end

      application
    end
  end
end
