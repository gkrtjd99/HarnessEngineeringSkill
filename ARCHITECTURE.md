# Architecture

This document explains the stable structure of the repository.
It follows the spirit of matklad's `ARCHITECTURE.md`: prefer durable explanations over transient implementation detail.

## System Map

This repository is a skill-first kit for scaffolding harness-engineering project structure across multiple agent runtimes.

The top-level subsystems are:

1. `starter-kit/`
   Static reference templates that show the expected harness document surface.

2. `skill/`
   The canonical `harness-init` skill source, shared references, and runtime-specific install notes.

3. `targets/`
   Generated runtime bundles for Claude, Claude Code, Codex, and Antigravity.

4. `.github/workflows/`
   Repository automation that validates documentation, shell scripts, and target-bundle synchronization.

5. `scripts/`
   Local automation for synchronizing runtime bundles from the canonical skill source.

## Module Boundaries

- `starter-kit/` owns the copy-and-edit template surface.
- `skill/` owns the canonical interview flow, generation rules, and shared references.
- `targets/` owns runtime-specific packaging outputs and install guidance.
- `.github/workflows/` owns repository-level validation and release-gate automation.
- `scripts/` owns repeatable synchronization of generated runtime bundles.

## Invariants

- `README.md` is the human-facing overview, installation, and usage document.
- `AGENTS.md` remains a short entry point for agents rather than a long manual.
- `ARCHITECTURE.md` stays focused on stable repository structure.
- Detailed design rationale and tradeoffs live under `docs/design-docs/`.
- `skill/SKILL.md` is the canonical source of truth for the `harness-init` workflow.
- `targets/` must be generated from `skill/` rather than edited by hand.
- Repository CI must validate both the root documentation surface and target-bundle synchronization.

## Where To Read Details

- Design notes: `docs/design-docs/`
- Skill distribution rationale: `docs/design-docs/skill-distribution.md`
- Skill rules: `skill/SKILL.md`
- Template contract: `skill/references/templates.md`
- Runtime bundles: `targets/README.md`
