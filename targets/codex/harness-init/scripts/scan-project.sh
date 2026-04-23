#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-.}"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "target directory not found: $TARGET_DIR"
  exit 1
fi

echo "scan target: $TARGET_DIR"
echo "top-level entries:"
find "$TARGET_DIR" -mindepth 1 -maxdepth 1 | sort

echo "docs tree:"
if [[ -d "$TARGET_DIR/docs" ]]; then
  find "$TARGET_DIR/docs" -type f | sort
else
  echo "docs directory is missing"
fi
