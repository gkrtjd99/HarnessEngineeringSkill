# Architecture

This document is an internal design note for the repository.
Use it to capture implementation rationale, tradeoffs, and evolution notes that do not belong in the stable top-level map.

## Context

Harness Init Skill Kit keeps a canonical agent skill and multiple runtime bundles in one repository.
The goal is to maintain one source of truth for the `harness-init` workflow while distributing it to several agent tools.

## Responsibility Split

- `starter-kit/` provides a static reference shape for generated harness documents.
- `skill/` defines the canonical new-project definition, AI-harness generation, and
  verification flow. Existing-project adoption remains a secondary mode.
- `targets/` packages the canonical skill for each supported runtime.
- `scripts/` regenerates runtime bundles from the canonical source.

`AGENTS.md` remains the canonical cross-runtime entry point. The starter kit and generated
greenfield harnesses include a minimal `CLAUDE.md` containing `@AGENTS.md` so Claude Code loads
the same rules without a duplicated instruction system.

## Shared Knowledge Surface

- Product-definition questions live in `skill/references/project-definition.md`; generation
  templates and document expectations live in `skill/references/templates.md`.
- Template rules and document expectations are kept consistent between `starter-kit/` and `skill/references/templates.md`.
- Runtime-specific install notes live under `skill/runtime-guides/` and are copied into `targets/` by the sync script.

## Runtime Flow

The author edits `skill/SKILL.md`, the inventory helper, and shared references.
`scripts/sync-skill-targets.sh` copies the canonical source into each runtime bundle.
Users install a bundle from `targets/` into the tool they use.

## Decision Notes

- Record why structural changes were made and which alternatives were rejected.
- When generation rules change, update `skill/SKILL.md`, shared references, and runtime guides in the same change set.

## Extension Strategy

When adding a new runtime, add a new directory under `skill/runtime-guides/` and extend `scripts/sync-skill-targets.sh`.
When changing the template structure, update `starter-kit/`, `skill/SKILL.md`, and `skill/references/templates.md` together. When changing discovery behavior, update the
repository-inventory fixture and deterministic test alongside the helper.
