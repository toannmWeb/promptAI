#!/usr/bin/env bash
# build-context.sh — Bundle memory-bank + topic-relevant files thành 1 .md cho prompt lớn.
#
# Usage: ./scripts/build-context.sh <topic> [extra-glob-1] [extra-glob-2] ...
#         ./scripts/build-context.sh auth lib/auth/**/*.dart
#
# Output stdout. Redirect to file:
#   ./scripts/build-context.sh auth > /tmp/auth-context.md
#
# Bundle structure:
#   1. Header: timestamp, topic, files included.
#   2. ROADMAP.md.
#   3. memory-bank/ 6 core + topic-relevant features/integrations/domains.
#   4. ADRs matching topic.
#   5. Examples matching topic.
#   6. Extra files matching args.
#
# Token estimate at end.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ $# -eq 0 ]; then
  echo "Usage: $0 <topic> [extra-glob ...]" >&2
  echo "  topic: keyword to match (case-insensitive) — auth, payment, sync, etc." >&2
  exit 1
fi

TOPIC="$1"
shift
EXTRA_GLOBS=("$@")

OUTFILE="$(mktemp)"
trap 'rm -f "$OUTFILE"' EXIT
INCLUDED_FILES=()

emit() {
  printf '%s\n' "$*" >> "$OUTFILE"
}

emit_file() {
  local f="$1"
  if [ -f "$f" ]; then
    local rel="${f#$ROOT/}"
    INCLUDED_FILES+=("$rel")
    emit ""
    emit "## File: \`$rel\`"
    emit ""
    emit '````markdown'
    cat "$f" >> "$OUTFILE"
    emit '````'
    emit ""
  fi
}

# === Header ===
emit "# Context Bundle"
emit ""
emit "- **Topic**: $TOPIC"
emit "- **Generated**: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
emit "- **Repo**: $(basename "$ROOT")"
emit ""

# === ROADMAP ===
emit "---"
emit ""
emit "# 1. ROADMAP"
emit_file "$ROOT/ROADMAP.md"

# === Memory Bank Core ===
emit "---"
emit ""
emit "# 2. Memory Bank Core"
for f in projectBrief.md productContext.md activeContext.md systemPatterns.md techContext.md progress.md glossary.md; do
  emit_file "$ROOT/memory-bank/$f"
done

# === Memory Bank Topic-relevant ===
emit "---"
emit ""
emit "# 3. Memory Bank Topic-relevant ($TOPIC)"
for sub in features integrations domains; do
  if [ -d "$ROOT/memory-bank/$sub" ]; then
    while IFS= read -r f; do
      if grep -qi "$TOPIC" "$f" 2>/dev/null || [[ "$(basename "$f")" == *"$TOPIC"* ]]; then
        emit_file "$f"
      fi
    done < <(find "$ROOT/memory-bank/$sub" -name "*.md" -not -name "_template.md" -not -name "README.md" 2>/dev/null)
  fi
done

# === ADR ===
emit "---"
emit ""
emit "# 4. ADRs matching '$TOPIC'"
if [ -d "$ROOT/docs/adr" ]; then
  while IFS= read -r f; do
    if grep -qi "$TOPIC" "$f" 2>/dev/null; then
      emit_file "$f"
    fi
  done < <(find "$ROOT/docs/adr" -name "*.md" -not -name "_template.md" -not -name "README.md" 2>/dev/null)
fi

# === Examples ===
emit "---"
emit ""
emit "# 5. Examples matching '$TOPIC'"
if [ -d "$ROOT/examples" ]; then
  while IFS= read -r f; do
    if grep -qi "$TOPIC" "$f" 2>/dev/null || [[ "$(basename "$f")" == *"$TOPIC"* ]]; then
      emit_file "$f"
    fi
  done < <(find "$ROOT/examples" -name "*.md" -not -name "_template.md" -not -name "README.md" 2>/dev/null)
fi

# === Extra files ===
if [ ${#EXTRA_GLOBS[@]} -gt 0 ]; then
  emit "---"
  emit ""
  emit "# 6. Extra files (from globs)"
  for glob in "${EXTRA_GLOBS[@]}"; do
    for f in $glob; do
      [ -f "$f" ] && emit_file "$f"
    done
  done
fi

# === Footer / token estimate ===
emit "---"
emit ""
emit "# Bundle stats"

WORDS=$(wc -w < "$OUTFILE" | tr -d ' ')
LINES=$(wc -l < "$OUTFILE" | tr -d ' ')
TOKENS=$(( WORDS * 13 / 10 ))
emit "- Files included: ${#INCLUDED_FILES[@]}"
emit "- Lines: $LINES"
emit "- Words: $WORDS"
emit "- Rough token estimate: ~$TOKENS"
emit "- (Re-run with \`wc -w\` to estimate words / token usage.)"
emit ""
emit "End of bundle."

cat "$OUTFILE"
