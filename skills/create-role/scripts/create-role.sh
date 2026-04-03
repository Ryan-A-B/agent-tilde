#!/usr/bin/env bash
set -euo pipefail

workspace_root="${1:-.}"
shift || true

role_name=""
role_description=""

usage() {
  cat <<'EOF'
Usage:
  create-role.sh <workspace-root> --name <role> --description <description>
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)
      role_name="${2:-}"
      shift 2
      ;;
    --description)
      role_description="${2:-}"
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

titleize() {
  printf '%s' "$1" \
    | tr '-' ' ' \
    | awk '{
        for (i = 1; i <= NF; i++) {
          $i = toupper(substr($i, 1, 1)) substr($i, 2)
        }
        print
      }'
}

role_name="$(slugify "$role_name")"

if [[ -z "$role_name" ]]; then
  echo "Role name cannot be empty." >&2
  usage >&2
  exit 1
fi

if [[ -z "$role_description" ]]; then
  echo "Role description is required." >&2
  usage >&2
  exit 1
fi

role_dir="$workspace_root/roles/$role_name"
assets_dir="$workspace_root/skills/create-role/assets"

if [[ -e "$role_dir" ]]; then
  echo "Role already exists: $role_dir" >&2
  exit 1
fi

mkdir -p "$role_dir/skills"
cp "$assets_dir/MEMORY.md" "$role_dir/MEMORY.md"

role_title="$(titleize "$role_name")"
sed \
  -e "s/^name: role-name$/name: $role_name/" \
  -e "s/^description: Short description used for role selection\.$/description: $role_description/" \
  -e "s/^# Role Name$/# $role_title/" \
  "$assets_dir/ROLE.md" > "$role_dir/ROLE.md"

: > "$role_dir/skills/.gitkeep"

printf 'Created role: %s\n' "$role_dir"
