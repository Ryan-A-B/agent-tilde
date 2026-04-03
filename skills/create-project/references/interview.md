# Create Project Interview

Use this interview before running `scripts/create-project.sh`.

The goal is to gather enough context to create a clean initial project scaffold without forcing the script to prompt interactively.

## Required Questions

1. What should this project be called?
2. What is the purpose of the project?
3. Who is the project for?

## Optional Questions

1. Are there important constraints or non-negotiables?
2. Are there existing repositories to pull into the project now?
3. Are there workflow hints that should be added to the project role memory files?

## Operator Notes

- Do not guess missing project details.
- If the project name is unclear, ask before scaffolding.
- If existing repositories should be pulled in, collect each repository source explicitly before running the script.
- After the interview, summarize the planned scaffold back to the human if anything remains ambiguous.
