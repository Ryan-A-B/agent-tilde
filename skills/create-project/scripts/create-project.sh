#!/usr/bin/env bash
set -euo pipefail

workspace_root="${1:-.}"
shift || true

project_name=""
project_purpose=""
audience=""
constraints=""
workflow_hints=""
declare -a repo_specs=()

usage() {
  cat <<'EOF'
Usage:
  create-project.sh <workspace-root> --name <project> --purpose <purpose> --audience <audience> [options]

Options:
  --constraints <text>
  --workflow-hints <text>
  --repo <source-or-name=source>   May be passed multiple times.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)
      project_name="${2:-}"
      shift 2
      ;;
    --purpose)
      project_purpose="${2:-}"
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
  local project_dir="$1"
  local assets_dir="$2"
  local role_dir
  for role_dir in "$workspace_root"/roles/*; do
    [[ -d "$role_dir" ]] || continue
    local role_name
    role_name="$(basename "$role_dir")"
    sed "s/this role/$role_name role/g" \
      "$assets_dir/memory/role-memory.md" > "$project_dir/memory/$role_name.md"
  done
}

append_repo_entry() {
  local project_md="$1"
  local repo_name="$2"
  local repo_note="$3"
  if grep -Fq "\`repos/$repo_name/\`" "$project_md"; then
    return
  fi
  printf '\n- `repos/%s/`: %s\n' "$repo_name" "$repo_note" >> "$project_md"
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

project_name="$(slugify "$project_name")"

if [[ -z "$project_name" ]]; then
  echo "Project name cannot be empty." >&2
  usage >&2
  exit 1
fi

project_dir="$workspace_root/projects/$project_name"
assets_dir="$workspace_root/skills/create-project/assets"

if [[ -e "$project_dir" ]]; then
  echo "Project already exists: $project_dir" >&2
  exit 1
fi

if [[ -z "$project_purpose" ]]; then
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
  "$project_dir/context" \
  "$project_dir/memory" \
  "$project_dir/skills" \
  "$project_dir/tasks/active" \
  "$project_dir/tasks/archive" \
  "$project_dir/repos" \
  "$project_dir/worktrees"

cp "$assets_dir/PROJECT.md" "$project_dir/PROJECT.md"
cp "$assets_dir/context/README.md" "$project_dir/context/README.md"
copy_role_memories "$project_dir" "$assets_dir"

: > "$project_dir/skills/.gitkeep"
: > "$project_dir/tasks/active/.gitkeep"
: > "$project_dir/tasks/archive/.gitkeep"
: > "$project_dir/repos/.gitkeep"
: > "$project_dir/worktrees/.gitkeep"

sed -i \
  -e "s/^# Project Name$/# $project_name/" \
  -e "/^Describe what this project is for and what outcomes matter\.$/c\\$project_purpose" \
  -e "/^## Conventions$/a\\\n- Audience: $audience" \
  "$project_dir/PROJECT.md"

if [[ -n "$constraints" ]]; then
  printf '\n- Constraints: %s\n' "$constraints" >> "$project_dir/PROJECT.md"
fi

if [[ -n "$workflow_hints" ]]; then
  local_memory_files=("$project_dir"/memory/*.md)
  for memory_file in "${local_memory_files[@]}"; do
    printf '\n- Workflow hints: %s\n' "$workflow_hints" >> "$memory_file"
  done
fi

if [[ ${#repo_specs[@]} -gt 0 ]]; then
  while IFS= read -r spec; do
    repo_name="$(import_repo "$spec" "$project_dir/repos")"
    append_repo_entry "$project_dir/PROJECT.md" "$repo_name" "Imported repository."
  done < <(printf '%s\n' "${repo_specs[@]}")
fi

printf 'Created project: %s\n' "$project_dir"
