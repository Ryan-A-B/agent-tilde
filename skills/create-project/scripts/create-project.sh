#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 4 ]]; then
  echo "Usage: $0 <project-slug> <name> <description> <assignee> [area ...]" >&2
  exit 1
fi

project_slug="$1"
name="$2"
description="$3"
assignee="$4"
shift 4
areas=("$@")

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skill_dir="$(cd "$script_dir/.." && pwd)"
notes_template="$skill_dir/assets/NOTES.md"

project_dir="projects/$project_slug"
project_file="$project_dir/PROJECT.md"
notes_file="$project_dir/NOTES.md"

body="$(cat)"

mkdir -p "$project_dir/references" "$project_dir/handoffs" "$project_dir/artifacts"
: > "$project_dir/references/.gitkeep"
: > "$project_dir/handoffs/.gitkeep"
: > "$project_dir/artifacts/.gitkeep"

if [[ -f "$notes_template" ]]; then
  cp "$notes_template" "$notes_file"
else
  : > "$notes_file"
fi

{
  echo '---'
  printf 'name: %s\n' "$name"
  printf 'description: %s\n' "$description"
  printf 'assignee: %s\n' "$assignee"
  echo 'areas:'
  if [[ ${#areas[@]} -gt 0 ]]; then
    for area in "${areas[@]}"; do
      printf '  - %s\n' "$area"
    done
  fi
  echo 'status: open'
  echo '---'
  echo
  printf '%s\n' "$body"
} > "$project_file"

printf 'Scaffolded %s\n' "$project_dir"