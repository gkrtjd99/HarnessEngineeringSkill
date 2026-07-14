#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-.}"

print_section() {
  printf '\n## %s\n' "$1"
}

relative_paths() {
  local path

  while IFS= read -r path; do
    printf '%s\n' "${path#"$TARGET_DIR"/}"
  done
}

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "target directory not found: $TARGET_DIR"
  exit 1
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo "# Repository Inventory"
echo
echo "Target: \`$TARGET_DIR\`"

top_level="$(find "$TARGET_DIR" -mindepth 1 -maxdepth 1 -exec basename {} \; 2>/dev/null | LC_ALL=C sort || true)"
print_section "Top-level entries"
if [[ -n "$top_level" ]]; then
  printf '%s\n' "$top_level" | sed 's#^#- #'
else
  echo "- empty directory"
fi

instruction_files="$(find "$TARGET_DIR" \( -path "$TARGET_DIR/.git" -o -path "$TARGET_DIR/node_modules" -o -path "$TARGET_DIR/vendor" \) -prune -o -type f \( -name AGENTS.md -o -name CLAUDE.md -o -name CONTRIBUTING.md \) -print 2>/dev/null | relative_paths | LC_ALL=C sort || true)"
print_section "Existing agent and contributor instructions"
if [[ -n "$instruction_files" ]]; then
  printf '%s\n' "$instruction_files" | sed 's#^#- #'
else
  echo "- none found"
fi

manifest_files="$(find "$TARGET_DIR" -maxdepth 3 \( -path "$TARGET_DIR/.git" -o -path "$TARGET_DIR/node_modules" -o -path "$TARGET_DIR/vendor" \) -prune -o -type f \( -name package.json -o -name pyproject.toml -o -name Cargo.toml -o -name go.mod -o -name pom.xml -o -name build.gradle -o -name build.gradle.kts -o -name Makefile -o -name justfile \) -print 2>/dev/null | relative_paths | LC_ALL=C sort || true)"
print_section "Build and package manifests"
if [[ -n "$manifest_files" ]]; then
  printf '%s\n' "$manifest_files" | sed 's#^#- #'
else
  echo "- none found"
fi

automation_files="$(find "$TARGET_DIR" -maxdepth 4 \( -path "$TARGET_DIR/.git" -o -path "$TARGET_DIR/node_modules" -o -path "$TARGET_DIR/vendor" \) -prune -o -type f \( -path '*/.github/workflows/*' -o -path '*/scripts/*' -o -name docker-compose.yml -o -name docker-compose.yaml -o -name Dockerfile \) -print 2>/dev/null | relative_paths | LC_ALL=C sort || true)"
print_section "Automation and runtime configuration"
if [[ -n "$automation_files" ]]; then
  printf '%s\n' "$automation_files" | sed 's#^#- #'
else
  echo "- none found"
fi

doc_files="$(find "$TARGET_DIR"/docs -type f -print 2>/dev/null | relative_paths | LC_ALL=C sort || true)"
print_section "Documentation files"
if [[ -n "$doc_files" ]]; then
  printf '%s\n' "$doc_files" | sed 's#^#- #'
else
  echo "- no docs directory or no documentation files"
fi

print_section "Likely code areas"
code_areas=""
for area in app apps src server api backend frontend web packages services workers infra terraform .github scripts tests test; do
  if [[ -d "$TARGET_DIR/$area" ]]; then
    code_areas+="$area\n"
  fi
done
if [[ -n "$code_areas" ]]; then
  printf '%b' "$code_areas" | LC_ALL=C sort -u | sed 's#^#- #'
else
  echo "- no conventional code-area directories found"
fi

print_section "Next reading order"
echo "- Read existing instructions and README files before proposing harness changes."
echo "- Read the listed manifests and automation files to derive verified commands."
echo "- Treat this inventory as discovery evidence, not proof of architecture or ownership."
