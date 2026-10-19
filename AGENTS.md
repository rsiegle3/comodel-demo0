# Agent instructions

Build an AtScale SML semantic model from the warehouse described in `catalog.yml` `ai_context`, then
validate, commit, push and deploy it. Read `catalog.yml` and `PROMPT.md` first.

## Standing rules
- Accept defaults. Do not ask for confirmation before writing, committing, pushing or deploying.
  Ask only when blocked (missing credentials, an unreachable source, a genuinely ambiguous goal).
- Do not use or write agent memory. Treat the session as clean.
- Build from the warehouse only. Do not read other semantic models on the machine.
- Load the AtScale MCP skills before authoring: `get_sml_skills` `create-model-workflow` and the
  `sml-create-dataset`, `sml-create-dimension`, `sml-create-metric`, `sml-descriptions` and
  `sml-validate` skills it points to. Their `[CHECKLIST_ACK: ...]` tokens are required.
- Write the model into its own directory at the repo root (`snake_case_model_name/`) with its own
  `connections/ datasets/ dimensions/ metrics/ calculations/ models/`. Never write SML objects at the root.
- `create_sml_model` `output_path` is always the repo root.

## Flow
1. Discover with `explore_datasource` (connections, databases, schemas, tables, columns, samples, stats).
   Skip empty tables and `as_agg_*` tables. Record anything deliberately not modeled in the model's `ai_context`.
2. Author datasets, dimensions, metrics, calculations, model. Quoted ASCII descriptions on everything.
   Add provenance `ai_context` to the model file and a real `description` to the model and `catalog.yml`.
3. `sml-cli validate .` until it reports `Validation SUCCESSFUL`.
4. `git add` only what you wrote, commit, `git push origin <branch>`.
5. `scripts/deploy.sh` (validates, checks the push, deploys). If the token is missing or expired,
   run `scripts/mint_token.sh`. If `.env` is not filled in, stop and say so; never guess credentials.
6. Post-deploy, all of: `list_models` and `explore_columns` succeed for the model; at least one live
   `run_query` per dimension; `validate_mdx_expression` on every `metric_calc`. Fix and redeploy on failure.
7. Report what was built, what was left out, and any check that failed. Say plainly if something was not run.

## Gotchas
- A `description:` must be quoted plain ASCII.
- A deployed column takes its name from `unique_name`, not `label`. Keep `unique_name` label-based.
- Qualify every table in a derived (`sql:`) dataset; derived column entries carry no `sql:`.
- Never commit `.env`.
