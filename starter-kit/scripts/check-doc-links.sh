#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-.}"
status=0

while IFS= read -r file; do
  source_dir="$(cd "$(dirname "$file")" && pwd)"

  while IFS= read -r target; do
    normalized="${target#<}"
    normalized="${normalized%>}"
    normalized="${normalized%%#*}"

    if [[ -z "$normalized" ]]; then
      continue
    fi

    if [[ "$normalized" =~ ^https?:// ]] || [[ "$normalized" =~ ^mailto: ]] || [[ "$normalized" =~ ^# ]]; then
      continue
    fi

    if [[ "$normalized" =~ ^/ ]]; then
      candidate="$normalized"
    else
      candidate="$source_dir/$normalized"
    fi

    candidate="${candidate%%:*}"

    if [[ ! -e "$candidate" ]]; then
      echo "broken link: $file -> $target"
      status=1
    fi
  done < <(grep -oE '\[[^]]+\]\(([^)]+)\)' "$file" | sed -E 's/.*\(([^)]+)\)/\1/' || true)
done < <(find "$ROOT_DIR/docs" -type f -name '*.md' | sort)

exit "$status"
