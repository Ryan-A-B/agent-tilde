#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <role-name> <description>" >&2
  exit 1
fi

role_name="$1"
description="$2"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skill_dir="$(cd "$script_dir/.." && pwd)"
memory_template="$skill_dir/assets/MEMORY.md"

role_dir="roles/$role_name"
role_file="$role_dir/ROLE.md"
memory_file="$role_dir/MEMORY.md"

body="$(cat)"

mkdir -p "$role_dir"

if [[ -f "$memory_template" ]]; then
  cp "$memory_template" "$memory_file"
else
  : > "$memory_file"
fi

{
  echo '---'
  printf 'name: %s\n' "$role_name"
  printf 'description: %s\n' "$description"
  echo '---'
  echo
  printf '%s\n' "$body"
} > "$role_file"

printf 'Scaffolded %s\n' "$role_dir"