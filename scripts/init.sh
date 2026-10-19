#!/usr/bin/env bash
# One-time setup for a repo created from this template: fills the catalog.yml and README.md placeholders.
# Usage: scripts/init.sh --catalog-name my_catalog --connection bird_x --database x --schema public \
#          [--catalog-label "My Catalog"]
set -euo pipefail
cd "$(dirname "$0")/.."
while [ $# -gt 0 ]; do
  case "$1" in
    --catalog-name) CAT="$2"; shift 2 ;;
    --catalog-label) LABEL="$2"; shift 2 ;;
    --connection) CONN="$2"; shift 2 ;;
    --database) DB="$2"; shift 2 ;;
    --schema) SCHEMA="$2"; shift 2 ;;
    *) echo "unknown arg $1" >&2; exit 1 ;;
  esac
done
: "${CAT:?--catalog-name required}"; : "${CONN:?--connection required}"
: "${DB:?--database required}"; : "${SCHEMA:?--schema required}"
LABEL="${LABEL:-$CAT}"
grep -q '__CATALOG_NAME__' catalog.yml || { echo "catalog.yml already initialised" >&2; exit 1; }
CAT="$CAT" LABEL="$LABEL" CONN="$CONN" DB="$DB" SCHEMA="$SCHEMA" python3 - <<'PY'
import os
rep = {"__CATALOG_NAME__": os.environ["CAT"], "__CATALOG_LABEL__": os.environ["LABEL"],
       "__CONNECTION_ID__": os.environ["CONN"], "__DATABASE__": os.environ["DB"], "__SCHEMA__": os.environ["SCHEMA"]}
for f in ("catalog.yml", "README.md", "PROMPT.md"):
    s = open(f).read()
    for k, v in rep.items():
        s = s.replace(k, v)
    open(f, "w").write(s)
PY
[ -f .env ] || cp .env.example .env
echo "initialised catalog '$CAT' for connection '$CONN' ($DB.$SCHEMA). Next: fill .env, run scripts/mint_token.sh, register this repo in AtScale, then give the agent PROMPT.md."
