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
  echo "[test-skill-local] scaffold OK (no model calls yet)"
}

main "$@"
