## Roles
- A role is a broad description of your responsibilities and scope of work.
- You may only assume one role.
- You must stay within the responsibilities of your role.
- If you are asked to do something outside your responsibilities, you must refuse.
- Once you have assumed a role, you must never change roles.

## Areas
- An area is an ongoing domain of responsibility, such as a product, brand, or business function.
- You must stay within the context, conventions, and constraints of your area.
- If you are asked to work on something outside your area, you must refuse.
- For each area you reference you must read `areas/<area>/AREA.md` and `areas/<area>/roles/<your role>/MEMORY.md`

### Areas and Git Repositories
- Any repositories accessed while working on an area should be cloned as a submodule in `areas/<area>/repositories/`

## Projects
- A project is a bounded piece of work with a specific outcome.
- Projects live under `projects/`, each with its own `PROJECT.md`.
- You may only work on one project.
- You must stay within the scope and goals of your project.
- If you are asked to do work that does not belong to your project, you must refuse.
- You may only work on the project if it is currently assigned to your role.

### Projects and areas
- A project may list one or more areas, or no areas.
- If a project lists areas, you must treat only those areas as in scope for this project.
- If a project lists no areas, you must treat all context as project-local and must not use any area memory.

### Projects and usage
- If a request clearly belongs to an existing project, you should use that project.
- If the request is small or exploratory and no project is named, you may work without a project.
- If the work should be tracked, handed off, or resumed later, you should ask to create or choose a project before continuing.

### Project files
- `PROJECT.md` is the entrypoint for a project.
- Use `NOTES.md` for project progress, working notes, and temporary reasoning that should persist within the project.
- Use `handoffs/` for notes intended for another role or for the human.
- Use `references/` for project-specific reference material.
- Use `artifacts/` for project outputs and deliverables.

## Memory
- Memory is for durable information that should persist across future work.
- You must keep memory up to date.
- You must update memory when you learn a durable preference, constraint, correction, or convention.
- Put memories in the broadest applicable memory file.
- Use `roles/<your role>/MEMORY.md` for memories that apply across areas for your role.
- Use `areas/<your area>/AREA.md` for durable information shared within an area across roles or across multiple kinds of work in that area.
- Use `areas/<your area>/roles/<your role>/MEMORY.md` only for preferences, constraints, and conventions specific to that role within that area.
- You must not store project progress in memory.
- You must not store shared area facts in role memory.

### Memory files
- Use `roles/<your role>/MEMORY.md` for your working preferences, collaboration preferences, and conventions that apply across areas.
- Use `areas/<your area>/AREA.md` and files under `areas/<your area>/context/` for shared, role-agnostic information about the area.
- Use `areas/<your area>/roles/<your role>/MEMORY.md` for preferences, constraints, and conventions that apply only to that role within that area.

### Memory rules
- When memory changes, update the existing file in place.
- Replace outdated information instead of appending contradictory notes.
- Keep memory concise, current, and useful.
- When in doubt between role memory and area-role memory, prefer the broader file unless the narrower scope is clearly necessary.

## Before you start
1. Discover roles:
   - Run `scripts/list_roles.sh` to list available roles.
2. Discover projects:
   - Run `scripts/list_projects.sh` to list active projects.
3. Discover areas:
   - Run `ls areas/` to list available areas
4. Choose your role:
   - If you were asked to work on a specific project, use the project's `assignee` as your role.
   - Otherwise, choose the role whose description best matches the request.
   - Once you have chosen a role, you must never change roles.
   - After choosing, you must read the full `roles/<your role>/ROLE.md` and `roles/<your role>/MEMORY.md`.
5. Choose your project:
   - If the request names a project, use that project.
   - If no project is named, you may work without a project.
   - If you choose a project, you must read its `PROJECT.md`.
6. Determine areas:
   - If your project lists areas, you must use those areas.
   - If you are not using a project and the request names an area, use that area.
   - If you are not using a project and no area is named, you may work without an area.
   - If you use an area, you must read `areas/<area>/AREA.md` and `areas/<area>/roles/<your role>/MEMORY.md`.
   - You may refer to relevant files under `areas/<area>/context/` when needed.

## When unclear
- If the correct role is unclear, ask the user.
- If the correct area is unclear and you need one, ask the user.
- If the correct project is unclear and the work should be tracked, ask the user whether to use or create a project.

## Creation
- When you need a new role, you must use the `create-role` skill.
- When you need a new area, you must use the `create-area` skill.
- When you need a new project, you must use the `create-project` skill.
- You must not invent your own layouts or filenames for roles, areas, or projects.
