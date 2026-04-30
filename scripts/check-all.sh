#!/usr/bin/env bash
# check-all.sh — Run all validation checks for the master prompt-system template.
#
# Usage: ./scripts/check-all.sh
#
# This is the release gate for Template Mode. It should pass before calling the
# skeleton "ready" or copying it into applied projects.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PASS=0
FAIL=0

run_check() {
  local label="$1"
  shift

  echo
  echo "## $label"
  echo "\$ $*"

  if "$@"; then
    echo "✅ $label passed"
    PASS=$((PASS+1))
  else
    echo "❌ $label failed"
    FAIL=$((FAIL+1))
  fi
}

echo "Running full prompt-system template validation..."

run_check "Shell syntax" bash -n "$ROOT"/scripts/*.sh
run_check "Template purity" bash "$ROOT/scripts/check-template.sh"
run_check "Memory-bank template mode" bash "$ROOT/scripts/check-memory-bank.sh" --allow-template
run_check "Mode 1 workflow prompt validity" bash "$ROOT/scripts/verify-prompt.sh" --allow-template "$ROOT/.prompts/workflows/mode-1-one-shot-max.md"
run_check "One-shot max snippet validity" bash "$ROOT/scripts/verify-prompt.sh" --allow-template "$ROOT/.prompts/snippets/one-shot-max.md"
run_check "Confirmation gate snippet validity" bash "$ROOT/scripts/verify-prompt.sh" --allow-template "$ROOT/.prompts/snippets/confirmation-gate.md"
run_check "Optimize prompt validity" bash "$ROOT/scripts/verify-prompt.sh" --allow-template "$ROOT/.prompts/tasks/optimize-prompt.md"
run_check "Audit template validity" bash "$ROOT/scripts/verify-prompt.sh" --allow-template "$ROOT/.prompts/tasks/audit-template.md"
run_check "Apply-to-project workflow validity" bash "$ROOT/scripts/verify-prompt.sh" --allow-template "$ROOT/.prompts/workflows/apply-to-project.md"
run_check "Mode 1 benchmark doc exists" test -f "$ROOT/docs/BENCHMARK-MODE-1.md"
run_check "Mode 1 benchmark samples exist" test -f "$ROOT/docs/benchmarks/mode-1/debug-loop.md" -a -f "$ROOT/docs/benchmarks/mode-1/feature-plan.md" -a -f "$ROOT/docs/benchmarks/mode-1/review-output.md" -a -f "$ROOT/docs/benchmarks/mode-1/apply-skeleton.md" -a -f "$ROOT/docs/benchmarks/mode-1/audit-template.md"

echo
echo "## Summary"
echo "  Pass: $PASS"
echo "  Fail: $FAIL"

if [ "$FAIL" -gt 0 ]; then
  echo
  echo "❌ check-all FAILED"
  exit 1
fi

echo
echo "✅ check-all PASSED"
