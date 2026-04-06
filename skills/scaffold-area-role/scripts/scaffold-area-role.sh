#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <area-name> <role-name>" >&2
  exit 1
fi

area_name="$1"
role_name="$2"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skill_dir="$(cd "$script_dir/.." && pwd)"
memory_template="$skill_dir/assets/role-memory.md"

role_dir="areas/$area_name/roles/$role_name"
memory_file="$role_dir/MEMORY.md"

mkdir -p "$role_dir"

if [[ -f "$memory_template" ]]; then
  cp "$memory_template" "$memory_file"
else
  : > "$memory_file"
fi

printf 'Scaffolded %s\n' "$role_dir"
