#!/usr/bin/env bash
set -euo pipefail

workspace_root="${1:-.}"
shift || true

project_name=""
task_name=""
goal=""
description=""
assignee=""
priority="normal"
declare -a relevant_repos=()

usage() {
  cat <<'EOF'
Usage:
  create-task.sh <workspace-root> --project <project> --name <task-name> --goal <goal> --description <description> --assignee <assignee> [options]

Options:
  --priority <priority>
  --repo <repo>   May be passed multiple times.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      project_name="${2:-}"
      shift 2
      ;;
    --name)
      task_name="${2:-}"
      shift 2
      ;;
    --goal)
      goal="${2:-}"
      shift 2
      ;;
    --description)
      description="${2:-}"
      shift 2
      ;;
    --assignee)
      assignee="${2:-}"
      shift 2
      ;;
    --priority)
      priority="${2:-}"
      shift 2
      ;;
    --repo)
      relevant_repos+=("${2:-}")
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

next_task_id() {
  local project_dir="$1"
  local max_id="0"
  local name
  while IFS= read -r name; do
    name="$(basename "$name")"
    if [[ "$name" =~ ^([0-9]{5})- ]]; then
      if (( 10#${BASH_REMATCH[1]} > 10#$max_id )); then
        max_id="${BASH_REMATCH[1]}"
      fi
    fi
  done < <(find "$project_dir/tasks" -mindepth 2 -maxdepth 2 -type d | sort)
  printf '%05d' "$((10#$max_id + 1))"
}

project_dir="$workspace_root/projects/$project_name"

if [[ -z "$project_name" ]]; then
  echo "Project name is required." >&2
  usage >&2
  exit 1
fi

if [[ ! -d "$project_dir" ]]; then
  echo "Project does not exist: $project_dir" >&2
  exit 1
fi

if [[ -z "$task_name" || -z "$goal" || -z "$description" || -z "$assignee" ]]; then
  echo "Task name, goal, description, and assignee are required." >&2
  usage >&2
  exit 1
fi

task_slug="$(slugify "$task_name")"
if [[ -z "$task_slug" ]]; then
  echo "Task name cannot be empty." >&2
  exit 1
fi

task_id="$(next_task_id "$project_dir")"
task_dir="$project_dir/tasks/active/$task_id-$task_slug"
assets_dir="$workspace_root/skills/create-task/assets"

mkdir -p "$task_dir/notes" "$task_dir/handoffs" "$task_dir/artifacts"
: > "$task_dir/notes/.gitkeep"
: > "$task_dir/handoffs/.gitkeep"
: > "$task_dir/artifacts/.gitkeep"

today="$(date -u +%F)"

{
  printf -- '---\n'
  printf 'id: %s\n' "$task_id"
  printf 'name: %s\n' "$task_name"
  printf 'status: open\n'
  printf 'assignee: %s\n' "$assignee"
  printf 'created: %s\n' "$today"
  printf 'updated: %s\n' "$today"
  printf 'priority: %s\n' "$priority"
  printf 'relevant_repos:\n'
  if [[ ${#relevant_repos[@]} -eq 0 ]]; then
    printf '  - repo-name\n'
  else
    for repo in "${relevant_repos[@]}"; do
      printf '  - %s\n' "$repo"
    done
  fi
  printf -- '---\n\n'
  printf '# Goal\n\n%s\n\n' "$goal"
  printf '## Description\n\n%s\n\n' "$description"
  sed -n '/^## Deliverables$/,$p' "$assets_dir/TASK.md"
} > "$task_dir/TASK.md"

printf 'Created task: %s\n' "$task_dir"
