# frozen_string_literal: true

FactoryBot.define do
  factory :oauth_application, class: "Doorkeeper::Application" do
    sequence(:name) { |n| "test-client-#{n}" }
    redirect_uri { "" }
    scopes { "mcp" }
  end
end
