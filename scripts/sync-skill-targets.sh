#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$ROOT_DIR/skill"
TARGETS_DIR="$ROOT_DIR/targets"
BUNDLE_NAME="harness-init"

prepare_bundle() {
  local target_name="$1"
  local bundle_dir="$TARGETS_DIR/$target_name/$BUNDLE_NAME"

  rm -rf "$bundle_dir"
  mkdir -p "$bundle_dir"

  cp "$SKILL_DIR/SKILL.md" "$bundle_dir/SKILL.md"
  cp -R "$SKILL_DIR/references" "$bundle_dir/references"
  cp -R "$SKILL_DIR/scripts" "$bundle_dir/scripts"
  cp "$SKILL_DIR/runtime-guides/$target_name/INSTALL.md" "$bundle_dir/INSTALL.md"

  if [[ -f "$SKILL_DIR/runtime-guides/$target_name/PROMPT.md" ]]; then
    cp "$SKILL_DIR/runtime-guides/$target_name/PROMPT.md" "$bundle_dir/PROMPT.md"
  fi
}

prepare_bundle "claude"
prepare_bundle "claude-code"
prepare_bundle "codex"
prepare_bundle "antigravity"
