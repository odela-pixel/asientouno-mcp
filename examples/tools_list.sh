#!/usr/bin/env bash
# Lista las herramientas del servidor. Necesita ASIENTOUNO_API_KEY en el entorno.
set -euo pipefail
curl -s https://mcp.asientouno.com/mcp \
  -H "Authorization: Bearer ${ASIENTOUNO_API_KEY:?falta ASIENTOUNO_API_KEY}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}'
