#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"

find "$root/roles" -mindepth 2 -maxdepth 2 -name ROLE.md | sort | while read -r file; do
  name=$(sed -n 's/^name:[[:space:]]*//p' "$file" | head -n 1)
  description=$(sed -n 's/^description:[[:space:]]*//p' "$file" | head -n 1)
  role_dir=$(dirname "$file")
  printf '%s\t%s\t%s\n' "$name" "$description" "$role_dir"
done
