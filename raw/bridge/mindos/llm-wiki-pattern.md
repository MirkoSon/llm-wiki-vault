# LLM Wiki Pattern

A pattern for building personal knowledge bases using LLMs, popularized by Andrej Karpathy.

## Core idea

Instead of RAG (re-deriving answers from raw docs every query), you compile knowledge into a persistent wiki of interlinked markdown files. The LLM maintains the wiki; the human curates sources.

## Three layers

- **Raw sources**: immutable, LLM reads but never modifies
- **Wiki**: LLM-maintained synthesis pages
- **Schema**: instructions for how the wiki works

## Key insight

Knowledge compounds. Cross-references are already there. Contradictions already flagged. No re-derivation on each query.

## Related concepts

- Vannevar Bush's Memex (1945)
- Zettelkasten method
- Personal knowledge management (PKM)

## Tools

- Obsidian (viewer)
- Claude Code / OpenClaw (agent)
- qmd (local search for large wikis)

## Status

Pattern is established. Multiple open-source implementations exist as of 2026-04.
