---
name: create-project
description: Create a new project with a sensible first draft of PROJECT.md, notes scaffolding, and supporting folders.
---

# Create Project

Use this skill when the user wants to create a new project.

A project is a bounded piece of work with a clear outcome, unlike an area which is an ongoing domain of responsibility.

Use `references/PROJECT.md` as the canonical guide for the structure and content of `PROJECT.md`.

## Goals

- Create a clear, durable project entrypoint.
- Keep the first draft simple and reviewable.
- Scaffold the minimum files and folders needed for delivery and future handoff.
- Avoid inventing extra structure unless the user asks for it.

## Inputs

Gather or infer the following:

- Proposed project name.
- Short description.
- Assignee.
- Relevant areas, if any.
- Any known standards, constraints, or reference files that should be reflected in the first draft.

If the request is straightforward, prefer making a sensible first draft over asking too many questions.
Only stop to ask questions when the project boundary or ownership is genuinely unclear.

You must confirm the project name with the user before scaffolding anything.
If the user suggests multiple possible names, ask them to choose one.

## Output

Create this structure:

```text
projects/<project>/
  PROJECT.md
  NOTES.md
  references/
  handoffs/
  artifacts/
```

Add `.gitkeep` files to empty folders that should exist but do not yet contain real files.

Use `assets/NOTES.md` as the template for `projects/<project>/NOTES.md` when it exists.
If it does not exist, create an empty `NOTES.md`.

Create `projects/<project>/PROJECT.md` as a sensible first draft based on the user request.
Populate the body sections with a sensible first draft based on the user request.
If some details are unknown, leave the structure in place and keep placeholders minimal and obvious.

The script is responsible for writing the frontmatter.
Do not include frontmatter in the generated stdin content.

The `areas:` frontmatter field must always be present.
If no areas are provided, leave it as an empty block rather than inventing entries.

## Naming

- Prefer lowercase kebab-case only when the workspace already uses it for project directory names.
- Keep names specific enough to identify the initiative, but broad enough to survive normal scope changes.
- Do not create duplicate or overlapping project names unless the user clearly wants them.
- Preserve established workspace naming conventions when they already exist.

## Behavior

- Propose a project name if the user has not given one.
- Show the proposed project name and draft `PROJECT.md` body, and ask the user to confirm them.
- Do not scaffold anything until the project name is confirmed.
- If areas are relevant but not explicitly given, infer them conservatively or leave the field empty.

## Scaffolding

- After the user confirms the project name, pipe the generated `PROJECT.md` body into `scripts/create-project.sh`.
- Run the script in this form:

  ```bash
  <PROJECT.md body> | scripts/create-project.sh <project-name> <project-title> <project-description> <assignee> [area ...]
  ```

- Pass the confirmed project directory name as the first argument.
- Pass the human-readable project title as the second argument.
- Pass the short project description as the third argument.
- Pass the assignee as the fourth argument.
- Pass any area names as remaining arguments.
- Pass only the markdown body on stdin. Do not pass frontmatter.
