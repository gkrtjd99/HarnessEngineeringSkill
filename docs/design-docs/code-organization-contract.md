# Code Organization Contract

This design note explains why generated harnesses include a code map, module contracts, and cross-cutting file organization rules.

## Context

Agent work often happens through small-context subagents. Those agents can miss existing functions, components, stylesheets, scripts, configuration modules, and infrastructure conventions when the repository does not expose a compact navigation surface.

The same failure mode appears across frontend, backend, infra, scripts, tests, shared packages, generated artifacts, and configuration. A frontend agent may grow one stylesheet into thousands of lines. A backend agent may create a parallel service instead of reusing an existing repository. An infra agent may add a new workflow job instead of extending the existing deployment path.

## Decision

Generated harnesses include `docs/generated/code-map.md` as a concise index of confirmed,
planned or implemented code surfaces. They add `docs/module-contracts/README.md` and
per-module contracts only after the project definition identifies durable boundaries with
ownership, public entry points, or non-obvious reuse rules.

`docs/references/development-rules.md` carries the behavioral rules: search existing code first, reuse owned modules before adding new surfaces, avoid catch-all files, split large files, and update the map when ownership changes. `AGENTS.md` links to that document while remaining a short navigation map. `ARCHITECTURE.md` carries the stable boundaries: public surfaces, dependency direction, file organization, and invariants.

## Rationale

Keeping everything in `AGENTS.md` would make the agent entry point too long and stale. Keeping everything only in generated API docs would miss styles, routes, infrastructure modules, scripts, and conventions that are not represented as exported symbols.

The chosen split keeps instructions short, maps broad, and module contracts specific. This lets a parent agent delegate a narrow task with links to the relevant contract while preserving enough structure for subagents to reuse existing code.

## Authority

When `docs/generated/code-map.md` and `docs/module-contracts/<module>.md` disagree about ownership, public entry points, or dependency rules, the module contract is the source of truth. The code map is a derived index for fast lookup and MUST be updated to match the contract. Agents that find a mismatch MUST fix the code map rather than the contract unless they are explicitly changing the owned module's responsibilities.

## Tradeoffs

The code map can become stale if agents do not update it after changing ownership or entry points. The templates therefore make map updates part of the required workflow.

Per-module contracts add documentation overhead. They are optional until a module has clear ownership, public entry points, or non-obvious reuse rules.

## Consequences

New generated projects have a place to describe whichever frontend, backend, infra, scripts,
shared packages, styles, tests, and generated artifacts are actually planned without creating
a separate rule system for each area.

Subagent prompts can reference a small set of files instead of restating the whole repository architecture.
