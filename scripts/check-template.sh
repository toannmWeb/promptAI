#!/usr/bin/env bash
# check-template.sh — Verify this repo is a clean master prompt-system template.
#
# Usage: ./scripts/check-template.sh [--verbose]
#
# Checks:
#   1. Required template files/folders exist.
#   2. Template-mode markers exist.
#   3. memory-bank placeholders are present and allowed.
#   4. Prompt files have frontmatter.
#   5. Shell scripts parse.
#   6. Command-critical prompt files exist.
#
# Exit 0 if template is valid, 1 if any hard failure.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERBOSE=0

for arg in "$@"; do
  case "$arg" in
    --verbose) VERBOSE=1 ;;
    *)
      echo "Usage: $0 [--verbose]" >&2
      exit 1
      ;;
  esac
done

PASS=0
WARN=0
FAIL=0

log_pass() { echo "  ✅ $1"; PASS=$((PASS+1)); }
log_warn() { echo "  ⚠  $1"; WARN=$((WARN+1)); }
log_fail() { echo "  ❌ $1"; FAIL=$((FAIL+1)); }
log_info() { [ "$VERBOSE" -eq 1 ] && echo "  ℹ  $1" || true; }

check_file() {
  local rel="$1"
  if [ -f "$ROOT/$rel" ]; then
    log_pass "$rel exists"
  else
    log_fail "$rel missing"
  fi
}

check_dir() {
  local rel="$1"
  if [ -d "$ROOT/$rel" ]; then
    log_pass "$rel exists"
  else
    log_fail "$rel missing"
  fi
}

check_contains() {
  local rel="$1"
  local pattern="$2"
  local label="$3"
  if [ -f "$ROOT/$rel" ] && grep -qiE "$pattern" "$ROOT/$rel"; then
    log_pass "$label"
  else
    log_fail "$label"
  fi
}

echo "Checking prompt-system master template..."
echo

echo "## 1. Required structure"
for f in README.md ROADMAP.md AGENTS.md docs/TEMPLATE-MODE.md docs/REQUEST-MODES.md docs/BENCHMARK-MODE-1.md .github/copilot-instructions.md .github/workflows/template-ci.yml; do
  check_file "$f"
done

for d in .prompts .prompts/system .prompts/personas .prompts/workflows .prompts/tasks .prompts/snippets memory-bank docs scripts PRPs examples _logs; do
  check_dir "$d"
done
echo

echo "## 2. Template mode markers"
check_contains "README.md" "Prompt System Skeleton|master template|prompt-system-skeleton" "README identifies prompt-system skeleton"
check_contains "ROADMAP.md" "prompt-system-skeleton" "ROADMAP identifies skeleton"
check_contains "docs/TEMPLATE-MODE.md" "Template Mode|Applied Project Mode" "TEMPLATE-MODE defines both modes"
check_contains ".prompts/system/base.md" "Template Mode|TEMPLATE PURITY" "base prompt enforces Template Mode"
echo

echo "## 3. Memory-bank template placeholders"
CORE_FILES=(projectBrief.md productContext.md activeContext.md systemPatterns.md techContext.md progress.md)
for f in "${CORE_FILES[@]}"; do
  path="memory-bank/$f"
  if [ ! -f "$ROOT/$path" ]; then
    log_fail "$path missing"
  elif grep -q "<TODO" "$ROOT/$path"; then
    log_pass "$path keeps template placeholders"
  else
    log_warn "$path has no <TODO...>; confirm this is still a reusable template"
  fi
done
echo

echo "## 4. Prompt frontmatter"
while IFS= read -r f; do
  rel="${f#$ROOT/}"
  first_line=$(head -n 1 "$f")
  if [ "$first_line" = "---" ] && grep -q "^name:" "$f" && grep -q "^purpose:" "$f" && grep -q "^version:" "$f"; then
    log_info "$rel frontmatter ok"
  else
    log_fail "$rel missing required frontmatter (---, name, purpose, version)"
  fi
done < <(find "$ROOT/.prompts" -type f -name "*.md" ! -name "README.md" 2>/dev/null)

log_pass "Prompt frontmatter scan completed"
echo

echo "## 5. Command-critical prompt files"
CRITICAL_PROMPTS=(
  ".prompts/workflows/apply-to-project.md"
  ".prompts/workflows/overwrite-prompt-system.md"
  ".prompts/workflows/mode-1-one-shot-max.md"
  ".prompts/workflows/initialize-memory-bank.md"
  ".prompts/workflows/update-memory-bank.md"
  ".prompts/workflows/debug-loop.md"
  ".prompts/workflows/deep-dive-learn.md"
  ".prompts/workflows/refactor-safe.md"
  ".prompts/workflows/feature-end-to-end.md"
  ".prompts/tasks/optimize-prompt.md"
  ".prompts/tasks/audit-template.md"
  ".prompts/tasks/verify-output.md"
  ".prompts/snippets/prompt-contract.md"
  ".prompts/snippets/one-shot-max.md"
  ".prompts/snippets/confirmation-gate.md"
  "scripts/check-all.sh"
  "docs/BENCHMARK-MODE-1.md"
  "docs/benchmarks/mode-1/debug-loop.md"
  "docs/benchmarks/mode-1/feature-plan.md"
  "docs/benchmarks/mode-1/review-output.md"
  "docs/benchmarks/mode-1/apply-skeleton.md"
  "docs/benchmarks/mode-1/audit-template.md"
)
for f in "${CRITICAL_PROMPTS[@]}"; do
  check_file "$f"
done
echo

echo "## 6. Script syntax"
if command -v bash >/dev/null 2>&1; then
  if bash -n "$ROOT"/scripts/*.sh; then
    log_pass "All scripts parse with bash -n"
  else
    log_fail "One or more scripts fail bash -n"
  fi
else
  log_warn "bash not found; skipped script syntax check"
fi
echo

echo "## 7. Memory-bank template validation"
if "$ROOT/scripts/check-memory-bank.sh" --allow-template >/tmp/check-template-memory-bank.out 2>&1; then
  log_pass "check-memory-bank.sh --allow-template passed"
else
  log_fail "check-memory-bank.sh --allow-template failed"
  [ "$VERBOSE" -eq 1 ] && cat /tmp/check-template-memory-bank.out
fi
rm -f /tmp/check-template-memory-bank.out
echo

echo "## 8. Counts"
WORKFLOWS=$(find "$ROOT/.prompts/workflows" -maxdepth 1 -type f -name "*.md" | wc -l | tr -d ' ')
TASKS=$(find "$ROOT/.prompts/tasks" -maxdepth 1 -type f -name "*.md" | wc -l | tr -d ' ')
SNIPPETS=$(find "$ROOT/.prompts/snippets" -maxdepth 1 -type f -name "*.md" | wc -l | tr -d ' ')
PERSONAS=$(find "$ROOT/.prompts/personas" -maxdepth 1 -type f -name "*.md" ! -name "README.md" | wc -l | tr -d ' ')
echo "  Workflows: $WORKFLOWS"
echo "  Tasks: $TASKS"
echo "  Snippets: $SNIPPETS"
echo "  Personas: $PERSONAS"
echo

echo "## Summary"
echo "  Pass: $PASS"
echo "  Warn: $WARN"
echo "  Fail: $FAIL"
echo

if [ "$FAIL" -gt 0 ]; then
  echo "❌ template check FAILED"
  exit 1
fi

echo "✅ template check PASSED"
