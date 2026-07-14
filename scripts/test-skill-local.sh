#!/usr/bin/env bash
set -euo pipefail

: '
test-skill-local.sh

Runs harness-init through Claude Code CLI in three realistic scenarios:
  - greenfield-complete: complete context produces a final harness
  - greenfield-ambiguous: incomplete context produces a persisted interview draft
  - adoption-preserve: existing human-authored authority remains unchanged

Each run stores raw output, generated files, deterministic validator output, and a
Claude judge report under tests/reports/<timestamp>/<scenario>/.
'

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUNDLE="$ROOT_DIR/targets/claude-code/harness-init"
SCENARIOS_DIR="$ROOT_DIR/tests/scenarios"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
REPORT_ROOT="$ROOT_DIR/tests/reports/$STAMP"
DEFAULT_SCENARIOS=(
  "greenfield-complete"
  "greenfield-ambiguous"
  "adoption-preserve"
)

fail() {
  echo "[test-skill-local] FAIL: $1" >&2
  exit 1
}

require_file() {
  [[ -s "$1" ]] || fail "missing or empty file: $1"
}

require_dir() {
  [[ -d "$1" ]] || fail "missing directory: $1"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "required command not found: $1"
}

scenario_exists() {
  case "$1" in
    greenfield-complete|greenfield-ambiguous|adoption-preserve) return 0 ;;
    *) return 1 ;;
  esac
}

copy_result_tree() {
  local source="$1"
  local destination="$2"

  mkdir -p "$destination"
  (
    cd "$source"
    find . -mindepth 1 \( -path './.claude' -prune \) -o -print \
      | while IFS= read -r entry; do
          if [[ -d "$entry" ]]; then
            mkdir -p "$destination/$entry"
          else
            mkdir -p "$destination/$(dirname "$entry")"
            cp "$entry" "$destination/$entry"
          fi
        done
  )
}

emit_tree() {
  local source="$1"
  local exclude_skill="$2"
  local file

  if [[ "$exclude_skill" == "true" ]]; then
    while IFS= read -r file; do
      echo ""
      echo "### ${file#./}"
      echo '```'
      cat "$source/${file#./}"
      echo '```'
    done < <(cd "$source" && find . -type f -not -path './.claude/*' | LC_ALL=C sort)
  else
    while IFS= read -r file; do
      echo ""
      echo "### ${file#./}"
      echo '```'
      cat "$source/${file#./}"
      echo '```'
    done < <(cd "$source" && find . -type f | LC_ALL=C sort)
  fi
}

check_preserved_files() {
  local seed="$1"
  local sandbox="$2"
  local report_dir="$3"
  local rel

  : > "$report_dir/preservation-check.log"
  for rel in AGENTS.md README.md; do
    if cmp -s "$seed/$rel" "$sandbox/$rel"; then
      echo "[PASS] preserved: $rel" >> "$report_dir/preservation-check.log"
    else
      echo "[FAIL] changed: $rel" >> "$report_dir/preservation-check.log"
      return 1
    fi
  done
}

