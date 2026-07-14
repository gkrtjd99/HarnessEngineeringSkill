# Skill Distribution

This document records the rationale for the repository's skill-first, multi-runtime distribution model.

## Context

The repository packages one canonical skill across multiple agent runtimes.
The main design goal is to keep the workflow consistent while distributing it in runtime-specific forms.

## Decision

Keep `skill/` as the only source of truth for the `harness-init` workflow.
Generate runtime bundles for Claude, Claude Code, Codex, OpenCode, and Antigravity into `targets/` with a sync script.
Do not edit `targets/` by hand.

The canonical workflow is new-project-first. It develops an idea into confirmed product
scope, acceptance criteria, architecture constraints, agent autonomy boundaries,
verification rules, and a first executable plan before generating the repository harness.

Existing-project adoption reuses the same harness contract but remains secondary. It
inventories current authority and fills gaps without changing the default greenfield
experience into an audit workflow.

## Scope

- Canonical skill instructions in `skill/SKILL.md`
- Guided project definition in `skill/references/project-definition.md`
- Shared generation templates in `skill/references/`
- Runtime-specific install notes in `skill/runtime-guides/`
- Generated bundles in `targets/`
- Sync validation in repository CI

## Tradeoffs

- Runtime packaging is simpler to verify than API-backed generation, but it does not prove model output quality by itself.
- Antigravity uses an adapter prompt file rather than a filesystem-discovered skill bundle.
- A deeper definition interview takes longer than a fixed setup questionnaire, but it
  produces acceptance criteria and execution boundaries that agents can act on.
- Existing-project discovery adds a short first pass only in adoption mode and avoids
  overwriting useful authority.

## Follow-up Options

- Add more runtime adapters if another tool can consume the same skill contract.
- Add pre-push hooks that re-run the sync script before every push.
