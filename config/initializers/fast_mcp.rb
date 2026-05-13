# frozen_string_literal: true

require "fast_mcp"
require Rails.root.join("app/middleware/doorkeeper_mcp_transport")

FastMcp.mount_in_rails(
  Rails.application,
  name: Rails.application.class.module_parent_name.underscore.dasherize,
  version: "1.0.0",
  path_prefix: "/mcp",
  messages_route: "messages",
  sse_route: "sse",
  authenticate: true,
) do |server|
  Rails.application.config.after_initialize do
    server.register_tool(FoodTool)
  end
end

Rails.application.middleware.swap(
  FastMcp::Transports::AuthenticatedRackTransport,
  DoorkeeperMcpTransport,
  FastMcp.server,
  path_prefix: "/mcp",
  messages_route: "messages",
  sse_route: "sse",
  localhost_only: Rails.env.local?,
)
