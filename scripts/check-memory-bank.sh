#!/usr/bin/env bash
# check-memory-bank.sh — Verify memory-bank/ consistency
#
# Usage: ./scripts/check-memory-bank.sh [--verbose] [--allow-template]
#
# Checks:
#   1. All 6 CORE files exist and non-empty.
#   2. No <TODO...> placeholders left.
#   3. ADR references in memory-bank/ point to existing files.
#   4. Examples references point to existing files.
#   5. Cross-file consistency (basic).
#
# Exit 0 if all pass, 1 if any fail.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MB="$ROOT/memory-bank"
VERBOSE=0
ALLOW_TEMPLATE=0

for arg in "$@"; do
  case "$arg" in
    --verbose) VERBOSE=1 ;;
    --allow-template) ALLOW_TEMPLATE=1 ;;
    *)
      echo "Usage: $0 [--verbose] [--allow-template]" >&2
      exit 1
      ;;
  esac
done

PASS=0
FAIL=0
WARN=0

log_pass() { echo "  ✅ $1"; PASS=$((PASS+1)); }
log_fail() { echo "  ❌ $1"; FAIL=$((FAIL+1)); }
log_warn() { echo "  ⚠  $1"; WARN=$((WARN+1)); }
log_info() { [ $VERBOSE -eq 1 ] && echo "  ℹ  $1" || true; }

echo "Checking memory-bank/ consistency..."
echo

# ===== 1. Core files exist =====
echo "## 1. Core files"
CORE_FILES=(
  "projectBrief.md"
  "productContext.md"
  "activeContext.md"
  "systemPatterns.md"
  "techContext.md"
  "progress.md"
)

for f in "${CORE_FILES[@]}"; do
  if [ ! -f "$MB/$f" ]; then
    log_fail "$f MISSING"
  elif [ ! -s "$MB/$f" ]; then
    log_fail "$f EMPTY"
  else
    log_pass "$f exists ($(wc -l < "$MB/$f") lines)"
  fi
done
echo

# ===== 2. No TODO placeholders =====
echo "## 2. TODO placeholders"
TODO_FILES=$(grep -rl "<TODO" "$MB" 2>/dev/null || true)
if [ -z "$TODO_FILES" ]; then
  log_pass "No <TODO...> placeholders"
else
  while IFS= read -r f; do
    count=$(grep -c "<TODO" "$f")
    if [ $ALLOW_TEMPLATE -eq 1 ]; then
      log_warn "$f has $count <TODO...> markers (allowed for template skeleton)"
    else
      log_fail "$f has $count <TODO...> markers"
    fi
  done <<< "$TODO_FILES"
fi
echo

# In template skeleton mode, skip reference validation for files that still contain
# placeholders. Otherwise sample ADR/PRP/example refs inside templates create false failures.
if [ $ALLOW_TEMPLATE -eq 1 ]; then
  mapfile -t REF_FILES < <(find "$MB" -type f -name "*.md" -not -name "_template.md" -not -name "README.md" -exec grep -L "<TODO" {} \; 2>/dev/null)
else
  mapfile -t REF_FILES < <(find "$MB" -type f -name "*.md" 2>/dev/null)
fi

# ===== 3. ADR references valid =====
echo "## 3. ADR references"
ADR_DIR="$ROOT/docs/adr"
if [ ${#REF_FILES[@]} -eq 0 ]; then
  ADR_REFS=""
else
  ADR_REFS=$(grep -rho "ADR-[0-9]\{4\}" "${REF_FILES[@]}" 2>/dev/null | sort -u || true)
fi
if [ -z "$ADR_REFS" ]; then
  log_info "No ADR references in memory-bank/"
else
  while IFS= read -r ref; do
    num=$(echo "$ref" | sed 's/ADR-//')
    if compgen -G "$ADR_DIR/${num}-*.md" > /dev/null; then
      log_info "$ref → file exists"
    else
      log_fail "$ref referenced but file not found in $ADR_DIR/${num}-*.md"
    fi
  done <<< "$ADR_REFS"
fi
echo

# ===== 4. Examples references valid =====
echo "## 4. Examples references"
EX_DIR="$ROOT/examples"
if [ ${#REF_FILES[@]} -eq 0 ]; then
  EX_REFS=""
else
  EX_REFS=$(grep -rho "examples/[a-zA-Z0-9_-]\+\.md" "${REF_FILES[@]}" 2>/dev/null | sort -u || true)
fi
if [ -z "$EX_REFS" ]; then
  log_info "No examples references in memory-bank/"
else
  while IFS= read -r ref; do
    fname=$(basename "$ref")
    if [ -f "$EX_DIR/$fname" ]; then
      log_info "$ref → exists"
    else
      log_fail "$ref referenced but $EX_DIR/$fname not found"
    fi
  done <<< "$EX_REFS"
fi
echo

# ===== 5. PRP references valid =====
echo "## 5. PRP references"
PRP_DIR="$ROOT/PRPs"
if [ ${#REF_FILES[@]} -eq 0 ]; then
  PRP_REFS=""
else
  PRP_REFS=$(grep -rho "PRP-[0-9]\+" "${REF_FILES[@]}" 2>/dev/null | sort -u || true)
fi
if [ -z "$PRP_REFS" ]; then
  log_info "No PRP references in memory-bank/"
else
  while IFS= read -r ref; do
    num=$(echo "$ref" | sed 's/PRP-//')
    if compgen -G "$PRP_DIR/${num}-*.md" > /dev/null; then
      log_info "$ref → exists"
    else
      log_fail "$ref referenced but $PRP_DIR/${num}-*.md not found"
    fi
  done <<< "$PRP_REFS"
fi
echo

# ===== 6. activeContext freshness =====
echo "## 6. activeContext freshness"
if [ -f "$MB/activeContext.md" ]; then
  if command -v date > /dev/null; then
    if [ "$(uname)" = "Darwin" ]; then
      MTIME=$(stat -f %m "$MB/activeContext.md")
    else
      MTIME=$(stat -c %Y "$MB/activeContext.md")
    fi
    NOW=$(date +%s)
    AGE_DAYS=$(( (NOW - MTIME) / 86400 ))
    if [ $AGE_DAYS -gt 7 ]; then
      log_warn "activeContext.md not updated in $AGE_DAYS days (consider 'update memory bank')"
    else
      log_pass "activeContext.md updated $AGE_DAYS days ago"
    fi
  fi
fi
echo

# ===== Summary =====
echo "## Summary"
echo "  Pass: $PASS"
echo "  Warn: $WARN"
echo "  Fail: $FAIL"
echo

if [ $FAIL -gt 0 ]; then
  echo "❌ memory-bank check FAILED"
  exit 1
else
  echo "✅ memory-bank check PASSED"
  exit 0
fi
