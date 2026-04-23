# Architecture

This document is an internal design note for the repository.
Use it to capture implementation rationale, tradeoffs, and evolution notes that do not belong in the stable top-level map.

## Context

Harness Init Skill Kit keeps a canonical agent skill and multiple runtime bundles in one repository.
The goal is to maintain one source of truth for the `harness-init` workflow while distributing it to several agent tools.

## Responsibility Split

- `starter-kit/` provides a static reference shape for generated harness documents.
- `skill/` defines the canonical interview flow, generation rules, and shared assets.
- `targets/` packages the canonical skill for each supported runtime.
- `scripts/` regenerates runtime bundles from the canonical source.

## Shared Knowledge Surface

- Template rules and document expectations are kept consistent between `starter-kit/` and `skill/references/templates.md`.
- Runtime-specific install notes live under `skill/runtime-guides/` and are copied into `targets/` by the sync script.

## Runtime Flow

The author edits `skill/SKILL.md` and shared references.
`scripts/sync-skill-targets.sh` copies the canonical source into each runtime bundle.
Users install a bundle from `targets/` into the tool they use.

## Decision Notes

- Record why structural changes were made and which alternatives were rejected.
- When generation rules change, update `skill/SKILL.md`, shared references, and runtime guides in the same change set.

## Extension Strategy

When adding a new runtime, add a new directory under `skill/runtime-guides/` and extend `scripts/sync-skill-targets.sh`.
When changing the template structure, update `starter-kit/`, `skill/SKILL.md`, and `skill/references/templates.md` together.
