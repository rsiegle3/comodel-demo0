# CoModel Demo

SML semantic models built by an LLM agent (Claude Code or another agent plus the AtScale MCP) straight
from a warehouse schema: point the agent at a database and have it build, validate, commit, push and
deploy a semantic model you can query.

Source: AtScale connection `bird_solar_panel` (database `solar_panel`, schema `public`).
Catalog: `comodel_demo`.

## Using this template

1. Create a repo from the template (GitHub "Use this template") and clone it.
2. `scripts/init.sh --catalog-name <name> --connection <as_connection id> --database <db> --schema <schema>`
3. Fill in `.env` (copied from `.env.example`), then `scripts/mint_token.sh`.
4. Register the new repo in AtScale as a `catalog` repository. The URL must match `origin` exactly.
5. Fill in `PROMPT.md` and give it to the agent. It follows `AGENTS.md`.

## Prerequisites

- The AtScale connection exists and the engine can reach the warehouse.
- The AtScale MCP server is connected to the agent, with shell access to run `sml-cli`, `git` and `gh`.
- `sml-cli` on PATH (`npm install -g sml-cli`).
- Push access to `origin` and a git `user.name` / `user.email`.

## Layout

```
catalog.yml  README.md  AGENTS.md  PROMPT.md  scripts/
<model_name>/{connections,datasets,dimensions,metrics,calculations,models}/
```

`catalog.yml` carries an `ai_context` array that tells the agent where context lives and which rules
bind it. Each `models/*.yml` records its own provenance there.

## Validate / deploy

`atscale-deploy` is git-based: AtScale pulls from GitHub, so the commit must be pushed. `scripts/deploy.sh`
validates, refuses to run on uncommitted or unpushed work, then deploys with the catalog name from
`catalog.yml`. After every deploy: `list_models` and `explore_columns`, one live `run_query` per
dimension, and `validate_mdx_expression` on every `metric_calc`.
