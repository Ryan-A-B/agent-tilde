#!/usr/bin/env bash
set -euo pipefail

root="projects"

if [[ ! -d "$root" ]]; then
  exit 0
fi

find "$root" -mindepth 1 -maxdepth 1 -type d | sort | while read -r project_dir; do
  slug="$(basename "$project_dir")"
  project_file="$project_dir/PROJECT.md"

  name=""
  description=""
  assignee=""
  status=""
  areas=""

  if [[ -f "$project_file" ]]; then
    in_frontmatter=0
    frontmatter_done=0
    while IFS= read -r line; do
      if [[ $frontmatter_done -eq 0 && "$line" == '---' ]]; then
        if [[ $in_frontmatter -eq 0 ]]; then
          in_frontmatter=1
          continue
        else
          frontmatter_done=1
          break
        fi
      fi

      if [[ $in_frontmatter -eq 1 ]]; then
        case "$line" in
          name:*) name="${line#name: }" ;;
          description:*) description="${line#description: }" ;;
          assignee:*) assignee="${line#assignee: }" ;;
          status:*) status="${line#status: }" ;;
          areas:*) ;;
          "  - "*)
            area="${line#  - }"
            if [[ -n "$areas" ]]; then
              areas="$areas, $area"
            else
              areas="$area"
            fi
            ;;
        esac
      fi
    done < "$project_file"
  fi

  printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$slug" \
    "$name" \
    "$description" \
    "$assignee" \
    "$status" \
    "$areas"
done