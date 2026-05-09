#!/usr/bin/env bash
set -euo pipefail

HOST="${MCP_HOST:-https://localhost:3000}"
LOGFILE=$(mktemp)

curl -sk --no-buffer "${HOST}/mcp/sse" \
  -H "Accept: text/event-stream" \
  --max-time 15 >> "$LOGFILE" &
SSE_PID=$!

sleep 2

curl -sk -X POST "${HOST}/mcp/messages" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"initialize","id":1,"params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'

sleep 1

curl -sk -X POST "${HOST}/mcp/messages" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/list","id":2,"params":{}}'

sleep 2

kill $SSE_PID 2>/dev/null
wait $SSE_PID 2>/dev/null || true

grep "^data:" "$LOGFILE" | sed 's/^data: //' | while IFS= read -r line; do
  echo "$line" | python3 -m json.tool 2>/dev/null || echo "$line"
done

rm "$LOGFILE"
