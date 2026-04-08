---
name: create-role
description: Create a new role with a sensible first draft of ROLE.md, a MEMORY.md file, and minimal role scaffolding.
---

# Create Role

Use this skill when the user wants to create a new role.

A role defines a reusable operating perspective for work, such as product strategist, delivery lead, researcher, or designer. Roles should be durable enough to reuse across multiple areas and projects.

Use `references/ROLE.md` as the canonical guide for the structure and content of `ROLE.md`.

## Goals

- Create a clear, durable role entrypoint.
- Keep the first draft simple and reviewable.
- Scaffold the minimum files needed for the role to be useful immediately.
- Avoid inventing extra structure unless the user asks for it.

## Inputs

Gather or infer the following:

- Proposed role name.
- Short description.
- Any known responsibilities, boundaries, working style, standards, or reference files that should shape the first draft.

If the request is straightforward, prefer making a sensible first draft over asking too many questions.
Only stop to ask questions when the role boundary or purpose is genuinely unclear.

You must confirm the role name with the user before scaffolding anything.
If the user suggests multiple possible names, ask them to choose one.

## Output

Create this structure:

```text
roles/<role>/
  ROLE.md
  MEMORY.md
```

Use `assets/MEMORY.md` as the template for `roles/<role>/MEMORY.md`.
If it does not exist, create an empty `MEMORY.md`.

Create `roles/<role>/ROLE.md` as a sensible first draft based on the user request.
Populate the body sections with a sensible first draft based on the user request.
If some details are unknown, leave the structure in place and keep placeholders minimal and obvious.

The script is responsible for writing the frontmatter.
Do not include frontmatter in the generated stdin content.

## Naming

- Prefer names that describe the role, not the current assignee.
- Preserve established workspace naming conventions when they already exist.
- Prefer durable names such as `product-strategist`, `delivery-lead`, or `researcher` when the workspace uses kebab-case.
- If the workspace uses raw names with spaces or another convention, preserve that convention.
- Do not create overlapping role names unless the user clearly wants them.

## Behavior

- Propose a role name if the user has not given one.
- Show the proposed role name and draft `ROLE.md` body, and ask the user to confirm them.
- Do not scaffold anything until the role name is confirmed.
- Keep the role reusable; avoid overfitting it to a single project unless the user explicitly wants a project-specific role.

## Scaffolding

- After the user confirms the role name, pipe the generated `ROLE.md` body into `scripts/create-role.sh`.
- Run the script in this form:

  ```bash
  <ROLE.md body> | scripts/create-role.sh <role-name> <role-description>
  ```

- Pass the confirmed role name as the first argument.
- Pass the short role description as the second argument.
- Pass only the markdown body on stdin. Do not pass frontmatter.
