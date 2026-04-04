
## Roles
- A role is a broad description of your responsibilities and scope of work.
- You may only assume one role.
- You must stay within the responsibilities of your role.
- If you are asked to do something outside your responsibilities, you must refuse.
- Once you have assumed a role, you must never change roles.

## Areas
- An area is an ongoing domain of responsibility, such as a product, brand, or business function.
- You may only work within one area.
- You must stay within the context, conventions, and constraints of your area.
- If you are asked to work on something outside your area, you must refuse.
- Once you have started work in an area, you must never change areas.

## Tasks


## Memory
- Memory is for durable information that should persist across future work.
- You must keep memory up to date.
- You must update memory when you learn a durable preference, constraint, correction, or convention.
- You must store information in the narrowest memory file that fits it.
- You must not store task progress in memory.
- You must not store shared area facts in role memory.

### Memory files
- Use `roles/<your role>/MEMORY.md` for your working preferences and conventions.
- Use `areas/<your area>/roles/<your role>/MEMORY.md` for preferences, constraints, and conventions that apply only in this area.
- Use `areas/<your area>/AREA.md` and files under `areas/<your area>/context/` for shared, role-agnostic information about the area.
- Structure each `MEMORY.md` using the standard headings: Voice, Process, People, Projects, Output, Tools.

### Memory rules
- When memory changes, update the existing file in place.
- Replace outdated information instead of appending contradictory notes.
- Keep memory concise, current, and useful.

## Skills

## Before you start
1. Discover roles:
   - Run `scripts/list_roles.sh` to list available roles.
2. Discover areas:
   - Run `ls areas/` to list available areas
3. Choose your role:
   - If you were asked to work on a specific task, use the task’s `assignee` as your role.
   - Otherwise, choose the role whose description best matches the request.
   - Once you have chosen a role, you must never change roles.
   - After choosing, you must read the full `roles/<your role>/ROLE.md` and `roles/<your role>/MEMORY.md`.
4. Choose your area:
   - If the request names an area, use that area.
   - If no area is named, you must ask the user which area to use.
   - Once you have chosen an area, you must never change areas.
   - After choosing, you must read `areas/<your area>/AREA.md` and `areas/<your area>/roles/<your role>/MEMORY.md`.
   - You may then refer to relevant files under `areas/<your area>/context/` when needed.




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

## Bootstrap Operations

Some requests are workspace bootstrap operations rather than normal role-scoped work.

Bootstrap operations include:

- creating a role
- creating a project
- creating a task
- inspecting or improving the workspace scaffolding itself

For bootstrap operations:

- use the matching creation skill directly
- do not block on choosing an existing role if no role has been created yet
- do not treat an empty `roles/` or `projects/` directory as an error
- prefer making a sensible first draft and asking the human to review it rather than front-loading too many questions

## Workspace Skills

This workspace defines local file-based skills under `skills/`.

These workspace skills should be treated like installed skills for bootstrap purposes:

- immediately after reading `AGENTS.md`, load the frontmatter `name` and `description` from every `skills/*/SKILL.md`
- use those frontmatter summaries to decide which workspace skill to load next
- treat the workspace skills as authoritative local workflow definitions, not as optional discoveries

Use `scripts/list_skills.sh` to surface local skill frontmatter when needed.

## Startup Routine

1. Determine whether the session is task-based or direct work.
2. Load local skill frontmatter from `skills/*/SKILL.md`.
3. If the user named a task, open the task first.
4. Determine the project from the task path or from the user's request.
5. If the project is unclear, ask before loading project context.
6. Determine the role:
   - For a task, prefer the task assignee.
   - Otherwise, read only the frontmatter `name` and `description` from each `roles/*/ROLE.md` file and choose the best fit.
   - If this is a bootstrap operation such as `create-role`, `create-project`, or `create-task`, use that skill flow instead of trying to force normal role selection first.
7. Once the role is selected, do not change it for the rest of the session.
8. Load `roles/<role>/ROLE.md`.
9. Load `roles/<role>/MEMORY.md`.
10. Load `projects/<project>/PROJECT.md`.
11. Load `projects/<project>/memory/<role>.md` if it exists.
12. If working on a task, read `TASK.md` and any relevant files in `notes/`, `handoffs/`, and `artifacts/`.

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

It is valid for `roles/` to be empty when the workspace is first created.

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

## Creation Skills

The workspace should treat these skills as first-class bootstrap tools:

- `create-role`
- `create-project`
- `create-task`

When the user asks to create one of these objects, load the corresponding skill early.

Do not narrate this as discovering a possible local skill. Treat it as the expected workflow for this workspace.

Default creation behavior:

- keep roles broad and non-overlapping
- write a sensible first draft when the request is straightforward
- for role creation, show the proposed `ROLE.md` in chat before scaffolding
- iterate on the draft in chat when needed
- scaffold only after the human is happy with the draft
- only stop to ask clarifying questions when the boundary is genuinely ambiguous or risky

## Worktrees

When a task requires repository changes, use a task-specific worktree instead of sharing a checkout.

Worktree path:

- `projects/<project>/worktrees/<task-id>/<repo>/`

Use task worktrees to reduce conflicts and accidental overwrites across concurrent tasks.
