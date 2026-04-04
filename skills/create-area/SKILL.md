---
name: create-area
description: Interview for and scaffold a new area in areas/, optionally pulling in existing repositories after the area shape is clear.
---

# Create Area

Scaffold a new area under `areas/<area>/`.

This skill creates a new workspace area. The area may start empty or may immediately include one or more existing repositories under `areas/<area>/repos/`.

## Responsibilities

- interview the human before any scaffolding happens
- create the standard area folder structure
- create `AREA.md`
- create `context/`
- create `memory/`
- create `skills/`
- create `tasks/active/` and `tasks/archive/`
- create `repos/`
- create `worktrees/`
- seed role memory files for the default roles
- optionally pull in or attach existing repositories
- gather enough initial context from the human to seed the area cleanly
- call the scaffold script only after the interview inputs are clear

## Inputs

- area name
- area purpose
- audience
- whether the area starts with existing repositories
- optional initial repositories
- optional initial conventions, goals, and constraints
- optional workflow hints

## Interview Guidance

Run an initial interview before scaffolding. The interview should aim to clarify:

- area purpose
- primary repositories
- who the area is for
- important constraints
- preferred default role memory or workflow hints

Do not push the interview into the script. The agent should gather the answers, confirm the intended area shape, and then call `scripts/create-area.sh` with explicit arguments.

## Output

Create a new area using the assets under `skills/create-area/assets/`.
