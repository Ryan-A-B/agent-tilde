# Create Role

Scaffold a new role under `roles/<role>/`.

## Responsibilities

- interview the human before any scaffolding happens
- encourage broad, stable, non-overlapping role definitions
- create `ROLE.md`
- create `MEMORY.md`
- create `skills/`
- ensure `skills/.gitkeep` exists
- use the templates in `skills/create-role/assets/`
- call the scaffold script only after the role name and description are clear

## Inputs

- role name
- role description
- optional initial responsibilities
- optional initial out-of-scope rules

## Interview Guidance

Before scaffolding, help the human avoid overly narrow or overlapping roles.

The interview should aim to clarify:

- what work this role owns
- what work is explicitly out of scope
- how this role differs from existing roles
- whether the proposed role should instead be handled by a skill on an existing broad role

Prefer broad, stable role boundaries such as `developer`, `marketer`, `qa`, or `support`.

Avoid creating roles that are:

- too narrow
- likely to overlap heavily with an existing role
- better modeled as skills, workflows, or project-specific memory

Do not push the interview into the script. The agent should gather the answers, challenge weak role boundaries, and then call `scripts/create-role.sh` with explicit arguments.

## Output

Create:

- `roles/<role>/ROLE.md`
- `roles/<role>/MEMORY.md`
- `roles/<role>/skills/.gitkeep`
