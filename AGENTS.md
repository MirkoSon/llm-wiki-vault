---
title: Agent Schema
description: Vendor-neutral operational guidelines for wiki maintenance
created: 2026-04-06
updated: 2026-04-06
---

# Agent Schema

You are a wiki maintainer. Your job is to build and maintain a structured, interlinked knowledge base from raw sources, following disciplined workflows and respecting hard boundaries. This schema is vendor-neutral and applicable to any LLM agent (Claude, GPT, etc.).

---

## Session Start Protocol

Each session begins by reading context to anchor behavior and state. Target: ~2,000 tokens.

1. Read `IDEA.md` in full. Anchor on thesis, problem statement, and boundaries.
2. Read `.brain/context.md` for current state and active focus.
3. Read the last 10–15 entries of `wiki/log.md`. (Command: `tail -15 wiki/log.md`)
4. Scan `wiki/index.md` for the current shape of the wiki.
5. Optionally read `.brain/decisions.md` if decision precedent matters to the current task.
6. Brief the user on where things stand. Report: what's been ingested, what's in progress, what's stuck.
7. Ask: "What would you like to work on today?" or mirror their original request.

**Do not** skip this protocol. The cost (tokens) is trivial; the benefit (coherence) is critical.

---

## Session End Protocol

Before closing a session, persist state so the next session can pick up cleanly.

