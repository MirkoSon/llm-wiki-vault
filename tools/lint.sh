#!/bin/bash
# lint.sh — Structural health check for wiki vault
# Zero LLM tokens. Pure bash + grep.
# Usage: ./tools/lint.sh [--verbose]

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VAULT_ROOT="$(dirname "$SCRIPT_DIR")"
VERBOSE=0

if [[ "$1" == "--verbose" ]]; then
  VERBOSE=1
fi

ERRORS=0
WARNINGS=0

log_error() {
  echo "ERROR: $1" >&2
  ((ERRORS++))
}

log_warning() {
  echo "WARNING: $1" >&2
  ((WARNINGS++))
}

log_info() {
  if [[ $VERBOSE -eq 1 ]]; then
    echo "INFO: $1"
  fi
}

# ============================================================================
# Check 1: All wiki pages have YAML frontmatter
# ============================================================================
echo "Checking wiki pages for YAML frontmatter..."
while IFS= read -r file; do
  if ! head -1 "$file" | tr -d '\r' | grep -q "^---$"; then
    log_error "Missing YAML frontmatter in: $file"
  else
    log_info "OK frontmatter: $file"
  fi
done < <(find "$VAULT_ROOT/wiki" -name "*.md" -type f)

# ============================================================================
# Check 2: All wikilinks point to existing files
# ============================================================================
echo "Checking wikilinks for dangling references..."
while IFS= read -r file; do
  # Extract all [[wikilink]] patterns
  grep -o '\[\[[^]]*\]\]' "$file" | sed 's/\[\[//g; s/\]\]//g' | while read -r link; do
    # Check if the linked file exists
    linked_file="$VAULT_ROOT/wiki/${link}.md"
    if [[ ! -f "$linked_file" ]]; then
      log_warning "Dangling wikilink in $file: [[${link}]] → $linked_file (not found)"
    fi
  done
done < <(find "$VAULT_ROOT/wiki" -name "*.md" -type f)

# ============================================================================
# Check 3: index.md lists all wiki pages
# ============================================================================
echo "Checking index.md coverage..."
INDEX_FILE="$VAULT_ROOT/wiki/index.md"
WIKI_PAGES=$(find "$VAULT_ROOT/wiki" -name "*.md" -type f | grep -v "^$VAULT_ROOT/wiki/index.md$" | sed "s|$VAULT_ROOT/wiki/||; s|\.md$||; s|/|-|g" | sort)

while IFS= read -r page; do
  if ! grep -q "\[\[$page\]\]" "$INDEX_FILE"; then
    log_warning "Page not listed in index: $page"
  fi
done < <(echo "$WIKI_PAGES")

log_info "$(echo "$WIKI_PAGES" | wc -l) wiki pages found."

# ============================================================================
# Check 4: No files in raw/untracked/ older than 7 days
# ============================================================================
echo "Checking for stale untracked sources..."
UNTRACKED_DIR="$VAULT_ROOT/raw/untracked"
if [[ -d "$UNTRACKED_DIR" ]]; then
  find "$UNTRACKED_DIR" -type f -mtime +7 | while read -r file; do
    log_warning "Stale untracked source (>7 days old): $(basename "$file")"
  done
  UNTRACKED_COUNT=$(find "$UNTRACKED_DIR" -type f | wc -l)
  if [[ $UNTRACKED_COUNT -gt 0 ]]; then
    log_info "$UNTRACKED_COUNT file(s) in raw/untracked/ awaiting ingest."
  fi
else
  log_error "Directory not found: $UNTRACKED_DIR"
fi

# ============================================================================
# Check 5: Manifest entries match actual files
# ============================================================================
echo "Checking manifest consistency..."
MANIFEST="$VAULT_ROOT/manifests/sources.csv"
if [[ ! -f "$MANIFEST" ]]; then
  log_warning "Manifest not found: $MANIFEST"
else
  # Skip header row and comment rows
  tail -n +2 "$MANIFEST" | grep -v "^#" | while IFS=',' read -r source_id filename raw_path status compiled_into content_hash ingested_date notes; do
    if [[ -z "$source_id" ]]; then
      continue
    fi
    actual_file="$VAULT_ROOT/$raw_path"
    if [[ ! -f "$actual_file" ]]; then
      log_warning "Manifest references missing file: $raw_path"
    else
      log_info "OK manifest entry: $source_id ($raw_path)"
    fi
  done
fi

# ============================================================================
# Summary
# ============================================================================
echo ""
echo "=========================================="
if [[ $ERRORS -eq 0 ]]; then
  echo "Lint results: PASS"
else
  echo "Lint results: FAIL ($ERRORS errors, $WARNINGS warnings)"
fi
echo "=========================================="

exit $ERRORS
