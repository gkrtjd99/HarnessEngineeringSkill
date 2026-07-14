# Harness Engineering Reference

This document summarizes the core principles used when generating a harness-engineering repository.

## Principles

1. The repository should expose agent collaboration context through its document structure.
2. Entry-point documents should define execution rules and reading order clearly.
3. Execution-plan documents should track TODO items explicitly.
4. Templates and automation code should share the same structure contract.
5. Code organization context should cover frontend, backend, infra, scripts, tests, shared packages, generated artifacts, styles, and configuration.
6. Agents should be able to find existing reusable surfaces before adding new files or modules.
7. Human-facing setup and usage guidance belongs in `README.md`, while shared agent navigation rules belong in `AGENTS.md`; `CLAUDE.md` is only the Claude Code loading bridge.
8. New-project bootstrap is the primary workflow; existing-project adoption is secondary.
9. Product definition should trace P0 capabilities from user problems through acceptance criteria and verification.
10. Operating documents should use the project team's maintained language rather than imposing English.
11. Confirmed interview progress should persist in a draft so another session can resume without replaying context.
12. Generated harnesses should pass deterministic structural validation before handoff.

## Minimal Contract

The minimum harness contract includes:

- `AGENTS.md`
- `CLAUDE.md` importing `AGENTS.md` when Claude Code is a supported runtime
- `ARCHITECTURE.md`
- `docs/product-specs/product-definition.md`
- `docs/exec-plans/active/EP-0001-initial-delivery.md`
- `docs/generated/code-map.md`
- `docs/references/development-rules.md`

## Prompting Contract for Generators

Generators should accept at least the following inputs:

- product one-liner, problem, target user, and current alternative
- value proposition, P0 capabilities, user journeys, and acceptance criteria
- in-scope and out-of-scope behavior
- success signals and non-functional requirements
- tech stack
- agent tools, autonomy boundaries, and human checkpoints
- planned code boundaries and sources of truth
- verification and handoff criteria
- first milestone, dependencies, assumptions, and risks

Generators should produce at least the following outputs:

- a project-specific `README.md`
- a project-specific `AGENTS.md`
- a minimal `CLAUDE.md` bridge when Claude Code is a supported runtime
- a project-specific `ARCHITECTURE.md`
- a confirmed product definition with P0 acceptance criteria
- a persisted product-definition draft while the interview remains incomplete
- an independently verifiable first execution plan
- a planned code map containing only confirmed project areas
- agent autonomy, verification, and handoff rules
- a generated-harness validation result
- optional module contracts and domain documents when justified
- optional project-specific docs
- an initialization script only when it performs concrete, safe, idempotent setup
