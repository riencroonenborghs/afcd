# frozen_string_literal: true

require "rails_helper"

RSpec.describe "OAuth client credentials", type: :request do
  let(:application) { create(:oauth_application) }

  describe "POST /oauth/token" do
    context "with valid client credentials" do
      it "returns an access token" do
        post "/oauth/token", params: {
          grant_type: "client_credentials",
          client_id: application.uid,
          client_secret: application.secret,
          scope: "mcp"
        }

        expect(response).to have_http_status(:ok)
        body = response.parsed_body
        expect(body["access_token"]).to be_present
        expect(body["token_type"]).to eq("Bearer")
        expect(body["expires_in"]).to eq(7200)
        expect(body["scope"]).to eq("mcp")
      end
    end

    context "with wrong client secret" do
      it "returns unauthorized" do
        post "/oauth/token", params: {
          grant_type: "client_credentials",
          client_id: application.uid,
          client_secret: "wrong-secret",
          scope: "mcp"
        }

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error"]).to eq("invalid_client")
      end
    end

    context "with unknown client id" do
      it "returns unauthorized" do
        post "/oauth/token", params: {
          grant_type: "client_credentials",
          client_id: "nonexistent",
          client_secret: "irrelevant",
          scope: "mcp"
        }

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error"]).to eq("invalid_client")
      end
    end

    context "with wrong grant type" do
      it "returns unsupported grant type error" do
        post "/oauth/token", params: {
          grant_type: "authorization_code",
          client_id: application.uid,
          client_secret: application.secret
        }

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body["error"]).to eq("unsupported_grant_type")
      end
    end
  end

  describe "MCP endpoint authentication" do
    let(:token) do
      Doorkeeper::AccessToken.create!(
        application: application,
        expires_in: 2.hours,
        scopes: "mcp"
      ).token
    end

    describe "POST /mcp/messages" do
      it "rejects requests with no token" do
        post "/mcp/messages", params: { jsonrpc: "2.0", method: "tools/list", id: 1 }.to_json,
          headers: { "Content-Type" => "application/json" }

        expect(response).to have_http_status(:unauthorized)
      end

      it "rejects requests with an invalid token" do
        post "/mcp/messages", params: { jsonrpc: "2.0", method: "tools/list", id: 1 }.to_json,
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer invalid-token"
          }

        expect(response).to have_http_status(:unauthorized)
      end

      it "allows requests with a valid token" do
        post "/mcp/messages", params: { jsonrpc: "2.0", method: "tools/list", id: 1 }.to_json,
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{token}"
          }

        expect(response).not_to have_http_status(:unauthorized)
      end
    end

    describe "GET /mcp/sse" do
      it "rejects requests with no token" do
        get "/mcp/sse", headers: { "Accept" => "text/event-stream" }

        expect(response).to have_http_status(:unauthorized)
      end

      it "rejects requests with an invalid token" do
        get "/mcp/sse", headers: {
          "Accept" => "text/event-stream",
          "Authorization" => "Bearer invalid-token"
        }

        expect(response).to have_http_status(:unauthorized)
      end

      it "allows requests with a valid token" do
        get "/mcp/sse", headers: {
          "Accept" => "text/event-stream",
          "Authorization" => "Bearer #{token}"
        }

        expect(response).not_to have_http_status(:unauthorized)
      end
    end

    context "with a revoked token" do
      it "rejects the request" do
        revoked_token = Doorkeeper::AccessToken.create!(
          application: application,
          expires_in: 2.hours,
          scopes: "mcp",
          revoked_at: Time.current
        ).token

        post "/mcp/messages", params: { jsonrpc: "2.0", method: "tools/list", id: 1 }.to_json,
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{revoked_token}"
          }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with an expired token" do
      it "rejects the request" do
        expired_token = Doorkeeper::AccessToken.create!(
          application: application,
          expires_in: 1,
          scopes: "mcp",
          created_at: 1.hour.ago
        ).token

        post "/mcp/messages", params: { jsonrpc: "2.0", method: "tools/list", id: 1 }.to_json,
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{expired_token}"
          }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
