# frozen_string_literal: true

#!/usr/bin/env ruby
# frozen_string_literal: true

require "net/http"
require "uri"
require "json"
require "openssl"

HOST = ENV.fetch("MCP_HOST", "https://localhost:3000")

def post(path, body)
  uri = URI("#{HOST}#{path}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == "https"
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  req = Net::HTTP::Post.new(uri.path)
  req["Content-Type"] = "application/json"
  req.body = JSON.generate(body)
  http.request(req)
end

messages = []

sse_thread = Thread.new do
  uri = URI("#{HOST}/mcp/sse")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == "https"
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  http.read_timeout = 15

  req = Net::HTTP::Get.new(uri.path)
  req["Accept"] = "text/event-stream"

  http.request(req) do |response|
    response.read_body do |chunk|
      chunk.split("\n").each do |line|
        next unless line.start_with?("data:")
        data = line.sub(/^data:\s*/, "")
        next unless data.start_with?("{")
        messages << JSON.parse(data)
      end
    end
  end
rescue IOError, Net::ReadTimeout
  # closed by main thread
end

sleep 2

post("/mcp/messages", {
  jsonrpc: "2.0", method: "initialize", id: 1,
  params: {
    protocolVersion: "2024-11-05",
    capabilities: {},
    clientInfo: { name: "test", version: "1.0" }
  }
})

sleep 1

post("/mcp/messages", {
  jsonrpc: "2.0", method: "tools/list", id: 2, params: {}
})

sleep 2

sse_thread.kill
sse_thread.join(1)

messages.each { |msg| puts JSON.pretty_generate(msg) }