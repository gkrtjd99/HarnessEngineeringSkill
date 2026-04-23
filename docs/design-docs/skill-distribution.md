# Skill Distribution

This document records the rationale for the repository's skill-first, multi-runtime distribution model.

## Context

The repository packages one canonical skill across multiple agent runtimes.
The main design goal is to keep the workflow consistent while distributing it in runtime-specific forms.

## Decision

Keep `skill/` as the only source of truth for the `harness-init` workflow.
Generate runtime bundles for Claude, Claude Code, Codex, and Antigravity into `targets/` with a sync script.
Do not edit `targets/` by hand.

## Scope

- Canonical skill instructions in `skill/SKILL.md`
- Shared generation templates in `skill/references/`
- Runtime-specific install notes in `skill/runtime-guides/`
- Generated bundles in `targets/`
- Sync validation in repository CI

## Tradeoffs

- Runtime packaging is simpler to verify than API-backed generation, but it does not prove model output quality by itself.
- Antigravity uses an adapter prompt file rather than a filesystem-discovered skill bundle.

## Follow-up Options

- Add more runtime adapters if another tool can consume the same skill contract.
- Add pre-push hooks that re-run the sync script before every push.
