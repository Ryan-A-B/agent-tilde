#!/usr/bin/env bash
set -euo pipefail

workspace_root="${1:-.}"
shift || true

area_name=""
area_purpose=""
audience=""
constraints=""
workflow_hints=""
declare -a repo_specs=()

usage() {
  cat <<'EOF'
Usage:
  create-area.sh <workspace-root> --name <area> --purpose <purpose> --audience <audience> [options]

Options:
  --constraints <text>
  --workflow-hints <text>
  --repo <source-or-name=source>   May be passed multiple times.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)
      area_name="${2:-}"
      shift 2
      ;;
    --purpose)
      area_purpose="${2:-}"
      shift 2
      ;;
    --audience)
      audience="${2:-}"
      shift 2
      ;;
    --constraints)
      constraints="${2:-}"
      shift 2
      ;;
    --workflow-hints)
      workflow_hints="${2:-}"
      shift 2
      ;;
    --repo)
      repo_specs+=("${2:-}")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

slugify() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g'
}

copy_role_memories() {
  local area_dir="$1"
  local assets_dir="$2"
  local role_dir
  for role_dir in "$workspace_root"/roles/*; do
    [[ -d "$role_dir" ]] || continue
    local role_name
    role_name="$(basename "$role_dir")"
    sed "s/this role/$role_name role/g" \
      "$assets_dir/memory/role-memory.md" > "$area_dir/memory/$role_name.md"
  done
}

append_repo_entry() {
  local area_md="$1"
  local repo_name="$2"
  local repo_note="$3"
  if grep -Fq "\`repos/$repo_name/\`" "$area_md"; then
    return
  fi
  printf '\n- `repos/%s/`: %s\n' "$repo_name" "$repo_note" >> "$area_md"
}

import_repo() {
  local spec="$1"
  local repos_dir="$2"
  local name source
  if [[ "$spec" == *"="* ]]; then
    name="${spec%%=*}"
    source="${spec#*=}"
  else
    source="$spec"
    name="$(basename "$source")"
    name="${name%.git}"
  fi
  name="$(slugify "$name")"
  if [[ -z "$name" ]]; then
    echo "Could not derive repository name from: $spec" >&2
    exit 1
  fi
  if [[ -e "$repos_dir/$name" ]]; then
    echo "Repository target already exists: $repos_dir/$name" >&2
    exit 1
  fi
  git clone "$source" "$repos_dir/$name"
  printf '%s\n' "$name"
}

area_name="$(slugify "$area_name")"

if [[ -z "$area_name" ]]; then
  echo "Project name cannot be empty." >&2
  usage >&2
  exit 1
fi

area_dir="$workspace_root/areas/$area_name"
assets_dir="$workspace_root/skills/create-area/assets"

if [[ -e "$area_dir" ]]; then
  echo "Project already exists: $area_dir" >&2
  exit 1
fi

if [[ -z "$area_purpose" ]]; then
  echo "Project purpose is required." >&2
  usage >&2
  exit 1
fi

if [[ -z "$audience" ]]; then
  echo "Audience is required." >&2
  usage >&2
  exit 1
fi

mkdir -p \
  "$area_dir/context" \
  "$area_dir/memory" \
  "$area_dir/skills" \
  "$area_dir/tasks/active" \
  "$area_dir/tasks/archive" \
  "$area_dir/repos" \
  "$area_dir/worktrees"

cp "$assets_dir/AREA.md" "$area_dir/AREA.md"
cp "$assets_dir/context/README.md" "$area_dir/context/README.md"
copy_role_memories "$area_dir" "$assets_dir"

: > "$area_dir/skills/.gitkeep"
: > "$area_dir/tasks/active/.gitkeep"
: > "$area_dir/tasks/archive/.gitkeep"
: > "$area_dir/repos/.gitkeep"
: > "$area_dir/worktrees/.gitkeep"

sed -i \
  -e "s/^# Project Name$/# $area_name/" \
  -e "/^Describe what this area is for and what outcomes matter\.$/c\\$area_purpose" \
  -e "/^## Conventions$/a\\\n- Audience: $audience" \
  "$area_dir/AREA.md"

if [[ -n "$constraints" ]]; then
  printf '\n- Constraints: %s\n' "$constraints" >> "$area_dir/AREA.md"
fi

if [[ -n "$workflow_hints" ]]; then
  local_memory_files=("$area_dir"/memory/*.md)
  for memory_file in "${local_memory_files[@]}"; do
    printf '\n- Workflow hints: %s\n' "$workflow_hints" >> "$memory_file"
  done
fi

if [[ ${#repo_specs[@]} -gt 0 ]]; then
  while IFS= read -r spec; do
    repo_name="$(import_repo "$spec" "$area_dir/repos")"
    append_repo_entry "$area_dir/AREA.md" "$repo_name" "Imported repository."
  done < <(printf '%s\n' "${repo_specs[@]}")
fi

printf 'Created area: %s\n' "$area_dir"
