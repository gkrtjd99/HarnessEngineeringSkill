# Architecture

This document explains the stable structure of the repository.
It follows the spirit of matklad's `ARCHITECTURE.md`: prefer durable explanations over transient implementation detail.

## System Map

This repository is a skill-first kit for defining greenfield software projects and scaffolding
their AI-driven development harness across multiple agent runtimes.

The top-level subsystems are:

1. `starter-kit/`
   Static reference templates that show the expected harness document surface.

2. `skill/`
   The canonical `harness-init` workflow, project-definition interview, adoption inventory
   helper, generation templates, and runtime-specific install notes.

3. `targets/`
   Generated runtime bundles for Claude, Claude Code, Codex, OpenCode, and Antigravity.

4. `docs/generated/code-map.md` and `docs/module-contracts/`
   Generated project navigation and module ownership contracts for agents working with small context windows.

5. `.github/workflows/`
   Repository automation that validates documentation, shell scripts, repository inventory,
   generated-harness fixtures, and target-bundle synchronization.

6. `scripts/`
   Local automation for synchronizing runtime bundles from the canonical skill source.

## Module Boundaries

- `starter-kit/` owns the copy-and-edit template surface.
- `starter-kit/CLAUDE.md` owns the minimal Claude Code bridge that imports `AGENTS.md`.
- `skill/` owns the new-project definition and AI-harness generation workflow, with
  existing-project discovery and adoption as a secondary path.
- `targets/` owns runtime-specific packaging outputs and install guidance.
- `docs/generated/code-map.md` owns the generated index of reusable code surfaces across frontend, backend, infra, scripts, shared packages, styles, tests, and generated artifacts.
- `docs/module-contracts/` owns durable module-level responsibility, public entry point, dependency, and verification contracts.
- `docs/references/development-rules.md` owns detailed implementation and subagent handoff rules so `AGENTS.md` can stay short.
- `.github/workflows/` owns repository-level validation, repository-inventory and generated-
  harness coverage, and release-gate automation.
- `scripts/` owns repeatable synchronization of generated runtime bundles.

## Invariants

- `README.md` is the human-facing overview, installation, and usage document.
- `AGENTS.md` remains a short entry point for agents rather than a long manual.
- `ARCHITECTURE.md` stays focused on stable repository structure.
- Detailed design rationale and tradeoffs live under `docs/design-docs/`.
- `skill/SKILL.md` is the canonical source of truth for the `harness-init` workflow.
- New-project bootstrap is the default product workflow; existing-project adoption must
  remain a compatible secondary path.
- Product definition must trace P0 capabilities from user problems through acceptance
  criteria and verification before generation begins.
- Existing-project adoption must inspect project context before creating or replacing
  operating documents and preserve existing authoritative documents where possible.
- `AGENTS.md` must remain a navigation map rather than a detailed development manual.
- `CLAUDE.md` must remain a minimal Claude Code loading bridge and must not duplicate `AGENTS.md`.
- Generated harnesses must include a code map of confirmed planned or implemented surfaces.
  Add module contracts only when durable boundaries justify their maintenance cost.
- `targets/` must be generated from `skill/` rather than edited by hand.
- Repository CI must validate both the root documentation surface and target-bundle synchronization.

## Where To Read Details

- Design notes: `docs/design-docs/`
- Skill distribution rationale: `docs/design-docs/skill-distribution.md`
- Code organization rationale: `docs/design-docs/code-organization-contract.md`
- Skill rules: `skill/SKILL.md`
- Template contract: `skill/references/templates.md`
- Runtime bundles: `targets/README.md`
