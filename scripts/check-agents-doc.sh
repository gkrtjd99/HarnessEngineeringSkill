#!/usr/bin/env bash
set -euo pipefail

: '
check-agents-doc.sh

Validates that every AGENTS.md acting as a navigation map stays under the
documented line limit so it does not drift into a full development manual.
Exits non-zero on the first violation with a clear message.
'

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

: '
MAX_LINES is the maximum line count enforced for AGENTS.md navigation maps.
'
MAX_LINES=100

: '
AGENTS_MD_FILES lists every AGENTS.md tracked by this repository that must
stay within MAX_LINES.
'
AGENTS_MD_FILES=(
  "AGENTS.md"
  "starter-kit/AGENTS.md"
)

fail() {
  echo "[check-agents-doc] FAIL: $1" >&2
  exit 1
}

check_file() {
  local rel="$1"
  local path="$ROOT_DIR/$rel"
  local lines

  [[ -f "$path" ]] || fail "missing AGENTS.md: $rel"

  lines="$(wc -l < "$path" | tr -d ' ')"
  if (( lines > MAX_LINES )); then
    fail "$rel has $lines lines, exceeds $MAX_LINES-line navigation map limit"
  fi

  echo "[check-agents-doc] PASS: $rel ($lines lines)"
}

for rel in "${AGENTS_MD_FILES[@]}"; do
  check_file "$rel"
done

echo "[check-agents-doc] All AGENTS.md files within $MAX_LINES-line limit."
