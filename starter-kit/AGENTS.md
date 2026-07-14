# AGENTS.md Template

This template defines the short navigation entry point for agent collaboration in a project repository.

## Scope

These rules apply repository-wide unless a nested `AGENTS.md` provides stricter rules.

## Read Order

1. `ARCHITECTURE.md`
2. `docs/product-specs/product-definition.md`
3. `docs/exec-plans/active/EP-0001-initial-delivery.md`
4. `docs/references/development-rules.md`
5. `docs/generated/code-map.md`
6. `docs/module-contracts/README.md` when present
7. `docs/design-docs/`
8. `docs/references/`

## Repository Map

- `app/`: application runtime code
- `docs/`: product, architecture, execution, reference, and module-contract documents
- `scripts/`: repository automation

## Reference Map

- Development rules: `docs/references/development-rules.md`
- Code surface index: `docs/generated/code-map.md`
- Module contracts: `docs/module-contracts/README.md`

## Rules

- Agents MUST treat this file as a map, not a full encyclopedia.
- Agents MUST keep this file under 100 lines.
- Agents MUST prove the active plan's done-when criteria before reporting completion.
