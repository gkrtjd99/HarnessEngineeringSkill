# AGENTS

This document is the primary agent entry point for this repository.

## Read Order

1. `ARCHITECTURE.md`
2. `README.md`
3. `docs/references/development-rules.md`
4. `docs/generated/code-map.md`
5. `docs/module-contracts/README.md`
6. `skill/SKILL.md`
7. `docs/design-docs/`
8. `targets/README.md`
9. `docs/references/`

## Repository Map

- `starter-kit/`: static reference template for generated harness documents
- `skill/`: canonical `harness-init` skill source
- `targets/`: generated runtime bundles for supported agent tools
- `scripts/`: repository automation for syncing runtime bundles
- `docs/generated/code-map.md`: generated index of reusable repository surfaces
- `docs/module-contracts/`: module ownership, public surface, and verification contracts
- `docs/references/development-rules.md`: detailed development and subagent handoff rules

## Rules

- Agents MUST treat this file as a map, not a full manual.
- Agents MUST keep this file under 100 lines.
- Agents MUST keep `skill/` and `targets/` semantically aligned.
- Agents MUST update `ARCHITECTURE.md` for stable system-map changes.
- Agents MUST update `docs/design-docs/` for design rationale and tradeoffs.
- Agents MUST keep human-facing setup and usage details in `README.md`, not here.
- Agents MUST run `bash scripts/sync-skill-targets.sh` after changing `skill/` or `targets/`.
- Agents MUST validate shell automation changes with `bash -n`.
