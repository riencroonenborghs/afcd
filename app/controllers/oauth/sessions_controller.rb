# frozen_string_literal: true

module Oauth
  class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: []

    def new
      @return_to = params[:return_to]
    end

    def create
      user = User.find_by(email: params[:email]&.downcase)

      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to params[:return_to].presence || root_path
      else
        flash.now[:alert] = "Invalid email or password"
        @return_to = params[:return_to]
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session.delete(:user_id)
      redirect_to new_oauth_session_path
    end
  end
end
