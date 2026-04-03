# Agent Workspace

This workspace is a file-based system for working with distinct agent roles across projects.

## Core Rules

- Work on only one role per session.
- Work on only one project per session.
- Do not switch role mid-session.
- Do not switch project mid-session.
- If a request is out of scope for the active role or project, recommend starting a new session.
- If the project is unclear, ask. Do not guess.
- If the role is unclear, inspect available roles and choose the best fit before continuing.

## Startup Routine

1. Determine whether the session is task-based or direct work.
2. If the user named a task, open the task first.
3. Determine the project from the task path or from the user's request.
4. If the project is unclear, ask before loading project context.
5. Determine the role:
   - For a task, prefer the task assignee.
   - Otherwise, read only the frontmatter `name` and `description` from each `roles/*/ROLE.md` file and choose the best fit.
6. Once the role is selected, do not change it for the rest of the session.
7. Load `roles/<role>/ROLE.md`.
8. Load `roles/<role>/MEMORY.md`.
9. Load `projects/<project>/PROJECT.md`.
10. Load `projects/<project>/memory/<role>.md` if it exists.
11. If working on a task, read `TASK.md` and any relevant files in `notes/`, `handoffs/`, and `artifacts/`.

## Scope Guidance

Use the active role for work that matches its responsibilities.

If the request belongs to another role:

- update the current task if needed
- recommend starting a new session in the appropriate role
- do not continue by switching roles in the same session

## Memory System

Maintain memory for the active role only.

Memory files:

- Global role memory: `roles/<role>/MEMORY.md`
- Project-role memory: `projects/<project>/memory/<role>.md`

Update memory when the user corrects you or when you learn a durable preference, process rule, or role-specific project convention.

Do not store task progress in memory. Put task progress in task notes.

Do not store shared project facts in role memory. Put shared facts in:

- `projects/<project>/PROJECT.md` for project-level guidance
- files under `projects/<project>/context/` for supporting context
- the repository itself when the information should be source-of-truth documentation for humans and agents

Keep memory current by updating in place. Replace outdated information instead of appending contradictory notes. Each memory file should reflect the latest known state.

Use this structure in every `MEMORY.md`:

## Voice

Tone, phrasing, writing corrections.

## Process

How tasks should be done.

## People

Who people are and how they relate to the work.

## Projects

Active work, current priorities, ongoing status patterns.

## Output

Formats, naming, delivery preferences.

## Tools

Which tools to use and how.

## Projects

Projects are the top-level unit for work. A project may contain one or many repositories.

Project layout:

- `PROJECT.md`: project entrypoint
- `context/`: supporting project context files
- `memory/`: per-role project memory files
- `skills/`: project-specific skills
- `tasks/active/`: active tasks
- `tasks/archive/`: archived tasks
- `repos/`: project repositories
- `worktrees/`: task-specific worktrees for repo changes

`PROJECT.md` is the primary project entrypoint. It should link to relevant files in `context/` and summarize the project.

## Roles

Each role lives under `roles/<role>/` and must contain:

- `ROLE.md`
- `MEMORY.md`
- `skills/`

Use `ROLE.md` frontmatter for role discovery. Read only the frontmatter for unselected roles. Read the full file only for the chosen role.

## Tasks

Tasks are project-scoped. Some sessions may not use a task. Create a task when the work should be tracked, handed off, or resumed later.

Task path:

- `projects/<project>/tasks/active/<task-id>-<slug>/`

Task files:

- `TASK.md`: task definition and current state
- `notes/`: role-local progress notes and resumable work
- `handoffs/`: notes intended for another role or the human
- `artifacts/`: task deliverables and supporting files

Task rules:

- `assignee` is the current owner of the task
- `assignee` may be a role or `human`
- default new tasks to a role unless the correct owner is unclear or human review is required
- when a task is assigned to another role or to the human, add a handoff note
- `done` means the active agent believes the task is complete
- move tasks to `archive/` only when the human decides to archive them

If asked to work on a task and the task assignee does not match the active role, flag the mismatch.

## Worktrees

When a task requires repository changes, use a task-specific worktree instead of sharing a checkout.

Worktree path:

- `projects/<project>/worktrees/<task-id>/<repo>/`

Use task worktrees to reduce conflicts and accidental overwrites across concurrent tasks.
