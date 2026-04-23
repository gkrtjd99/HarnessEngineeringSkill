# AGENTS

This document is the primary agent entry point for this repository.

## Read Order

1. `ARCHITECTURE.md`
2. `README.md`
3. `skill/SKILL.md`
4. `docs/design-docs/`
5. `targets/README.md`
6. `docs/references/`

## Repository Map

- `starter-kit/`: static reference template for generated harness documents
- `skill/`: canonical `harness-init` skill source
- `targets/`: generated runtime bundles for supported agent tools
- `scripts/`: repository automation for syncing runtime bundles

## Rules

- Agents MUST treat this file as a map, not a full manual.
- Agents MUST keep `skill/` and `targets/` semantically aligned.
- Agents MUST update `ARCHITECTURE.md` for stable system-map changes.
- Agents MUST update `docs/design-docs/` for design rationale and tradeoffs.
- Agents MUST keep human-facing setup and usage details in `README.md`, not here.
- Agents MUST run `bash scripts/sync-skill-targets.sh` after changing `skill/` or `targets/`.
- Agents MUST validate shell automation changes with `bash -n`.
