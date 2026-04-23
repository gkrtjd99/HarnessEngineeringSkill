# AGENTS.md Template

This template defines baseline rules for agent collaboration in a project repository.

## Scope

These rules apply repository-wide unless a nested `AGENTS.md` provides stricter rules.

## Execution Rules

- Agents MUST treat this file as a map, not a full encyclopedia.
- Agents MUST read `ARCHITECTURE.md` before large structural changes.
- Agents MUST track TODO state in an active plan under `docs/exec-plans/active/`.
- Agents MUST update design decisions in `docs/design-docs/`.
- Agents SHOULD keep changes small and verifiable.
- Agents MAY propose alternative structures with explicit tradeoff notes.

## Documentation Rules

- External-facing modules MUST include clear documentation comments.
- Architectural decisions SHOULD be recorded with rationale and impact.
- Reference notes MAY be added under `docs/references/`.

## Quality Rules

- Scripts MUST fail fast on errors.
- CI checks SHOULD validate document links and architecture docs.
- Generated files MUST preserve existing user content when possible.
