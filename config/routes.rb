# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :oauth do
    resource :session, only: %i[new create destroy]
    resource :authorization, only: %i[new create]
    post "token", to: "tokens#create"
  end
end