#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <area-name> <description>" >&2
  exit 1
fi

area_name="$1"
description="$2"
area_dir="areas/$area_name"
area_file="$area_dir/AREA.md"

body="$(cat)"

mkdir -p "$area_dir/context" "$area_dir/roles" "$area_dir/repositories"
: > "$area_dir/context/.gitkeep"
: > "$area_dir/roles/.gitkeep"
: > "$area_dir/repositories/.gitkeep"

cat > "$area_file" <<EOF2
---
name: $area_name
description: $description
---

$body
EOF2

printf 'Scaffolded %s\n' "$area_dir"
