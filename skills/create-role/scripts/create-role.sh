#!/usr/bin/env bash
set -euo pipefail

workspace_root="${1:-.}"
shift || true

role_name=""
role_file=""

usage() {
  cat <<'EOF'
Usage:
  create-role.sh <workspace-root> --name <role> --role-file <approved-role-md>

This script performs the final scaffold step only:
- creates roles/<role>/
- writes ROLE.md from the approved file
- copies MEMORY.md from skills/create-role/assets/MEMORY.md
- creates skills/.gitkeep
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)
      role_name="${2:-}"
      shift 2
      ;;
    --role-file)
      role_file="${2:-}"
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

role_name="$(slugify "$role_name")"

if [[ -z "$role_name" ]]; then
  echo "Role name cannot be empty." >&2
  usage >&2
  exit 1
fi

if [[ -z "$role_file" ]]; then
  echo "Role file is required." >&2
  usage >&2
  exit 1
fi

if [[ ! -f "$role_file" ]]; then
  echo "Role file not found: $role_file" >&2
  exit 1
fi

role_dir="$workspace_root/roles/$role_name"
memory_template="$workspace_root/skills/create-role/assets/MEMORY.md"

if [[ -e "$role_dir" ]]; then
  echo "Role already exists: $role_dir" >&2
  exit 1
fi

mkdir -p "$role_dir/skills"
cp "$role_file" "$role_dir/ROLE.md"
cp "$memory_template" "$role_dir/MEMORY.md"
: > "$role_dir/skills/.gitkeep"

printf 'Created role: %s\n' "$role_dir"