run_scenario() (
  set -euo pipefail

  local scenario="$1"
  local scenario_dir="$SCENARIOS_DIR/$scenario"
  local prompt_file="$scenario_dir/prompt.md"
  local rubric_file="$scenario_dir/rubric.md"
  local context_file=""
  local seed_dir=""
  local validator_mode=""
  local sandbox report_dir run_prompt judge_input validation_status preservation_status

  cleanup_scenario() {
    rm -rf "$sandbox"
    [[ -z "${judge_input:-}" ]] || rm -f "$judge_input"
  }

  case "$scenario" in
    greenfield-complete)
      context_file="$ROOT_DIR/tests/fixtures/bootstrap-interview.json"
      validator_mode="final"
      ;;
    greenfield-ambiguous)
      validator_mode="draft"
      ;;
    adoption-preserve)
      seed_dir="$ROOT_DIR/tests/fixtures/adoption-project"
      ;;
  esac

  require_file "$prompt_file"
  require_file "$rubric_file"
  [[ -z "$context_file" ]] || require_file "$context_file"
  [[ -z "$seed_dir" ]] || require_dir "$seed_dir"

  report_dir="$REPORT_ROOT/$scenario"
  sandbox="$(mktemp -d)"
  trap cleanup_scenario EXIT
  mkdir -p "$report_dir"

  if [[ -n "$seed_dir" ]]; then
    cp -R "$seed_dir/." "$sandbox"
    copy_result_tree "$seed_dir" "$report_dir/original-seed"
  fi

  mkdir -p "$sandbox/.claude/skills"
  cp -R "$BUNDLE" "$sandbox/.claude/skills/harness-init"

  run_prompt="$(cat "$prompt_file")"
  if [[ -n "$context_file" ]]; then
    run_prompt+=$'\n\n```json\n'
    run_prompt+="$(cat "$context_file")"
    run_prompt+=$'\n```\n'
  fi

  echo "[test-skill-local] run: $scenario"
  if ! (
    cd "$sandbox"
    claude -p "$run_prompt" --permission-mode bypassPermissions
  ) > "$report_dir/run-stdout.log" 2>&1; then
    if grep -q 'Not logged in' "$report_dir/run-stdout.log"; then
      fail "Claude CLI is not logged in; run /login, then rerun this evaluation"
    fi
    fail "$scenario agent run failed; see $report_dir/run-stdout.log"
  fi

  validation_status=0
  if [[ -n "$validator_mode" ]]; then
    if ! bash "$sandbox/.claude/skills/harness-init/scripts/check-generated-harness.sh" \
      "--$validator_mode" "$sandbox" > "$report_dir/harness-check.log" 2>&1; then
      validation_status=1
    fi
  fi

  preservation_status=0
  if [[ -n "$seed_dir" ]]; then
    if ! check_preserved_files "$seed_dir" "$sandbox" "$report_dir"; then
      preservation_status=1
    fi
  fi

  copy_result_tree "$sandbox" "$report_dir/generated"
  judge_input="$(mktemp)"
  {
    cat "$rubric_file"
    echo ""
    echo "## Agent Run Output"
    echo '```'
    cat "$report_dir/run-stdout.log"
    echo '```'
    if [[ -f "$report_dir/harness-check.log" ]]; then
      echo ""
      echo "## Deterministic Harness Check"
      echo '```'
      cat "$report_dir/harness-check.log"
      echo '```'
    fi
    if [[ -f "$report_dir/preservation-check.log" ]]; then
      echo ""
      echo "## Preservation Check"
      echo '```'
      cat "$report_dir/preservation-check.log"
      echo '```'
    fi
    if [[ -n "$seed_dir" ]]; then
      echo ""
      echo "## Original Seed Tree"
      emit_tree "$seed_dir" "false"
    fi
    echo ""
    echo "## Result Tree"
    emit_tree "$sandbox" "true"
  } > "$judge_input"

  echo "[test-skill-local] judge: $scenario"
  claude -p "$(cat "$judge_input")" --permission-mode bypassPermissions \
    > "$report_dir/report.md"

  [[ "$validation_status" == "0" ]] \
    || fail "$scenario failed deterministic harness validation; see $report_dir/harness-check.log"
  [[ "$preservation_status" == "0" ]] \
    || fail "$scenario changed protected seed files; see $report_dir/preservation-check.log"
  if grep -q '^- \[FAIL\]' "$report_dir/report.md"; then
    fail "$scenario failed judge hard checks; see $report_dir/report.md"
  fi

  echo "[test-skill-local] PASS: $scenario ($report_dir)"
)

main() {
  local scenarios=("$@")
  local scenario

  if (( ${#scenarios[@]} == 1 )) && [[ "${scenarios[0]}" == "--help" || "${scenarios[0]}" == "-h" ]]; then
    cat <<'EOF'
Usage: test-skill-local.sh [scenario ...]

Run any combination of:
  greenfield-complete
  greenfield-ambiguous
  adoption-preserve

With no scenario arguments, run all three using Claude Code CLI.
EOF
    return 0
  fi

  require_cmd claude
  require_dir "$BUNDLE"
  if (( ${#scenarios[@]} == 0 )); then
    scenarios=("${DEFAULT_SCENARIOS[@]}")
  fi

  for scenario in "${scenarios[@]}"; do
    scenario_exists "$scenario" || fail "unknown scenario: $scenario"
    run_scenario "$scenario"
  done
}

main "$@"
