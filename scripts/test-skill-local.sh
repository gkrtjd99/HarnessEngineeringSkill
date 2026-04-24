#!/usr/bin/env bash
set -euo pipefail

: '
test-skill-local.sh

Runs the harness-init skill end-to-end in a throwaway sandbox using Claude
Code CLI, then invokes a second CLI call as a judge to score the output
against tests/judge-rubric.md. Writes a report to tests/reports/<timestamp>/
and exits non-zero if any hard-checklist item failed.
'

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUNDLE="$ROOT_DIR/targets/claude-code/harness-init"
FIXTURE="$ROOT_DIR/tests/fixtures/interview.json"
PROMPT_RUN="$ROOT_DIR/tests/prompts/run.md"
RUBRIC="$ROOT_DIR/tests/judge-rubric.md"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
REPORT_DIR="$ROOT_DIR/tests/reports/$STAMP"
SANDBOX=""
JUDGE_INPUT=""

require_file() {
  : '
  require_file PATH

  Abort with exit 2 if PATH does not exist or is empty.
  '
  [[ -s "$1" ]] || { echo "[test-skill-local] missing or empty: $1" >&2; exit 2; }
}

require_cmd() {
  : '
  require_cmd NAME

  Abort with exit 2 if NAME is not on PATH.
  '
  command -v "$1" >/dev/null 2>&1 \
    || { echo "[test-skill-local] required command not found: $1" >&2; exit 2; }
}

cleanup() {
  [[ -n "$SANDBOX" && -d "$SANDBOX" ]] && rm -rf "$SANDBOX"
  [[ -n "$JUDGE_INPUT" && -f "$JUDGE_INPUT" ]] && rm -f "$JUDGE_INPUT"
  return 0
}

main() {
  require_cmd claude
  require_file "$FIXTURE"
  require_file "$PROMPT_RUN"
  require_file "$RUBRIC"
  [[ -d "$BUNDLE" ]] || { echo "[test-skill-local] bundle missing: $BUNDLE" >&2; exit 2; }

  SANDBOX="$(mktemp -d)"
  trap cleanup EXIT

  mkdir -p "$REPORT_DIR"
  mkdir -p "$SANDBOX/.claude/skills"
  cp -R "$BUNDLE" "$SANDBOX/.claude/skills/harness-init"

  echo "[test-skill-local] sandbox: $SANDBOX"
  echo "[test-skill-local] report dir: $REPORT_DIR"

  local run_prompt
  run_prompt="$(cat "$PROMPT_RUN")"$'\n\n```json\n'"$(cat "$FIXTURE")"$'\n```\n'

  echo "[test-skill-local] Run phase: invoking claude -p..."
  (
    cd "$SANDBOX"
    claude -p "$run_prompt" --permission-mode bypassPermissions
  ) > "$REPORT_DIR/run-stdout.log"

  if ! grep -q '^RUN_DONE$' "$REPORT_DIR/run-stdout.log"; then
    echo "[test-skill-local] WARNING: RUN_DONE marker not found in run stdout" >&2
  fi

  mkdir -p "$REPORT_DIR/generated"
  (
    cd "$SANDBOX"
    find . -mindepth 1 \( -path './.claude' -prune \) -o -print \
      | while IFS= read -r entry; do
          [[ "$entry" == "." ]] && continue
          if [[ -d "$entry" ]]; then
            mkdir -p "$REPORT_DIR/generated/$entry"
            continue
          fi
          mkdir -p "$REPORT_DIR/generated/$(dirname "$entry")"
          cp "$entry" "$REPORT_DIR/generated/$entry"
        done
  )

  local judge_prompt
  JUDGE_INPUT="$(mktemp)"
  {
    cat "$RUBRIC"
    echo ""
    echo "## Generated Tree"
    (
      cd "$SANDBOX"
      find . -type f -not -path './.claude/*' | sort | while IFS= read -r f; do
        echo ""
        echo "### ${f#./}"
        echo '```'
        cat "$f"
        echo '```'
      done
    )
  } > "$JUDGE_INPUT"

  echo "[test-skill-local] Judge phase: invoking claude -p..."
  judge_prompt="$(cat "$JUDGE_INPUT")"
  claude -p "$judge_prompt" --permission-mode bypassPermissions \
    > "$REPORT_DIR/report.md"

  echo "[test-skill-local] report: $REPORT_DIR/report.md"

  if grep -q '^- \[FAIL\]' "$REPORT_DIR/report.md"; then
    echo "[test-skill-local] hard-checklist FAIL detected; exiting 1" >&2
    exit 1
  fi
}

main "$@"
