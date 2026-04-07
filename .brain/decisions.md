---
title: Decisions Log
updated: 2026-04-06
---

# Decisions Log

Record key decisions and their rationale so future sessions understand why things are the way they are.

## [2026-04-06] Rebuilt to v2 architecture
**Decision**: Restructured wiki to v2 with new directories (raw/untracked/, raw/ingested/, wiki/decisions/, outputs/, manifests/, tools/), renamed CLAUDE.md to AGENTS.md, improved IDEA.md template.

**Rationale**: v2 improves source tracking (manifests/), separates generated outputs from wiki, clarifies decision pages, and provides operational tooling. Ingest workflow now has clear stages (Ingest → Extract → Resolve). Agent schema is vendor-neutral and more detailed.

**Alternatives considered**: Staying with v1 (loses benefits of source tracking and output separation).

---

## [2026-04-06] Session start and end protocols
**Decision**: Formalized session protocols with token budgets and explicit checkpoint guidance.

**Rationale**: Ensures consistent state management, prevents context loss between sessions, and makes token budgets transparent. Mid-session checkpoints prevent long-running drift.

---

## [2026-04-06] Hard boundaries (rules)
**Decision**: Defined five immutable rules: compile-first, never modify raw/, never modify IDEA.md unilaterally, deleting > creating, schema write-protection.

**Rationale**: Prevents accidental data loss, ensures intent is preserved, and maintains operational discipline. Rules are deliberately strict to force deliberate choices.
