#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <project-slug>" >&2
  exit 1
fi

slug="$1"
project_dir="projects/$slug"

mkdir -p "$project_dir"/{references,handoffs,artifacts}
: > "$project_dir/references/.gitkeep"
: > "$project_dir/handoffs/.gitkeep"
: > "$project_dir/artifacts/.gitkeep"

if [[ ! -f "$project_dir/PROJECT.md" ]]; then
  : > "$project_dir/PROJECT.md"
fi

if [[ ! -f "$project_dir/NOTES.md" ]]; then
  : > "$project_dir/NOTES.md"
fi