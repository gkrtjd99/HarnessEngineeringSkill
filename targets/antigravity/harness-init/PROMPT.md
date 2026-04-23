# Harness Init Prompt

Use the `harness-init` workflow to scaffold a harness-engineering document set for this repository.

## Required Behavior

- Ask the canonical 10 interview questions from `SKILL.md`
- Generate `README.md`, `AGENTS.md`, `ARCHITECTURE.md`, and the harness core `docs/` set
- Keep `README.md` in the user's language
- Keep the remaining generated documents in English
- Reflect `doneWhen` in at least one execution plan or product spec
- Generate `scripts/init.sh`

## Required References

- `SKILL.md`
- `references/templates.md`
- any runtime or project-specific documents the user points to

## Output Goal

Produce a document set that lets another agent continue work by reading the generated docs only.
