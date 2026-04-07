---
title: Wiki Log
created: 2026-04-06
updated: 2026-04-06
---

# Wiki Log

Chronological record of all wiki activity. Each entry uses the format:
```
## [YYYY-MM-DD] action | Title
Details about what happened, what changed, key decisions or findings.
```

Parseable with: `grep "^## \[" wiki/log.md | tail -10`

---

## [2026-04-06] init | Wiki vault v2 architecture
Rebuilt wiki structure: added raw/untracked/, raw/ingested/, wiki/decisions/, outputs/, manifests/, tools/. Renamed CLAUDE.md → AGENTS.md (vendor-neutral). Rewrote IDEA.md with improved templates. Expanded AGENTS.md with detailed workflows (4-stage ingest, query, lint, checkpoints, token budgets). Updated all .brain/ files. Created manifests/sources.csv and tools/ stubs. Wiki ready for first source ingest.
