#!/usr/bin/env bash
# Mint an AtScale bearer token (Keycloak password grant) and write it to .env as ATSCALE_API_TOKEN.
# Reads ATSCALE_CLIENT_SECRET, ATSCALE_USERNAME and ATSCALE_PASSWORD from .env (gitignored).
# The token is never printed. It expires after the realm's session limit - re-run when it does.
set -euo pipefail
cd "$(dirname "$0")/.."
[ -f .env ] || { echo "no .env - copy .env.example to .env and fill it in" >&2; exit 1; }
set -a; . ./.env; set +a
: "${ATSCALE_CLIENT_SECRET:?set ATSCALE_CLIENT_SECRET in .env}"
: "${ATSCALE_USERNAME:?set ATSCALE_USERNAME in .env}"
: "${ATSCALE_PASSWORD:?set ATSCALE_PASSWORD in .env}"
AUTH_URL="${ATSCALE_AUTH_URL:-http://localhost/auth}"
raw=$(curl -s --fail --location "$AUTH_URL/realms/atscale/protocol/openid-connect/token" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode "client_id=${ATSCALE_CLIENT_ID:-atscale-modeler}" \
  --data-urlencode "client_secret=$ATSCALE_CLIENT_SECRET" \
  --data-urlencode "username=$ATSCALE_USERNAME" \
  --data-urlencode "password=$ATSCALE_PASSWORD" \
  --data-urlencode 'grant_type=password')
token=$(printf '%s' "$raw" | python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')
tmp=$(mktemp)
grep -v '^ATSCALE_API_TOKEN=' .env > "$tmp" || true
printf 'ATSCALE_API_TOKEN=%s\n' "$token" >> "$tmp"
mv "$tmp" .env
chmod 600 .env
echo "minted token (${#token} chars) and wrote ATSCALE_API_TOKEN to .env"
