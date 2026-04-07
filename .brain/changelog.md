---
title: Changelog
updated: 2026-04-06
---

# Changelog

## [2026-04-06] v2 architecture rebuild
- Restructured directories: added raw/untracked/, raw/ingested/, wiki/decisions/, outputs/, manifests/, tools/.
- Renamed CLAUDE.md → AGENTS.md (vendor-neutral schema).
- Rewrote IDEA.md with improved placeholders and clearer guidance.
- Rewrote AGENTS.md with expanded workflows: 4-stage ingest (Ingest → Extract → Resolve → Update), query, lint, mid-session checkpoints, token budgets.
- Updated .brain/ files (context.md, decisions.md, architecture.md, changelog.md, open-questions.md) to reflect v2.
- Created manifests/sources.csv stub.
- Created tools/lint.sh and tools/wikictl stubs.
- Wiki is empty; awaiting first source ingest.

---

## [2026-04-06] Vault initialization (v1)
- Created directory structure (raw/, wiki/ with subdirectories).
- Added IDEA.md template (v1), CLAUDE.md schema (v1), .brain context files.
- Wiki is empty, awaiting first source ingest.
