#!/usr/bin/env bash
# Validate, check the commit is pushed, then deploy. AtScale pulls from GitHub, so deploying an
# unpushed commit silently deploys the OLD model.
set -euo pipefail
cd "$(dirname "$0")/.."
command -v sml-cli >/dev/null || { echo "sml-cli not found: npm install -g sml-cli" >&2; exit 1; }
grep -q '__CATALOG_NAME__' catalog.yml && { echo "run scripts/init.sh first" >&2; exit 1; }
sml-cli validate . | tee /dev/stderr | grep -q 'Validation SUCCESSFUL' || { echo "validation failed" >&2; exit 1; }
[ -z "$(git status --porcelain)" ] || { echo "uncommitted changes - commit first" >&2; exit 1; }
git fetch -q origin
branch=$(git rev-parse --abbrev-ref HEAD)
[ "$(git rev-parse HEAD)" = "$(git rev-parse "origin/$branch")" ] || { echo "HEAD is not pushed to origin/$branch - git push first" >&2; exit 1; }
set -a; . ./.env; set +a
: "${ATSCALE_API_URL:?set ATSCALE_API_URL in .env}"
: "${ATSCALE_API_TOKEN:?empty token - run scripts/mint_token.sh}"
cat_name=$(awk '/^unique_name:/{print $2; exit}' catalog.yml)
sml-cli atscale-deploy . --catalog-name="$cat_name"
echo "deployed $(git rev-parse --short HEAD) to catalog $cat_name. Now run the post-deploy checks in AGENTS.md."
