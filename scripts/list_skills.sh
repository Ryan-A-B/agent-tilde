#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"

find "$root/skills" -mindepth 2 -maxdepth 2 -name SKILL.md | sort | while read -r file; do
  name=$(sed -n 's/^name:[[:space:]]*//p' "$file" | head -n 1)
  description=$(sed -n 's/^description:[[:space:]]*//p' "$file" | head -n 1)
  skill_dir=$(dirname "$file")
  printf '%s\t%s\t%s\n' "$name" "$description" "$skill_dir"
done
