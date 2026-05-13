# frozen_string_literal: true

module Oauth
  class AuthorizationsController < ApplicationController
    before_action :require_login

    def new
      @application = OauthApplication.find_by(client_id: params[:client_id])

      unless @application
        render plain: "Unknown client_id", status: :bad_request
        return
      end

      unless @application.redirect_uri_valid?(params[:redirect_uri])
        render plain: "Invalid redirect_uri", status: :bad_request
        return
      end

      @state = params[:state]
      @redirect_uri = params[:redirect_uri]
    end

    def create
      application = OauthApplication.find_by(client_id: params[:client_id])

      unless application
        render plain: "Unknown client_id", status: :bad_request
        return
      end

      unless application.redirect_uri_valid?(params[:redirect_uri])
        render plain: "Invalid redirect_uri", status: :bad_request
        return
      end

      if params[:approve]
        auth_code = OauthAuthorizationCode.create!(
          user: current_user,
          oauth_application: application
        )

        redirect_target = "#{params[:redirect_uri]}?code=#{auth_code.code}"
        redirect_target += "&state=#{params[:state]}" if params[:state].present?
        redirect_to redirect_target, allow_other_host: true
      else
        redirect_target = "#{params[:redirect_uri]}?error=access_denied"
        redirect_target += "&state=#{params[:state]}" if params[:state].present?
        redirect_to redirect_target, allow_other_host: true
      end
    end

    private

    def require_login
      return if current_user

      return_to = request.fullpath
      redirect_to new_oauth_session_path(return_to: return_to)
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
end
