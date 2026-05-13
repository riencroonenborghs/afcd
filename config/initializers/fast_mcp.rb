# frozen_string_literal: true

require "fast_mcp"
require_relative "../../app/middleware/oauth_mcp_transport"

app = Rails.application
name = app.class.module_parent_name.underscore.dasherize
logger = Rails.logger
path_prefix = "/mcp"
messages_route = "messages"
sse_route = "sse"

FastMcp.server = FastMcp::Server.new(name: name, version: "1.0.0", logger: logger)

FastMcp.server.transport_klass = OauthMcpTransport

app.config.after_initialize do
  FastMcp.server.register_tool(FoodTool)
end

allowed_origins = FastMcp.default_rails_allowed_origins(app)

app.middleware.use(
  OauthMcpTransport,
  FastMcp.server,
  logger: logger,
  allowed_origins: allowed_origins,
  localhost_only: Rails.env.local?,
  path_prefix: path_prefix,
  messages_route: messages_route,
  sse_route: sse_route,
  auth_token: "oauth", # non-nil so auth_enabled? is true; actual validation is in valid_token?
)
