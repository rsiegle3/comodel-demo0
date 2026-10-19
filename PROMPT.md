# Prompt to give the agent

Fill in the bracketed values, then paste everything below the line.

---

Create an AtScale semantic model for the **[subject, e.g. solar panel operations]** data in AtScale
connection `__CONNECTION_ID__` (database `__DATABASE__`, schema `__SCHEMA__`). Model name: **[Model Name]**.
Business questions it should answer: [one or two lines, or "general operational analysis"].

Follow `AGENTS.md`. Create, commit, push and deploy the model to catalog `__CATALOG_NAME__`. Do not ask me
for confirmations - accept the defaults. Do not use memory; treat this as a clean session. Finish with the
post-deploy checks and a short report of what was built and left out.
