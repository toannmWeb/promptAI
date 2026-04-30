#!/usr/bin/env bash
# new-adr.sh — Scaffold ADR mới với template.
#
# Usage: ./scripts/new-adr.sh "Title of decision"
#         ./scripts/new-adr.sh "Use Riverpod for state management"
#
# Tạo file: docs/adr/<NNNN>-<kebab-title>.md
# với content từ docs/adr/_template.md.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ADR_DIR="$ROOT/docs/adr"

if [ $# -ne 1 ]; then
  echo "Usage: $0 \"Title of decision\"" >&2
  exit 1
fi

TITLE="$1"

if [ ! -d "$ADR_DIR" ]; then
  mkdir -p "$ADR_DIR"
fi

# Find next number
LAST=$(ls "$ADR_DIR"/*.md 2>/dev/null | grep -oE '/[0-9]{4}-' | grep -oE '[0-9]{4}' | sort -n | tail -1 || echo "0000")
NEXT=$(printf '%04d' $((10#$LAST + 1)))

# Slugify title
SLUG=$(echo "$TITLE" \
  | tr '[:upper:]' '[:lower:]' \
  | sed 's/[^a-z0-9]/-/g' \
  | sed 's/--*/-/g' \
  | sed 's/^-//' \
  | sed 's/-$//')

OUT="$ADR_DIR/${NEXT}-${SLUG}.md"

if [ -f "$OUT" ]; then
  echo "❌ File already exists: $OUT" >&2
  exit 1
fi

TEMPLATE="$ADR_DIR/_template.md"
if [ ! -f "$TEMPLATE" ]; then
  cat > "$OUT" <<EOF
# ADR-${NEXT}: ${TITLE}

- **Status**: Proposed
- **Date**: $(date +%Y-%m-%d)
- **Deciders**: <list>
- **Tags**: <topic1, topic2>

## Context

What's the issue? What's the constraint? What forces are at play?

## Decision

What's the decision? Be specific.

## Alternatives considered

- Option A: ... — pros / cons / why rejected
- Option B: ... — pros / cons / why rejected

## Consequences

### Positive
- 
### Negative
- 
### Neutral
- 

## Reversibility

- Reversibility: high | medium | low
- Cost to reverse: <effort>
- Trigger to reconsider: <when>

## Related

- ADR-XXXX: <if supersedes/related>
- PRP-XXX: <if applicable>
- Code: <file:line if applicable>

## References

- 
EOF
else
  # Use template, replace placeholders
  sed \
    -e "s/{{NUMBER}}/${NEXT}/g" \
    -e "s/{{TITLE}}/${TITLE}/g" \
    -e "s/{{DATE}}/$(date +%Y-%m-%d)/g" \
    "$TEMPLATE" > "$OUT"
fi

echo "✅ Created: $OUT"
echo
echo "Next:"
echo "  1. Edit $OUT — fill Context, Decision, Alternatives, Consequences."
echo "  2. Update ROADMAP.md section 3 if topic affects domains/integrations."
echo "  3. Update memory-bank/systemPatterns.md if this changes a pattern."
echo "  4. Commit with message: 'docs: add ADR-${NEXT} ${TITLE}'"
