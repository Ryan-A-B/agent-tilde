---
name: create-area
description: Create a new area with a sensible first draft of AREA.md, role memory files, and context scaffolding.
---

# Create Area

Use this skill when the user wants to create a new area.

An area is an ongoing domain of responsibility, such as a product, brand, or business function. When appropriate, name areas using the pattern `<product>:<function>`.

Use `references/AREA.md` as the canonical guide for the structure and content of `AREA.md`.

## Goals

- Create a clear, durable area entrypoint.
- Keep the first draft simple and reviewable.
- Scaffold the minimum files and folders needed for future work.
- Avoid inventing extra structure unless the user asks for it.

## Inputs

Gather or infer the following:

- Proposed area name.
- Short description.
- Any known standards, constraints, or reference files that should be included in the first draft.

If the request is straightforward, prefer making a sensible first draft over asking too many questions.
Only stop to ask questions when the boundary of the area is genuinely unclear.

You must confirm the area name with the user before scaffolding anything.
If the user suggests multiple possible names, ask them to choose one.

## Output

Create this structure:

```text
areas/<area>/
  AREA.md
  context/
  roles/
```

Add `.gitkeep` files to empty folders that should exist but do not yet contain real files.

Use `assets/AREA.md` as the template for `areas/<area>/AREA.md`.
Populate it with a sensible first draft based on the user request.
If some details are unknown, keep the structure and leave only minimal obvious placeholders.

Populate the frontmatter and sections with a sensible first draft based on the user request.
If some details are unknown, leave the structure in place and keep placeholders minimal and obvious.

## Naming

- Prefer lowercase kebab-case only when the workspace already uses it for area directory names.
- If the workspace uses raw names with `:` separators, preserve that convention.
- When the area is product-specific and function-specific, prefer `<product>:<function>`.
- Keep names broad enough to last across multiple projects.
- Do not create overlapping area names unless the user clearly wants them.

## Behavior
- Propose an area name if the user has not given one.
- Show the proposed area name and draft `AREA.md`, and ask the user to confirm them.
- Do not scaffold anything until the area name is confirmed.

## Scaffolding
- After the user confirms the area name, pipe the generated `AREA.md` content into `scripts/create-area.sh`.
- Run the script in this form:

  ```bash
  <AREA.md content> | <skill dir>/scripts/create-area.sh <area-name> <area-description>
  ```

- Pass the confirmed area name as the first argument.
- Pass the full `AREA.md` document on stdin.