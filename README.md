# llm-wiki-vault

A persistent, compounding knowledge base for AI agents — designed to replace brittle RAG pipelines with a structured, git-tracked markdown vault that agents read, write, and maintain across sessions.

## What this is

Most agent memory systems are either stateless (the agent forgets everything between sessions) or over-engineered (vector databases, embeddings, complex retrieval stacks). This vault takes a different approach: plain markdown files, a strict directory convention, and agents that are trained — via `AGENTS.md` — to compile, query, and maintain knowledge deterministically.

The result is a knowledge base that compounds over time. Every session adds to it. Every source gets processed once and stays compiled. Agents never re-read raw sources; they read wiki pages.

## How to use it

If you are a **human**, start with:
- `IDEA.md` — define what this vault is for and what's out of scope
- `LLM-WIKI-ARCHITECTURE.md` (in `outputs/`) — full design rationale and directory map
- `tools/wikictl` — bash CLI for day-to-day vault operations (`status`, `bridge`, `lint`, `log`)

If you are an **agent**, start with:
- `AGENTS.md` — your complete operational schema: session protocols, all workflows, hard rules, token budgets

## Directory structure

```
llm-wiki-vault/
├── AGENTS.md              # Agent operational schema (agents read this)
├── IDEA.md                # Intent + scope boundaries (agents read this)
├── README.md              # This file
│
├── wiki/                  # Compiled knowledge — the authoritative layer
│   ├── index.md           # Master index of all wiki pages
│   ├── log.md             # Running session log
│   ├── overview.md        # Vault overview
│   ├── concepts/          # Definitions, mental models
│   ├── entities/          # People, orgs, projects, tools
│   ├── decisions/         # Architectural decisions with rationale
│   ├── comparisons/       # Option analyses and trade-offs
│   ├── articles/          # Processed long-form sources
│   ├── sops/              # Standard operating procedures
│   ├── sources/           # Source notes and provenance
│   ├── questions/         # Open questions and threads
│   └── meta/              # Vault meta-knowledge
│
├── raw/                   # Incoming sources — agents never modify
│   ├── untracked/         # New drops, not yet processed
│   ├── bridge/            # Pre-processed external sources
│   │   ├── mindos/        # Exported from MindOS
│   │   ├── obsidian/      # Exported from Obsidian
│   │   ├── notion/        # Exported from Notion
│   │   ├── chatgpt/       # ChatGPT conversation exports
│   │   ├── colleague/     # Files from collaborators
│   │   ├── self/          # Your own notes and drafts
│   │   └── unknown/       # Origin unclear
│   └── ingested/          # Fully processed; archived here
│
├── manifests/
│   └── sources.csv        # Source provenance: hash, status, origin, compiled_into
│
├── outputs/               # Agent-generated artifacts (not wiki knowledge)
│   └── LLM-WIKI-ARCHITECTURE.md   # Human-facing design reference
│
├── tools/
│   ├── wikictl            # Bash CLI: status, bridge, ingest, lint, log, paths
│   └── lint.sh            # Zero-token structural health checks
│
└── .brain/                # Multi-session persistence
    ├── context.md         # Current focus and active threads
    ├── decisions.md       # Key decisions and their reasoning
    ├── architecture.md    # Vault's own architectural notes
    ├── changelog.md       # What changed and when
    └── open-questions.md  # Unresolved threads
```

## Key design principles

**Compile-first, never query raw.** Sources are ingested once into wiki pages. Agents read wiki, not `raw/`.

**Persistent compounding.** Every session's work stays. The vault gets smarter over time rather than resetting.

**Zero external dependencies.** Plain markdown + git + bash. No vector DB, no embeddings, no network calls required to operate. Runs on any VPS.

**Bridge layer for external sources.** Files from MindOS, Obsidian, Notion, colleagues, or your own notes drop into `raw/bridge/<origin>/`. The agent normalizes them to vault schema on ingest — no real-time schema conflicts.

**Source provenance.** `manifests/sources.csv` tracks every source with a content hash. Staleness detection is automatic: re-hash and compare.

**Token budget discipline.** Session start costs ~2K tokens (3 files). Agents never read the full vault upfront.

**Structural lint is free.** `lint.sh` runs bash checks — frontmatter, broken wikilinks, stale untracked files, manifest consistency — without spending a single LLM token.

## Dual-environment strategy

This vault is designed to work headlessly on a VPS (the agent's home), while optionally connecting to a richer UI environment on a local machine:

- **VPS**: agents run directly against the vault via `AGENTS.md`; `wikictl` and `lint.sh` for human ops
- **Local PC**: tools like MindOS can serve as a beautiful frontend; their exports drop into `raw/bridge/mindos/` and get normalized on next ingest

Both environments share the same git repo. The vault is the source of truth.

## Credits

This architecture synthesizes ideas from the following sources:

| Source | Key contribution |
|--------|-----------------|
| [Andrej Karpathy — LLM Wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) | Original three-layer pattern: raw sources → wiki → schema |
| [@pithpusher — IDEA.md](https://github.com/pithpusher/IDEA.md) | Vendor-neutral upstream intent document; IDEA.md as the specification that wins over all downstream agent configs |
| [@samflipppy](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) | `.brain/` persistence layer: context.md, decisions.md, architecture.md, changelog.md, open-questions.md for multi-session continuity |
| [@Ss1024sS — LLM-wiki](https://github.com/Ss1024sS/LLM-wiki) | Source provenance with content hashing; manifests/sources.csv schema; staleness detection via hash comparison |
| [@Ar9av](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) | Four-stage ingest pipeline (Ingest → Extract → Resolve → Schema); delta tracking via per-source manifests |
| [TokRepo workflow](https://tokrepo.com/en/workflows/f6d1f761-8d95-452b-9951-711a7cab05b0) | "Deleting > Creating" rule; Socratic ingest (agent asks before compiling); scheduled auto-lint |
| [@zhiwehu — second-brain](https://github.com/zhiwehu/second-brain) | PARA classification; wikictl bash CLI pattern; outputs/ separation from compiled knowledge |
| [GeminiLight — MindOS](https://github.com/GeminiLight/MindOS) | MCP server as knowledge layer; SOPs as first-class wiki outputs; inspiration for the dual-environment strategy |
| [originlabs-app — agent-wiki](https://github.com/originlabs-app/agent-wiki) | Confidence indicators (`confidence: high/medium/low` in frontmatter); VPS-first headless design philosophy |

The synthesis — bridge layer, dual-environment strategy, subfolder-as-origin convention, and the overall integrated architecture — was developed iteratively with Claude (Anthropic) as the design collaborator.

---

*For the full design rationale, see `outputs/LLM-WIKI-ARCHITECTURE.md`. For agent operational instructions, see `AGENTS.md`.*
