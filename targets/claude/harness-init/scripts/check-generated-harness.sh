#!/usr/bin/env bash
set -euo pipefail

: '
check-generated-harness.sh

Validates the concrete output of harness-init in a target project. The default
final mode checks the completed new-project harness. Draft mode checks the
persisted interview state before the final harness exists.
'

MODE="final"
TARGET_DIR="."

usage() {
  cat <<'EOF'
Usage: check-generated-harness.sh [--final|--draft] [target-directory]

Validate a harness-init output directory. Use --draft while the guided project
definition interview is still in progress; use --final after harness generation.
EOF
}

fail() {
  echo "[check-generated-harness] FAIL: $1" >&2
  exit 1
}

require_file() {
  local rel="$1"

  [[ -s "$TARGET_DIR/$rel" ]] || fail "missing or empty required file: $rel"
}

require_any_section() {
  local rel="$1"
  local label="$2"
  local expression="$3"
  local path="$TARGET_DIR/$rel"

  awk -v expression="$expression" '
    $0 ~ expression { found_heading = 1; in_section = 1; next }
    in_section && /^## / { exit }
    in_section && $0 !~ /^[[:space:]]*$/ { found_content = 1 }
    END { exit(found_heading && found_content ? 0 : 1) }
  ' "$path" || fail "$rel is missing a populated $label section"
}

check_placeholder_markers() {
  local rel="$1"
  local path="$TARGET_DIR/$rel"

  if grep -nE '\[(Describe|path|module|name|count|owner|split)' "$path" >/dev/null; then
    fail "$rel still contains a template marker"
  fi

  if grep -nE '^[[:space:]]*\.\.\.[[:space:]]*$' "$path" >/dev/null; then
    fail "$rel still contains an ellipsis-only template marker"
  fi
}

check_markdown_links() {
  local doc="$1"
  local doc_dir ref

  doc_dir="$(dirname "$doc")"
  while IFS= read -r ref; do
    [[ -z "$ref" ]] && continue
    case "$ref" in
      http*|mailto:*|/*|\#*) continue ;;
    esac
    ref="${ref%%#*}"
    [[ -z "$ref" ]] && continue
    [[ -e "$doc_dir/$ref" ]] || fail "${doc#"$TARGET_DIR"/} references missing path: $ref"
  done < <(grep -oE '\]\([^)]+\)' "$doc" | sed -E 's/^\]\(|\)$//g' || true)
}

check_common_files() {
  local rel
  local required=(
    "README.md"
    "AGENTS.md"
    "CLAUDE.md"
    "ARCHITECTURE.md"
    "docs/product-specs/product-definition.md"
    "docs/exec-plans/active/EP-0001-initial-delivery.md"
    "docs/generated/code-map.md"
    "docs/references/development-rules.md"
  )

  for rel in "${required[@]}"; do
    require_file "$rel"
    check_placeholder_markers "$rel"
  done

  grep -Fq '@AGENTS.md' "$TARGET_DIR/CLAUDE.md" \
    || fail "CLAUDE.md must import the canonical AGENTS.md with @AGENTS.md"

  local agents_lines
  agents_lines="$(wc -l < "$TARGET_DIR/AGENTS.md" | tr -d ' ')"
  (( agents_lines <= 100 )) || fail "AGENTS.md has $agents_lines lines; maximum is 100"
}

check_final_harness() {
  local doc

  check_common_files

  require_any_section "docs/product-specs/product-definition.md" "product summary" '^## (Product Summary|제품 요약)'
  require_any_section "docs/product-specs/product-definition.md" "user journey" '^## (User Journeys|사용자 여정)'
  require_any_section "docs/product-specs/product-definition.md" "functional requirements" '^## (Functional Requirements|기능 요구사항)'
  require_any_section "docs/product-specs/product-definition.md" "scope" '^## (Scope|범위)'
  require_any_section "docs/product-specs/product-definition.md" "success signals" '^## (Success Signals|성공 지표)'
  require_any_section "docs/product-specs/product-definition.md" "agent operating model" '^## (Agent Operating Model|에이전트 운영 모델)'
  require_any_section "docs/product-specs/product-definition.md" "verification and handoff" '^## (Verification and Handoff|검증 및 인계)'
  grep -qE '\|[[:space:]]*P0[[:space:]]*\|' "$TARGET_DIR/docs/product-specs/product-definition.md" \
    || fail "product definition has no P0 requirement row"
  grep -qE '(Acceptance Criteria|인수 기준)' "$TARGET_DIR/docs/product-specs/product-definition.md" \
    || fail "product definition has no acceptance-criteria marker"

  require_any_section "docs/exec-plans/active/EP-0001-initial-delivery.md" "outcome" '^## (Outcome|결과)'
  require_any_section "docs/exec-plans/active/EP-0001-initial-delivery.md" "product trace" '^## (Product Trace|제품 추적)'
  require_any_section "docs/exec-plans/active/EP-0001-initial-delivery.md" "verification" '^## (Verification|검증)'
  require_any_section "docs/exec-plans/active/EP-0001-initial-delivery.md" "done-when" '^## (Done When|완료 기준)'

  grep -qE '^(Status|상태):' "$TARGET_DIR/docs/generated/code-map.md" \
    || fail "code map must state whether surfaces are planned or implemented"
  awk -F'|' '
    /^\|/ && $0 !~ /^\|[[:space:]-]*\|/ && $0 !~ /^\| Area \|/ { found = 1 }
    END { exit(found ? 0 : 1) }
  ' "$TARGET_DIR/docs/generated/code-map.md" || fail "code map has no surface entry"

  while IFS= read -r doc; do
    check_markdown_links "$doc"
  done < <(find "$TARGET_DIR" \
    \( -path "$TARGET_DIR/.git" -o -path "$TARGET_DIR/.claude" -o -path "$TARGET_DIR/.codex" -o -path "$TARGET_DIR/node_modules" \) -prune -o \
    -type f -name '*.md' -print | LC_ALL=C sort)
}

check_draft() {
  local rel="docs/product-specs/product-definition.draft.md"

  require_file "$rel"
  check_placeholder_markers "$rel"
  require_any_section "$rel" "progress" '^## (Progress|진행)'
  require_any_section "$rel" "confirmed decisions" '^## (Confirmed Decisions|확정 결정)'
  require_any_section "$rel" "open questions" '^## (Open Questions|미해결 질문)'
  require_any_section "$rel" "next questions" '^## (Next Questions|다음 질문)'
  grep -qE '(Confirmed sections|확정 섹션):[[:space:]]*[0-9]+/14' "$TARGET_DIR/$rel" \
    || fail "draft progress must record confirmed sections out of 14"
}

while (( $# > 0 )); do
  case "$1" in
    --final) MODE="final" ;;
    --draft) MODE="draft" ;;
    --help|-h)
      usage
      exit 0
      ;;
    -*)
      usage >&2
      exit 2
      ;;
    *)
      [[ "$TARGET_DIR" == "." ]] || fail "only one target directory may be supplied"
      TARGET_DIR="$1"
      ;;
  esac
  shift
done

[[ -d "$TARGET_DIR" ]] || fail "target directory not found: $TARGET_DIR"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

case "$MODE" in
  final) check_final_harness ;;
  draft) check_draft ;;
esac

echo "[check-generated-harness] PASS: $MODE harness at $TARGET_DIR"
