#!/usr/bin/env bash
set -euo pipefail

: '
check-bundle-structure.sh

Validates that every runtime bundle under targets/<runtime>/harness-init/ has
the required files, SKILL.md frontmatter keys, and intra-bundle relative link
integrity. Exits non-zero on the first violation with a clear message.
'

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGETS_DIR="$ROOT_DIR/targets"

REQUIRED_COMMON=(
  "SKILL.md"
  "INSTALL.md"
  "references/templates.md"
  "scripts/scan-project.sh"
)

REQUIRED_FRONTMATTER_KEYS=(
  "name:"
  "description:"
  "disable-model-invocation:"
)

fail() {
  echo "[check-bundle-structure] FAIL: $1" >&2
  exit 1
}

check_bundle() {
  local runtime="$1"
  local bundle="$TARGETS_DIR/$runtime/harness-init"
  local rel path skill doc doc_dir refs ref

  [[ -d "$bundle" ]] || fail "$runtime: bundle directory missing: $bundle"

  for rel in "${REQUIRED_COMMON[@]}"; do
    path="$bundle/$rel"
    [[ -s "$path" ]] || fail "$runtime: required file missing or empty: $rel"
  done

  [[ -x "$bundle/scripts/scan-project.sh" ]] \
    || fail "$runtime: scripts/scan-project.sh is not executable"

  skill="$bundle/SKILL.md"
  head -1 "$skill" | grep -q '^---$' \
    || fail "$runtime: SKILL.md is missing its YAML frontmatter opener"
  for rel in "${REQUIRED_FRONTMATTER_KEYS[@]}"; do
    grep -q "^$rel" "$skill" \
      || fail "$runtime: SKILL.md frontmatter missing key: $rel"
  done

  if [[ "$runtime" == "antigravity" ]]; then
    [[ -s "$bundle/PROMPT.md" ]] \
      || fail "$runtime: PROMPT.md missing or empty"
  fi

  for doc in "$skill" "$bundle/INSTALL.md"; do
    doc_dir="$(dirname "$doc")"
    refs="$(grep -oE '\]\([^)]+\)' "$doc" | sed -E 's/^\]\(|\)$//g' || true)"
    while IFS= read -r ref; do
      [[ -z "$ref" ]] && continue
      case "$ref" in
        http*|/*|\#*) continue ;;
      esac
      ref="${ref%%#*}"
      [[ -z "$ref" ]] && continue
      [[ -e "$doc_dir/$ref" ]] \
        || fail "$runtime: $doc references non-existent path: $ref"
    done <<< "$refs"
  done

  echo "[check-bundle-structure] PASS: $runtime"
}

for runtime in claude claude-code codex antigravity; do
  check_bundle "$runtime"
done

echo "[check-bundle-structure] All bundles OK."