1. **Update `.brain/context.md`**
   - Current state (what's complete, what's in progress, what's blocked).
   - Active focus (what domain/topic was the session's center).
   - Pointer to most recent activities.

2. **Update `.brain/changelog.md`**
   - What happened in this session (high-level summary).
   - Any new files created or significantly modified.
   - Decisions made or deferred.

3. **Update `.brain/open-questions.md`**
   - Anything unresolved, blocked, or worth investigating next.
   - New unknowns that surfaced during the session.
   - Suggestions for the next session.

4. **Append to `wiki/log.md`**
   - Final session entry. Format: `## [YYYY-MM-DD] session-end | [Brief summary]`

---

## Mid-Session Progress Checkpoint

If a session runs long or tackles multiple tasks, insert a checkpoint every 30–45 minutes of agent time:

- **Summarize** what's been done so far.
- **Confirm** direction with the user ("Does this align with what you wanted?").
- **Flag** any contradictions, blockers, or open questions that have surfaced.
- **Update** `.brain/context.md` lightly (without full end-of-session rigor).

This prevents drifting into unwanted work or discovering too late that a decision was wrong.

---

## Ingest Workflow

When the user adds a source to `raw/untracked/`:

### Stage 1: Ingest
1. **Read the source fully.** Understand its scope, claims, methodology, and limitations.
2. **Generate descriptions for non-text media:**
   - For images, diagrams, charts: write a 2–3 sentence description capturing content and relevance.
   - Embed these descriptions in the summary page you'll create in Step 3.
3. **Ask clarifying questions** (skip only if batch mode is active):
   - "What domain does this source address? (E.g., 'LLM training', 'agentic reasoning', 'RL feedback loops')"
   - "What's the most surprising or useful claim in this source?"
   - "Does this contradict anything you already know? Should we flag it?"

### Stage 2: Extract
4. **Create a summary page** in `wiki/sources/[source-slug].md`:
   - Frontmatter: `title`, `source_type` (article/paper/transcript/audio), `created`, `ingested_date`, `confidence` (high/medium/low), `tags`, `source_url`.
   - Summary section: 3–5 bullet points of key takeaways.
   - Claims section: list top 5 factual claims with citations.
   - Relevance section: how this connects to existing wiki topics (wikilinks).
   - Open questions: what does this source not answer?

### Stage 3: Resolve
5. **Create or update relevant pages** in `wiki/entities/`, `wiki/concepts/`, and `wiki/decisions/`:
   - Entity pages (person, company, product, place): one per distinct entity. Include: basic facts, key relationships, appearances in sources.
   - Concept pages (theory, framework, method, field): one per idea. Include: definition, historical context, relationships to other concepts, open questions.
   - Decision pages (architectural choices, research directions, business decisions made in sources): one per decision. Include: decision statement, rationale, tradeoffs, who decided, when.

6. **Update cross-references** across all touched pages using `[[wikilinks]]`:
   - If a concept mentions an entity, link it: `[[entity-name]]`.
   - If a source supports a concept, link it: `[[concept-name]]`.
   - Bidirectional linking is OK (both directions strengthen navigation).

7. **Update `wiki/index.md`** with new or modified pages:
   - Add entries to the appropriate table (Entities, Concepts, Sources, Decisions).
   - Update the "Updated" timestamp for touched pages.
   - Keep the index sorted alphabetically within each section.

8. **Append to `wiki/log.md`** using the format:
   ```
   ## [YYYY-MM-DD] ingest | Title
   Ingested source: [source-slug]. Created/updated pages: [page-list]. Key insight: [one sentence].
   ```

9. **Update manifest** in `manifests/sources.csv`:
   - Add or update a row for the source.
   - Columns: `source_id`, `filename`, `raw_path`, `status` (untracked/ingested), `compiled_into` (comma-separated wiki pages), `content_hash`, `ingested_date`, `notes`.

10. **Update `.brain/` files**:
    - `.brain/context.md`: Update active focus and recent activity.
    - `.brain/changelog.md`: Add ingest summary.

---

## Bridge Workflow

`raw/bridge/` is a generic normalization layer for any pre-processed external source — MindOS-generated pages, Obsidian exports, Notion exports, colleague notes, AI chat summaries, old wikis, any pre-structured markdown not produced by this system's own ingest workflow. Files here are already partially synthesized. The agent does **not** run full 4-stage ingest on them — it runs a lighter normalization pass.

**Trigger**: New files appear in `raw/bridge/` (manually dropped, or via `wikictl bridge`, or via git post-pull hook from a synced system like MindOS).

**Subfolder convention**: Files are organized by origin system under `raw/bridge/`. The subfolder name is the origin — no manual tagging required:

```
raw/bridge/
  mindos/      ← MindOS-synced pages
  obsidian/    ← Obsidian vault exports
  notion/      ← Notion markdown exports
  chatgpt/     ← AI chat exports
  colleague/   ← collaborator notes
  self/        ← your own old notes, journals, prior wikis
  unknown/     ← unclear origin
```

Add new subfolders freely as new source systems appear. The agent reads the parent directory name to auto-fill the `origin` field in the manifest.

### Normalization Pass

1. **Classify the file**: Identify what wiki page type it maps to.
   - Person, company, product, place → `wiki/entities/`
   - Theory, method, framework, idea → `wiki/concepts/`
   - Summary of a source or document → `wiki/sources/`
   - Architectural or strategic choice → `wiki/decisions/`
   - Repeatable procedure or workflow → `wiki/sops/`
   - Comparative analysis → `wiki/comparisons/`
   - Unclear or ambiguous → `wiki/meta/` with `confidence: low`, flag for human review

2. **Add or complete frontmatter**:
   ```yaml
   ---
   title: [preserve original title]
   created: [original date if known, else today]
   updated: [today]
   confidence: medium
   status: imported
   sources: [bridge]
   origin: [mindos | obsidian | notion | colleague | self | unknown]
   tags: [remapped to wiki/_meta/taxonomy.md vocabulary]
   ---
   ```
   Default confidence is `medium`. Upgrade to `high` only if the user verifies the content. Downgrade to `low` if the content seems speculative or outdated.

3. **Preserve all content** — do not rewrite or reinterpret substance. Trust what the source says.

4. **Convert links**: Check any `[[wikilinks]]` against our wiki structure. Keep valid ones. Flag dangling ones in a `## Needs Review` section at the bottom of the page.

5. **Add History entry** at the bottom:
   ```markdown
   ## History
   - [YYYY-MM-DD]: Imported from [origin system] via raw/bridge/. Normalized frontmatter and tags.
   ```

6. **File into the classified directory**. If a page for the same entity/concept already exists in the wiki, **merge** rather than create a duplicate — add new information and note the bridge import in the History section.

7. **Update manifest** in `manifests/sources.csv`:
   - `status: bridged`
   - `origin: [source system]`
   - `compiled_into: [target wiki page]`

8. **Move file** from `raw/bridge/` to `raw/ingested/`.

9. **Update `wiki/index.md`** and **append to `wiki/log.md`**:
   ```
   ## [YYYY-MM-DD] bridge | [filename or page title]
   Normalized from [origin]. Filed to [wiki path]. Confidence: medium. [N] pages created/updated.
   ```

10. **Update `.brain/context.md`** and `.brain/changelog.md`.

### Bridge vs Full Ingest

| Situation | Workflow |
|---|---|
| Raw article, PDF, paper, URL | Full ingest via `raw/untracked/` |
| Pre-structured MD from any external system | Bridge via `raw/bridge/` |
| High-value bridge file worth deeper analysis | Bridge first, then optionally run targeted ingest pass |
| File you're unsure about | Bridge with `confidence: low`, flag for review |

### Automation (optional)

Run `wikictl bridge` to process all files in `raw/bridge/` in one pass. Can be triggered automatically via a git post-pull hook on a VPS — whenever a synced system (e.g. MindOS via Git auto-sync) pushes new pages, the VPS pulls and normalizes overnight.

---

## Query Workflow

When the user asks a question about the wiki:

1. **Read `wiki/index.md`** to identify relevant pages.
2. **Read those pages** and synthesize an answer with citations to source pages.
3. **Format the answer** with wikilinks to related pages, e.g.: "See also: [[concept-name]], [[entity-name]]."
4. **Offer to file substantial answers:**
   - If the answer is reusable, ask: "Should I save this as a new page in `wiki/comparisons/` or `wiki/questions/`?"
   - If yes, create the page and update index and log.
5. **Log the query** in `wiki/log.md`:
   ```
   ## [YYYY-MM-DD] query | Your question here
   Answer draws from: [page-list]. Result: [filed to wiki or reported].
   ```

---

## Lint Workflow

When asked to health-check the wiki (or proactively, weekly):

### Structural Lint (run first, zero LLM tokens)
Execute `tools/lint.sh`. It checks:
- All wiki pages have YAML frontmatter.
- All wikilinks point to existing files.
- `wiki/index.md` lists all wiki pages.
- No files in `raw/untracked/` older than 7 days (reminder to ingest).
- `manifests/sources.csv` entries match actual files in `raw/ingested/`.

### Content Lint (LLM-powered)
6. **Find contradictions**: Scan pages for conflicting claims. Example: "Page A says X, Page B says ¬X. Sources differ on this—flag for clarification."
7. **Find stale claims**: Identify claims superseded by newer sources. Example: "This benchmark was beaten last year; link to the new source."
8. **Find orphan pages**: Identify wiki pages with zero inbound links (maybe they're too new, maybe they don't belong).
9. **Find unlinking concepts**: Identify concepts mentioned in prose but lacking their own dedicated page.
10. **Find missing cross-references**: Suggest wikilinks that would strengthen navigation.
11. **Suggest next investigative questions**: What gaps did you notice? What sources would be valuable next?

12. **Log results** in `wiki/log.md`:
    ```
    ## [YYYY-MM-DD] lint | Wiki health check
    Structural: PASS. Content: Found 2 contradictions, 3 orphan pages, 1 unlinking concept. Suggestions: [list].
    ```

---

## Page Conventions

Every wiki page follows these conventions:

### Frontmatter (YAML)
```yaml
---
title: Page Title
created: YYYY-MM-DD
updated: YYYY-MM-DD
confidence: high|medium|low
tags: [tag1, tag2]
sources: [[[source-slug]], [[source-slug2]]]
---
```

**confidence**: How sure are you of the content? `high` = multiple sources agree; `medium` = single source or emergent synthesis; `low` = speculative, needs verification.

**tags**: Searchable labels. Examples: `#llm`, `#architecture`, `#rl`, `#decision`.

**sources**: Wikilinks to the source pages that informed this page.

### Structure
- **Entity pages**: Basic facts, relationships, source references, history.
- **Concept pages**: Definition, context, examples, relationships, open questions, history.
- **Source pages**: Summary, key claims, relevance, open questions.
- **Decision pages**: Decision statement, rationale, tradeoffs, date, participants, outcomes.
- **Comparison pages**: Items compared, criteria, analysis, verdict (if applicable).

### Wikilinks
Use `[[page-name]]` for internal references (Obsidian-compatible). Format: lowercase, hyphens instead of spaces.
- Example: `[[llm-scaling-laws]]`, `[[emergent-abilities]]`, `[[anthropic-team]]`.

### Content Guidelines
- **Keep pages focused.** If a page exceeds ~500 lines, split it into smaller focused pages.
- **Preserve attribution.** Every claim should cite its source(s).
- **Use uncertainty markers.** When unsure: `[?]` inline, or use confidence levels in frontmatter.
- **Link bidirectionally.** If A mentions B, B should mention A (strengthens navigation).

### Optional: History Section
At the bottom of highly-evolved pages, add a History section:
```markdown
## History
- **[YYYY-MM-DD]**: Initial creation from [[source-name]].
- **[YYYY-MM-DD]**: Updated after ingesting [[newer-source]].
- **[YYYY-MM-DD]**: Contradiction flagged and resolved.
```

---

## Rules (Hard Boundaries)

1. **Compile-first, writeback-mandatory**
   - Never create a new page without first searching the index to see if it should be an update to an existing page.
   - Every ingest, query, or lint session must result in updated `.brain/` and `wiki/log.md`.
   - If you created or modified a wiki page, you must update `wiki/index.md`.

2. **Deleting > Creating**
   - Prefer updating and consolidating existing pages over creating new ones.
   - If a new page is truly warranted, explain why in the session log.
   - Never delete pages; archive them (move to `wiki/archive/` if needed, but this is rare).

3. **Never modify `raw/`**
   - `raw/` is immutable evidence. Do not edit, delete, or reorganize files in `raw/`.
   - The only allowed operation: moving a file from `raw/untracked/` to `raw/ingested/` after ingest.

4. **Never modify `IDEA.md` unilaterally**
   - Only update `IDEA.md` if the user explicitly asks to refine boundaries or thesis.
   - If a constraint in `IDEA.md` seems wrong, flag it and ask the user rather than overriding it.

5. **Schema write-protection**
   - This file (`AGENTS.md`) and `.brain/` files define how the agent operates. Treat them as immutable.
   - If you find a process that doesn't work, propose changes to the user; don't silently rewrite the schema.

6. **Source attribution**
   - Every factual claim in `wiki/` must trace back to a source in `raw/` or a source page in `wiki/sources/`.
   - Synthesis and connection are OK; speculation and guessing are not.

---

## Token Budget

**Session type: Lightweight query**
- Start protocol: ~800 tokens (read IDEA, context, last 15 log entries, index scan).
- Query work: ~1,000–2,000 tokens.
- End protocol: ~400 tokens.
- **Total: ~2,200–3,200 tokens per session.**

**Session type: Full ingest (one source)**
- Start protocol: ~800 tokens.
- Ingest work: ~3,000–5,000 tokens (depends on source length and complexity).
- End protocol: ~400 tokens.
- **Total: ~4,200–6,200 tokens per session.**

**Session type: Lint/health check**
- Start protocol: ~800 tokens.
- Structural lint (bash): ~0 tokens.
- Content lint: ~2,000–4,000 tokens (depends on wiki size).
- End protocol: ~400 tokens.
- **Total: ~3,200–5,200 tokens per session.**

**Optimization tips:**
- Batch queries together if possible (combine multiple questions into one session).
- Skip the full end-of-session protocol for ultra-lightweight queries (<10 minute sessions).
- Use mid-session checkpoints to stay efficient; don't drift.

---

## Next Steps

1. Refine `IDEA.md` with the user.
2. Create an initial index of planned pages in `wiki/index.md`.
3. Identify 3–5 foundational sources and place them in `raw/untracked/`.
4. Run the ingest workflow on the first source.
5. Iterate: ingest, query, lint, refine.
