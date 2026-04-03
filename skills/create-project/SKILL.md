---
name: create-project
description: Interview for and scaffold a new project in projects/, optionally pulling in existing repositories after the project shape is clear.
---

# Create Project

Scaffold a new project under `projects/<project>/`.

This skill creates a new workspace project. The project may start empty or may immediately include one or more existing repositories under `projects/<project>/repos/`.

## Responsibilities

- interview the human before any scaffolding happens
- create the standard project folder structure
- create `PROJECT.md`
- create `context/`
- create `memory/`
- create `skills/`
- create `tasks/active/` and `tasks/archive/`
- create `repos/`
- create `worktrees/`
- seed role memory files for the default roles
- optionally pull in or attach existing repositories
- gather enough initial context from the human to seed the project cleanly
- call the scaffold script only after the interview inputs are clear

## Inputs

- project name
- project purpose
- audience
- whether the project starts with existing repositories
- optional initial repositories
- optional initial conventions, goals, and constraints
- optional workflow hints

## Interview Guidance

Run an initial interview before scaffolding. The interview should aim to clarify:

- project purpose
- primary repositories
- who the project is for
- important constraints
- preferred default role memory or workflow hints

Do not push the interview into the script. The agent should gather the answers, confirm the intended project shape, and then call `scripts/create-project.sh` with explicit arguments.

## Output

Create a new project using the assets under `skills/create-project/assets/`.
