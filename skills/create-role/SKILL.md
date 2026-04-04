---
name: create-role
description: Draft and scaffold a new broad, non-overlapping role in roles/, showing a proposed ROLE.md in chat first and writing files only after approval.
---

# Create Role

Draft and scaffold a new role under `roles/<role>/`.

## Responsibilities

- interview the human before any scaffolding happens
- encourage broad, stable, non-overlapping role definitions
- default to a one-shot first draft when the requested role is straightforward
- display a proposed `ROLE.md` draft before writing files
- iterate on the draft in conversation until the human is happy
- create `ROLE.md`, `MEMORY.md`, and `skills/` only after the draft is accepted
- use `references/examples/` for broad example roles when useful
- keep `MEMORY.md` static from `skills/create-role/assets/MEMORY.md`
- call the script only for the final write step after approval

## Inputs

- role name
- role description
- optional initial responsibilities
- optional initial out-of-scope rules

## Interview Guidance

Before scaffolding, help the human avoid overly narrow or overlapping roles.

Default behavior:

- if the requested role is broad and clear, draft it directly from the role name and a sensible default scope
- use `references/examples/` as input when they help
- show the draft in chat
- refine it if needed
- scaffold the role only after the human approves the draft

Do not force a detailed questionnaire for obvious broad roles such as `marketer`, `developer`, `qa`, or `support`.

The interview should aim to clarify:

- what work this role owns
- what work is explicitly out of scope
- how this role differs from existing roles
- whether the proposed role should instead be handled by a skill on an existing broad role

Prefer broad, stable role boundaries such as `developer`, `marketer`, `qa`, or `support`.

Avoid creating roles that are:

- too narrow
- likely to overlap heavily with an existing role
- better modeled as skills, workflows, or area-specific memory

Do not push the interview or drafting into the script. The agent should gather the answers only when needed, challenge weak role boundaries, draft the `ROLE.md` in chat, and then call `scripts/create-role.sh` only to write the approved files.

## Output

Create:

- `roles/<role>/ROLE.md`
- `roles/<role>/MEMORY.md`
- `roles/<role>/skills/.gitkeep`
