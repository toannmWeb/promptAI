#!/usr/bin/env bash
# verify-prompt.sh — Check 1 prompt draft đủ valid + complete trước khi gửi AI.
#
# Usage: ./scripts/verify-prompt.sh [--allow-template] <path-to-prompt-draft.md>
#
# Checklist từ docs/PROMPT-VALIDITY.md.
# Output: pass/fail per check + overall verdict + suggested fixes.
#
# Exit 0 if pass, 1 if fail.

set -euo pipefail

ALLOW_TEMPLATE=0
PROMPT=""

for arg in "$@"; do
  case "$arg" in
    --allow-template) ALLOW_TEMPLATE=1 ;;
    -*)
      echo "Unknown option: $arg" >&2
      echo "Usage: $0 [--allow-template] <prompt-draft.md>" >&2
      exit 1
      ;;
    *)
      if [ -n "$PROMPT" ]; then
        echo "Usage: $0 [--allow-template] <prompt-draft.md>" >&2
        exit 1
      fi
      PROMPT="$arg"
      ;;
  esac
done

if [ -z "$PROMPT" ]; then
  echo "Usage: $0 [--allow-template] <prompt-draft.md>" >&2
  exit 1
fi

if [ ! -f "$PROMPT" ]; then
  echo "❌ File not found: $PROMPT" >&2
  exit 1
fi

PASS=0
FAIL=0
WARN=0

contains() {
  local pattern="$1"
  grep -qiE "$pattern" "$PROMPT"
}

check() {
  local label="$1"
  local pattern="$2"
  if contains "$pattern"; then
    echo "  ✅ $label"
    PASS=$((PASS+1))
  else
    echo "  ❌ $label"
    FAIL=$((FAIL+1))
  fi
}

check_cmd() {
  local label="$1"
  local condition="$2"
  if eval "$condition"; then
    echo "  ✅ $label"
    PASS=$((PASS+1))
  else
    echo "  ❌ $label"
    FAIL=$((FAIL+1))
  fi
}

warn() {
  local label="$1"
  local pattern="$2"
  if ! contains "$pattern"; then
    echo "  ⚠  $label"
    WARN=$((WARN+1))
  fi
}

CONTENT=$(cat "$PROMPT")

echo "Checking prompt: $PROMPT"
echo

echo "## Validity (format)"
check_cmd "Has task contract fields" "contains 'goal|mục tiêu' && contains 'scope|phạm vi' && contains 'context|ngữ cảnh' && contains 'acceptance|AC-|tiêu chí' && contains 'verification|kiểm chứng|verify' && contains 'output|đầu ra|format' && contains 'halt|dừng|stop'"
check "Has memory-bank reference"       'memory-bank|đọc memory'
check "Has scope (file/folder/feature)" 'scope|phạm vi|file:|folder:|feature:|module|edit allowed|do not touch'
check "Has acceptance criteria (AC)"    'AC-|acceptance|tiêu chí chấp nhận|expected output|deliver|done nghĩa là|testable'
check "Requests cite file:line"         'cite|file:line|reference|dẫn chứng|trích dẫn'
check "Requests Confidence + Assumptions" 'confidence|assumption|giả định'
check "Requests Decision Points"        'decision|D-1|options|quyết định'
check "Has output format defined"       'output format|output:|format:|định dạng|trả về'
check "Has verification plan"           'verification|verify|kiểm chứng|test|lint|build|run'
check "Has execution mode"              'execution mode|mode:|analysis-only|edit-files|review-only|generate-artifact|edit mode|agent mode'
echo

echo "## Completeness (context)"
warn "Specifies Edit mode (if file changes)" 'edit mode|use edit|edit panel|agent mode'
warn "Has output format defined"             'output format|output:|format:|định dạng'
warn "Has halt conditions"                   'halt|stop|dừng'
warn "Has language directive"                'tiếng việt|vietnamese|english|language'
warn "References .prompts/ workflow or task" '\.prompts/'
warn "References ROADMAP.md"                 'ROADMAP\.md|ROADMAP'
warn "References prompt contract snippet"     'prompt-contract|Task Contract|task contract'
warn "Uses confirmation gate for input"        'confirmation-gate|Confirmation Gate|INPUT NEEDED|Reply with one line|D-1='
warn "Mentions memory-bank impact for edits"  'CHANGE-IMPACT|Memory-bank impact|memory-bank impact'
warn "States expected verification result"    'expect|expected|kỳ vọng|pass|0 errors|green|PASSED'
echo

echo "## Risk (ambiguity)"
WORDS=$(echo "$CONTENT" | wc -w)
LINES=$(echo "$CONTENT" | wc -l)
echo "  ℹ Length: $WORDS words, $LINES lines"

# Vague terms warning
VAGUE=$(echo "$CONTENT" | grep -ioE 'tốt|nhanh|tối ưu|user-friendly|robust|scalable|clean|nice|good|fast|simple' | sort -u || true)
if [ -n "$VAGUE" ]; then
  echo "  ⚠ Vague terms found: $(echo "$VAGUE" | tr '\n' ' ')"
  WARN=$((WARN+1))
fi

# Unfilled placeholders
PLACEHOLDERS=$(echo "$CONTENT" | grep -oE '<[A-Za-z0-9 _./:-]+>' | sort -u || true)
if [ -n "$PLACEHOLDERS" ]; then
  if [ "$ALLOW_TEMPLATE" -eq 1 ]; then
    echo "  ℹ Template placeholders allowed: $(echo "$PLACEHOLDERS" | tr '\n' ' ')"
  else
    echo "  ⚠ Unfilled placeholders found: $(echo "$PLACEHOLDERS" | tr '\n' ' ')"
    WARN=$((WARN+1))
  fi
fi

# Conflicting words
if echo "$CONTENT" | grep -qiE 'rebuild from scratch' && echo "$CONTENT" | grep -qiE 'minimal change'; then
  echo "  ⚠ Possible conflict: 'rebuild from scratch' AND 'minimal change'"
  WARN=$((WARN+1))
fi

echo

echo "## Summary"
echo "  Pass: $PASS"
echo "  Warn: $WARN"
echo "  Fail: $FAIL"
echo

if [ $FAIL -eq 0 ] && [ $PASS -ge 9 ] && [ $WARN -le 2 ]; then
  echo "✅ Prompt READY"
  echo
  echo "Estimated tokens: ~$(( WORDS * 13 / 10 ))"
  exit 0
elif [ $FAIL -eq 0 ] && [ $PASS -ge 7 ]; then
  echo "⚠  Prompt USABLE with warnings ($WARN warnings)"
  echo "→ Consider fixing warnings before sending."
  exit 0
else
  echo "❌ Prompt NOT READY ($FAIL failures, $WARN warnings)"
  echo
  echo "→ Fix failures using checklist in docs/PROMPT-VALIDITY.md"
  exit 1
fi
