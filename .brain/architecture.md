---
title: Wiki Architecture
updated: 2026-04-06
---

# Wiki Architecture

## Directory Map

```
llm-wiki-vault/
├── IDEA.md                    — Intent document (thesis, problem, boundaries)
├── AGENTS.md                  — Vendor-neutral agent schema (operations)
│
├── .brain/                    — Persistent agent context (not editable by agent)
│   ├── context.md             — Current state and active focus
│   ├── decisions.md           — Key decisions and rationale
│   ├── architecture.md        — This file
│   ├── changelog.md           — Session summaries and what-happened log
│   └── open-questions.md      — Unresolved gaps and next steps
│
├── raw/                       — Immutable source documents (evidence layer)
│   ├── untracked/             — Raw sources awaiting full ingest
│   ├── bridge/                — Pre-processed external sources (MindOS, Obsidian,
│   │                            Notion, colleague notes, old wikis, AI exports...)
│   ├── ingested/              — All processed sources (archived after ingest/bridge)
│   ├── articles/              — Articles, blog posts, essays
│   ├── papers/                — Research papers, whitepapers
│   ├── transcripts/           — Interview transcripts, talk transcripts
│   ├── images/                — Standalone images, screenshots
│   └── assets/                — PDFs, videos, other assets
│
├── wiki/                      — LLM-maintained synthesis (curated output)
│   ├── index.md               — Content catalog (master index of all pages)
│   ├── log.md                 — Chronological activity log (operations history)
│   ├── overview.md            — High-level synthesis (entry point)
│   ├── entities/              — Person, company, product, place profiles
│   ├── concepts/              — Theories, frameworks, methods, fields
│   ├── sources/               — Summaries of ingested sources
│   ├── comparisons/           — Comparative analyses and explainers
│   ├── decisions/             — NEW: Architectural and business decisions
│   ├── meta/                  — Session insights, thinking patterns
│   └── media/                 — Diagrams, charts, visuals
│
├── outputs/                   — NEW: Generated answers, reports (ephemeral)
│   └── [queries, reports filed here; separate from permanent wiki]
│
├── manifests/                 — NEW: Source tracking and metadata
│   └── sources.csv            — Source inventory and ingestion status
│
└── tools/                     — NEW: Validation and operational helpers
    ├── lint.sh                — Structural health check (bash, zero tokens)
    └── wikictl                — CLI engine stub (subcommands for operations)
```

## Hierarchy of Authority

When priorities conflict, use this order:

1. **IDEA.md** (intent) — wins all conflicts. It defines what the wiki is for and what it's not for.
2. **AGENTS.md** (operations) — governs how the agent behaves, workflows, boundaries.
3. **.brain/** (state) — informs agent decisions but doesn't constrain future choices.
4. **wiki/** (synthesis) — the output; always revisable.
5. **raw/** (evidence) — immutable, the ground truth that wiki is built on.

## Key Principles

### Three Layers
- **Raw layer** (`raw/`): Immutable source documents. No editing. Sourcing is deliberate.
- **Wiki layer** (`wiki/`): LLM-synthesized interlinked pages. Grows and evolves. Always citable.
- **Schema layer** (`IDEA.md`, `AGENTS.md`, `.brain/`): Defines intent, process, and memory. Intentional change only.

### Workflows
- **Ingest**: raw/untracked/ → 4-stage extract → resolve → raw/ingested/ + wiki pages + manifest (status: ingested).
- **Bridge**: raw/bridge/ → normalization pass → raw/ingested/ + wiki pages + manifest (status: bridged).
- **Query**: read index → drill pages → synthesize with citations → optionally file to outputs/ or wiki/.
- **Lint**: structural checks (bash) → content checks (LLM) → flagged issues → log.

### Source Routing
| Source type | Drop into | Workflow | Manifest status |
|---|---|---|---|
| Raw article, PDF, URL | raw/untracked/ | Full ingest | ingested |
| MindOS, Obsidian, Notion, any pre-structured MD | raw/bridge/ | Bridge pass | bridged |
| Already processed | raw/ingested/ | Delta check only | — |

### State Management
- **Session start**: Read IDEA, context, log tail, index. Budget: ~2K tokens.
- **Session end**: Update .brain/, append log. Budget: ~400 tokens.
- **Checkpoints**: Mid-session check-in for long sessions (30–45 min).

### Protection
- **raw/** is write-protected (except moving from untracked/ to ingested/).
- **IDEA.md** is write-protected (only user can refine).
- **AGENTS.md** and **.brain/** are schema-protected (propose changes, don't override).
- Wiki pages are always revisable (compile-first, delete > create).

## Storage Formats

- **Pages**: Markdown (`.md`) with YAML frontmatter.
- **Manifest**: CSV (`sources.csv`) for easy querying.
- **Tools**: Bash scripts (shell) and markdown stubs.
- **Logs**: Structured markdown with parseable timestamps.

## Scaling Considerations

- **Small wiki** (<50 pages): Simple structure, one-pass queries.
- **Medium wiki** (50–500 pages): Index becomes critical; consider tagging strategy.
- **Large wiki** (500+ pages): May need semantic search tooling; consider cross-wiki splits.

Current scale assumption: Medium wiki (startup state).
