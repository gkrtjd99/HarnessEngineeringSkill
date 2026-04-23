#!/usr/bin/env bash
set -euo pipefail

DOCS_DIR="${1:-docs/design-docs}"
status=0

while IFS= read -r file; do
  if ! grep -Eq '^# ' "$file"; then
    echo "missing top heading: $file"
    status=1
  fi
done < <(find "$DOCS_DIR" -type f -name '*.md' | sort)

exit "$status"
