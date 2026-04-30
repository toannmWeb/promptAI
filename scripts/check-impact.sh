#!/usr/bin/env bash
# check-impact.sh — Khi sửa code path X, list memory-bank file nào CẦN UPDATE.
#
# Usage: ./scripts/check-impact.sh <path-to-changed-file-or-folder>
#         ./scripts/check-impact.sh --git HEAD~1   # tự lấy diff từ git
#
# Đọc docs/CHANGE-IMPACT.md (lookup table) và match theo path patterns.
#
# Exit 0 always (informational).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMPACT_FILE="$ROOT/docs/CHANGE-IMPACT.md"

if [ ! -f "$IMPACT_FILE" ]; then
  echo "❌ docs/CHANGE-IMPACT.md not found. Create it from skeleton template first."
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "Usage: $0 <path>"
  echo "       $0 --git <ref>    # use git diff <ref> HEAD"
  exit 1
fi

CHANGED_FILES=()

if [ "$1" = "--git" ]; then
  REF="${2:-HEAD~1}"
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository"
    exit 1
  fi
  while IFS= read -r f; do
    CHANGED_FILES+=("$f")
  done < <(git diff --name-only "$REF" HEAD)
  echo "Inspecting git diff $REF..HEAD ($(echo ${#CHANGED_FILES[@]}) files)"
else
  CHANGED_FILES+=("$1")
  echo "Inspecting path: $1"
fi
echo

if [ ${#CHANGED_FILES[@]} -eq 0 ]; then
  echo "No changed files."
  exit 0
fi

# Parse CHANGE-IMPACT.md table.
# Expected format: Markdown table with columns | Pattern | Memory-bank impact |
# Lines starting with `| ` and containing path glob → MB file.

declare -A IMPACTS  # pattern -> mb files

PARSING=0
while IFS= read -r line; do
  if echo "$line" | grep -qE '^\|.*Pattern.*Memory'; then
    PARSING=1
    continue
  fi
  if [ $PARSING -eq 1 ] && echo "$line" | grep -qE '^\|---'; then
    continue
  fi
  if [ $PARSING -eq 1 ] && echo "$line" | grep -qE '^\|'; then
    pattern=$(echo "$line" | awk -F '|' '{gsub(/^ *| *$/,"",$2); print $2}' | tr -d '`')
    targets=$(echo "$line" | awk -F '|' '{gsub(/^ *| *$/,"",$3); print $3}')
    if [ -n "$pattern" ] && [ -n "$targets" ]; then
      IMPACTS["$pattern"]="$targets"
    fi
  elif [ $PARSING -eq 1 ] && [ -z "$line" ]; then
    PARSING=0
  fi
done < "$IMPACT_FILE"

if [ ${#IMPACTS[@]} -eq 0 ]; then
  echo "⚠ No patterns parsed from $IMPACT_FILE. Check table format."
  exit 0
fi

echo "## Affected memory-bank files (by pattern match)"
echo

declare -A AGGREGATE

for f in "${CHANGED_FILES[@]}"; do
  matched=0
  for pattern in "${!IMPACTS[@]}"; do
    # Use bash glob match. Convert glob to bash compatible.
    if [[ "$f" == $pattern ]]; then
      AGGREGATE["${IMPACTS[$pattern]}"]+="$f|"
      matched=1
    fi
  done
  if [ $matched -eq 0 ]; then
    echo "  ⚠ $f → no pattern matched (consider adding to CHANGE-IMPACT.md)"
  fi
done

if [ ${#AGGREGATE[@]} -eq 0 ]; then
  echo "(no impacts found)"
  exit 0
fi

echo
echo "## Update required:"
for targets in "${!AGGREGATE[@]}"; do
  triggered_files=$(echo "${AGGREGATE[$targets]}" | tr '|' '\n' | sort -u | grep -v '^$')
  echo
  echo "→ Update: $targets"
  echo "  Triggered by:"
  echo "$triggered_files" | sed 's/^/    - /'
done

echo
echo "## Suggested next step"
echo "Run: 'update memory bank' workflow with this list."
echo "→ See: .prompts/workflows/update-memory-bank.md"
