---
name: create-task
description: Gather task details and scaffold a new area task in tasks/active/, creating TASK.md plus notes, handoffs, and artifacts folders.
---

# Create Task

Create a new task inside a area.

## Responsibilities

- interview the human before scaffolding when task details are incomplete
- determine the target area
- allocate the next task id within that area
- create `tasks/active/<task-id>-<slug>/`
- create `TASK.md`
- create `notes/`, `handoffs/`, and `artifacts/`
- assign the task to a role or `human`
- use the templates in `skills/create-task/assets/`
- call the scaffold script only after the task details are clear

## Inputs

- area name
- task name
- goal
- description
- assignee
- optional relevant repositories

## Interview Guidance

Before scaffolding, gather enough detail for the task to be useful in a later session.

The interview should aim to clarify:

- area
- task name
- goal
- description
- assignee
- optional relevant repositories

Do not push the interview into the script. The agent should gather the task details first, then call `scripts/create-task.sh` with explicit arguments.

## Output

Create:

- `areas/<area>/tasks/active/<task-id>-<slug>/TASK.md`
- `areas/<area>/tasks/active/<task-id>-<slug>/notes/`
- `areas/<area>/tasks/active/<task-id>-<slug>/handoffs/`
- `areas/<area>/tasks/active/<task-id>-<slug>/artifacts/`
