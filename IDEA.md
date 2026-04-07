---
title: [Your Wiki Title]
author: [Your Name]
status: draft
created: 2026-04-06
updated: 2026-04-06
---

# [Your Wiki Title]

## Thesis
One or two sentences capturing what this knowledge base is about and why it matters. What gap does it fill?

**Example**: "Build a comprehensive understanding of LLM agent architectures by incrementally synthesizing research papers, architecture diagrams, and implementation patterns over time, so that insights compound and stay current as the field evolves."

## Problem
What's broken today? What knowledge are you losing, re-deriving, or failing to connect? Be specific—avoid vague abstractions.

**Example**: "Agent architecture best practices are scattered across dozens of papers and blog posts. Each new session, we re-derive the same insights. Cross-references are lost. Contradictions go unnoticed. Frameworks evolve but we don't track the progression."

## How It Works
Three layers work together:

1. **Raw sources** (immutable evidence layer): You curate and drop sources into `raw/untracked/`. These are the ground truth—articles, papers, transcripts, diagrams.

2. **Wiki** (LLM-maintained synthesis): The agent ingests sources into `wiki/`, creating focused pages: entity profiles, concept explanations, source summaries, comparisons, and decisions. Pages use wikilinks to cross-reference each other. The wiki stays coherent.

3. **Schema** (`AGENTS.md` and `.brain/`): Defines how the agent operates—ingest workflows, query workflows, page conventions, boundaries, and persistent state. The schema evolves with your needs.

You curate, direct, and think. The agent does the bookkeeping, maintains cross-references, and flags contradictions.

## What It Does Not Do
- Does not replace raw sources—they're your evidence layer. All claims trace back to sources.
- Does not auto-ingest—you decide what enters the knowledge base.
- Does not auto-answer by guessing—queries are answered by synthesizing wiki pages, not LLM hallucination.
- Does not scale without discipline—if you ingest poorly or with contradictory sources, the wiki becomes noisy.
- **Add your own boundaries here**. Examples: "Does not track real-time data feeds", "Does not model uncertainty numerically", "Does not auto-generate visualizations".

## Where To Start
1. **Refine this IDEA.md** together with your agent. Make the thesis, problem, and boundaries specific to your domain.
2. **Pick your first 3–5 sources**. They should be foundational or high-signal. Drop them into `raw/untracked/`.
3. **Run one ingest cycle**. The agent will walk you through it: read the source, ask clarifying questions, create summary pages, update cross-references.
4. **Stay involved**. This is not "set and forget". Each ingest is a chance to refine structure and catch misalignments early.

See `AGENTS.md` for full operational guidelines.
