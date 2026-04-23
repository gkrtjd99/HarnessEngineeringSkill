# Harness Engineering Reference

This document summarizes the core principles used when generating a harness-engineering repository.

## Principles

1. The repository should expose agent collaboration context through its document structure.
2. Entry-point documents should define execution rules and reading order clearly.
3. Execution-plan documents should track TODO items explicitly.
4. Templates and automation code should share the same structure contract.
5. Human-facing setup and usage guidance belongs in `README.md`, while agent navigation rules belong in `AGENTS.md`.
6. `README.md` may follow the user's language, but every other generated document should be written in English.

## Minimal Contract

The minimum harness contract includes:

- `AGENTS.md`
- `ARCHITECTURE.md`
- `docs/design-docs/`
- `docs/exec-plans/`
- `docs/product-specs/`
- `docs/references/`
- `scripts/init.sh`

## Prompting Contract for Generators

Generators should accept at least the following inputs:

- project purpose
- tech stack
- team size
- agent types
- workflows
- constraints
- reference tools
- done-when criteria
- required existing context

Generators should produce at least the following outputs:

- a project-specific `README.md`
- a project-specific `AGENTS.md`
- a project-specific `ARCHITECTURE.md`
- an optional `CLAUDE.md`
- the required `docs/` core set
- optional project-specific docs
- an initialization script
