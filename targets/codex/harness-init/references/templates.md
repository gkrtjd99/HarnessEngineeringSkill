# Template Reference

This document defines the generation rules used by the `harness-init` skill.

The repository treats this file and `skill/SKILL.md` as the canonical content source for all runtime bundles.

## Contents

1. Evidence, core output, optional documents, references, and language rules
2. Root document templates
3. Product definition and execution-plan templates
4. Code map, module contract, design, and development-rule templates
5. Conditional frontend, backend, infrastructure, security, reliability, and product templates

## Evidence Rules

Use these templates after the new-project definition review or existing-project discovery.

- Prefer existing authoritative documents over parallel replacement documents.
- Create a document only when it has a concrete owner, audience, and maintenance reason.
- Do not emit placeholder prose, guessed commands, or empty directory trees.
- For adoption, record the inventory, gaps, proposed file changes, and open questions before editing.
- Keep unknown decisions visible as `Open questions`; do not convert them into architecture claims.
- For a new project, label planned paths and commands as planned until implementation creates them.

## Core Rule

For a new project, create the following AI-development harness:

- `README.md`
- `AGENTS.md`
- `CLAUDE.md` containing only the Claude Code bridge `@AGENTS.md`
- `ARCHITECTURE.md`
- `docs/product-specs/product-definition.md`
- `docs/exec-plans/active/EP-0001-initial-delivery.md`
- `docs/generated/code-map.md`
- `docs/references/development-rules.md`

Generate design indexes, module contracts, tech-debt tracking, and domain guides only when the
project definition gives them real content. For existing-project adoption, each responsibility
may be satisfied by an existing equivalent; link to that authority instead of duplicating it.

## Optional Docs

Generate each document only when its stated condition is met:

| File | Generate when... |
| --- | --- |
| `docs/BACKEND.md` | A backend, API, worker, queue, service layer, or data-access layer is present |
| `docs/FRONTEND.md` | A frontend tech stack is present (e.g., React, Vue, Next.js, SvelteKit) |
| `docs/INFRASTRUCTURE.md` | Deployment, hosting, IaC, CI/CD, observability, or runtime configuration is present |
| `docs/SECURITY.md` | Authentication, authorization, or RLS is a core constraint |
| `docs/RELIABILITY.md` | Availability, resource limits, or fault tolerance matter (free-tier infra, SLAs, uptime targets) |
| `docs/generated/db-schema.md` | A database schema is described or implied |
| `docs/design-docs/core-beliefs.md` | The interview confirms durable product, engineering, or verification principles |
| `docs/module-contracts/<module>.md` | A durable, multi-file module, feature, package, service, infrastructure area, or script suite has explicit ownership, public entry points, or non-obvious reuse rules; skip for small, single-file, or short-lived modules |
| `docs/exec-plans/active/EP-xxxx.md` | At least one in-progress task maps to an execution plan |
| `docs/exec-plans/completed/EP-xxxx.md` | A previously completed execution plan exists |
| `docs/product-specs/<feature>.md` | A concrete feature with scope, constraints, and done-when criteria is described |
| `docs/DESIGN.md` | Design decisions exist that are not captured in architecture or product specs |
| `docs/PLANS.md` | Multiple execution plans need a single index |
| `docs/PRODUCT_SENSE.md` | Product direction, user personas, or market positioning need to be captured |
| `docs/QUALITY_SCORE.md` | Quality metrics (test coverage, Lighthouse score, error rate) are tracked as explicit targets |

## Reference Tools Rule

If `referenceTools` is provided as `react, nextjs, prisma`, generate:

- `docs/references/react-llms.txt`
- `docs/references/nextjs-llms.txt`
- `docs/references/prisma-llms.txt`

If the input is blank or resolves to the fallback placeholder value, record the reference
need as an open question instead of generating a placeholder file.

## Language Rule

- Conduct the interview and write `README.md` in the user's language unless requested otherwise.
- Write operating documents in the project team's chosen working language.
- Use one maintained language consistently across the operating document set.

## CLAUDE.md Template

Keep this file as a minimal Claude Code auto-load bridge. `AGENTS.md` remains the canonical
cross-runtime entry point.

```markdown
# Claude Code Project Instructions

@AGENTS.md
```

## AGENTS.md Template

```markdown
# AGENTS

## Read Order

1. ARCHITECTURE.md
2. docs/product-specs/product-definition.md
3. docs/exec-plans/active/EP-0001-initial-delivery.md
4. docs/references/development-rules.md
5. docs/generated/code-map.md
6. docs/module-contracts/README.md (when present)
7. docs/design-docs/ (when present)

## Repository Map

- app/
- docs/
- scripts/

## Reference Map

- Development rules: docs/references/development-rules.md
- Code surface index: docs/generated/code-map.md
- Module contracts: docs/module-contracts/README.md

## Rules

- Agents MUST treat this file as a map, not a full manual.
- Agents MUST keep this file under 100 lines.
- Agents MUST prove the current plan's done-when criteria before reporting completion.
```

## README.md Template

```markdown
# Project Name

[Concrete overview derived from project evidence or user input.]

## Installation

## Run

## Usage

## Generated Structure
```

## ARCHITECTURE.md Template

```markdown
# Architecture

This document explains the stable structure of the repository.

## System Map

## Module Boundaries

## Public Surfaces

## Dependency Direction

## File Organization

## Invariants
```

## docs/product-specs/product-definition.md Template

```markdown
# Product Definition

## Status and Sources

Distinguish confirmed decisions, proposed defaults, and open questions.

## Product Summary

## Problem and Current Alternative

## Target Users

## Value Proposition

## User Journeys

## Functional Requirements

| ID | Priority | Capability | Why | Acceptance Criteria |
| --- | --- | --- | --- | --- |

## Non-Functional Requirements

## Scope

### In Scope

### Out of Scope

## Success Signals

## Agent Operating Model

Document agent permissions, human checkpoints, escalation boundaries, and handoff ownership.

## Verification and Handoff

## Assumptions, Dependencies, and Risks

## Open Questions
```

## docs/product-specs/product-definition.draft.md Template

```markdown
# Product Definition Draft

## Progress

- Workflow: New Project Bootstrap
- Confirmed sections: [n]/14
- Last updated: [date and timezone]
- Next section: [number and title]

## Confirmed Decisions

### [Section Number]. [Section Title]

[Confirmed summary]

## Proposed Defaults

## Open Questions

## Next Questions

1. [The next consequential question]

## Continuation Note

Read this draft before asking questions. Preserve confirmed decisions and resume from `Next Questions`.
```

## docs/exec-plans/active/EP-0001-initial-delivery.md Template

```markdown
# EP-0001: Initial Delivery

## Outcome

Name the first end-to-end user or technical outcome.

## Product Trace

Link the P0 requirement, user journey, and acceptance criteria this plan implements.

## Context and Constraints

## Planned Changes

| Area | Change | Verification |
| --- | --- | --- |

## Tasks

Use ordered, independently checkable tasks.

## Verification

Separate automated checks, manual checks, and checks whose commands must be wired first.

## Done When

## Risks and Rollback

## Handoff
```

## docs/generated/code-map.md Template

```markdown
# Code Map

This generated index helps agents find and reuse existing code before adding new files.

## How To Use

Read the relevant rows before implementation. Update this file when module ownership, public entry points, or file layout changes.

## Surfaces

Populate only areas confirmed by the project definition. Mark an entry `planned` until its
source path exists; never copy generic frontend, backend, or infrastructure rows blindly.

| Area | Owner Module | Entry Points | Responsibility | Reuse Before Adding | Source |
| --- | --- | --- | --- | --- | --- |

## Large Files

| File | Lines | Owner | Split Plan |
| --- | --- | --- | --- |
| `[path]` | `[count]` | `[owner]` | `[split or keep rationale]` |
```

## docs/module-contracts/README.md Template

```markdown
# Module Contracts

Module contracts describe owned code areas so agents can reuse existing surfaces and avoid catch-all files.

## Contract Index

| Module | Contract | Owner | Scope |
| --- | --- | --- | --- |
| `[module]` | `docs/module-contracts/<module>.md` | `[owner]` | `[frontend, backend, infra, scripts, shared, tests, generated]` |

## Rules

- Agents MUST read the relevant contract before editing an owned area.
- Agents MUST add or update a module contract when creating a new long-lived feature, package, service, infrastructure area, or script suite.
- Contracts MUST name public entry points, reusable internals, forbidden dependencies, local file organization, and verification commands.
```

## docs/module-contracts/<module>.md Template

```markdown
# Module Contract

## Responsibility

[Describe what this module owns.]

## Public Entry Points

| Name | Kind | Purpose | Source |
| --- | --- | --- | --- |
| `[name]` | `[component, function, class, route, job, script, config]` | `[purpose]` | `[path]` |

## Internal Reuse

| Surface | Reuse When | Source |
| --- | --- | --- |
| `[surface]` | `[scenario]` | `[path]` |

## File Organization

[Describe the local folder and file naming rules.]

## Dependency Rules

[Describe allowed and forbidden dependencies.]

## Styling Rules

[Describe style ownership when the module has UI.]

## Verification

[List relevant tests, linters, build commands, and manual checks.]
```

## docs/design-docs/index.md Template

```markdown
# Design Docs Index

## Existing Decisions

## Open Questions
```

## docs/design-docs/core-beliefs.md Template

```markdown
# Core Beliefs

## Product Principles

## Engineering Principles

## Verification Principles

## Open Questions
```

## docs/exec-plans/tech-debt-tracker.md Template

```markdown
# Tech Debt Tracker

## Open Debt

## Prioritized Debt

## Resolved Debt

## Open Questions
```

## docs/product-specs/index.md Template

```markdown
# Product Specs Index

## Active Specs

## Archived Specs

## Open Questions
```

## docs/product-specs/<feature>.md Template

```markdown
# Feature Spec

## Problem

## Scope

## Constraints

## Done When
```

## Generic Execution Plan Template

```markdown
# Execution Plan

## Goal

## Context

## Tasks

- [ ] task 1
- [ ] task 2

## Done When
```

## docs/BACKEND.md Template

```markdown
# Backend

## Runtime

| Concern | Choice |
| --- | --- |
| Language | ... |
| Framework | ... |
| Data Access | ... |
| Background Jobs | ... |

## Module Organization

[Describe service, route, repository, validation, worker, and shared package boundaries.]

## Public Entry Points

| Surface | Purpose | Owner | Source |
| --- | --- | --- | --- |
| ... | ... | ... | ... |

## Reuse Rules

[Describe which services, repositories, validators, and clients must be reused before adding new ones.]

## File Size Rules

[Describe when routes, services, jobs, or data-access files must be split.]

## Verification

[Describe backend test, lint, typecheck, migration, and smoke-check commands.]
```

## docs/references/stack-reference-llms.txt Template

```text
Reference for agents.
Include concise commands, constraints, and known pitfalls.
```

## docs/references/development-rules.md Template

```markdown
# Development Rules

This document holds detailed development rules that should not live in `AGENTS.md`.
`AGENTS.md` stays a short navigation map.

## Read Order Usage

- The `AGENTS.md` Read Order is a list of documents to consult when relevant, not a checklist to read in full for every task.
- Agents MUST always read `ARCHITECTURE.md` for structural context.
- Agents MUST read this file (`development-rules.md`), `docs/generated/code-map.md`, and the relevant `docs/module-contracts/` files only when adding, refactoring, or removing code or modules.
- Agents MAY skip the code map and module contracts for documentation-only tasks, configuration tweaks, or scoped bug fixes that do not change module boundaries or public surfaces.

## Code Discovery

- Agents MUST search existing modules, components, scripts, styles, tests, generated files, and configuration before adding new code.
- Agents MUST read `docs/generated/code-map.md` before adding long-lived files or modules.
- Agents MUST read the relevant `docs/module-contracts/` file before editing an owned module.
- Agents MUST prefer reusing or extending an owned module over creating a parallel implementation.

## File Organization

- Agents MUST keep code organized by feature, domain, runtime boundary, or infrastructure responsibility.
- Agents MUST NOT create or grow catch-all files when a smaller owned module can hold the behavior.
- Agents SHOULD split files above 400 lines before adding more behavior.
- Agents MUST split files above 800 lines or document why they must stay consolidated.
- Agents MUST name files by responsibility so the file name explains the feature, module, or runtime surface it owns.
- Agents MUST place new code near the feature, service, component, script, or infrastructure module that owns it unless the code is genuinely shared.

## Surface Updates

- Agents MUST update `docs/generated/code-map.md` when public entry points, reusable surfaces, or file layout changes.
- Agents MUST update the relevant `docs/module-contracts/` file when ownership, dependency rules, verification commands, or module boundaries change.
- Agents MUST add a new module contract when creating a long-lived feature, package, service, infrastructure area, or script suite with explicit ownership.

## Subagent Handoff

- Delegation prompts MUST include the goal, write scope, relevant read order, done-when criteria, and forbidden changes.
- Subagents MUST inspect the relevant code map and module contract before implementation.
- Subagents MUST keep changes inside the assigned write scope unless they report a blocker first.
- Subagents MUST report existing surfaces reused, new surfaces added, files changed, tests run, and unresolved risks.
```

## docs/references/<tool>-llms.txt Template

```text
<tool> quick reference for agents.

Commands
- command 1
- command 2

Constraints
- constraint 1
- constraint 2

Pitfalls
- pitfall 1
- pitfall 2
```

## docs/PLANS.md Template

```markdown
# Plans

## Goal

## Context

## Plan

- [ ] step 1
- [ ] step 2

## Progress Notes

## Open Questions
```

## docs/FRONTEND.md Template

```markdown
# Frontend

## Stack

| Concern | Choice |
| --- | --- |
| Framework | ... |
| Language | ... |
| Styling | ... |
| State | ... |

## Rendering Model

[Describe RSC vs client component strategy]

## Data Fetching Conventions

[Describe how server and client data fetching are handled]

## Component Organization

[Directory layout]

## Styling Ownership

[Describe where global styles, design tokens, CSS modules, component styles, and feature styles live.]

## Reuse Rules

[Describe shared UI primitives, feature components, hooks, state modules, and route-level ownership.]

## File Size Rules

[Describe when components, pages, hooks, and stylesheets must be split.]

## Performance Budget

[Lighthouse targets and Core Web Vitals targets]
```

## docs/INFRASTRUCTURE.md Template

```markdown
# Infrastructure

## Runtime Surfaces

| Surface | Responsibility | Owner | Source |
| --- | --- | --- | --- |
| Hosting | ... | ... | ... |
| CI/CD | ... | ... | ... |
| IaC | ... | ... | ... |
| Observability | ... | ... | ... |

## Configuration Ownership

[Describe environment variables, secret ownership, config files, and deployment settings.]

## Reuse Rules

[Describe existing Terraform modules, workflow jobs, deployment scripts, monitoring conventions, and runtime helpers that must be reused.]

## File Size Rules

[Describe when workflow files, IaC modules, and deployment scripts must be split.]

## Verification

[Describe plan, validate, dry-run, CI, and rollback checks.]
```

## docs/SECURITY.md Template

```markdown
# Security

## Authentication

[Describe auth provider and flow]

## Authorization

[Describe RLS or middleware-level authorization rules]

## Secret Management

| Variable | Purpose |
| --- | --- |
| ... | ... |

## Input Validation

[Describe validation strategy at API boundaries]

## Known Limitations

[Describe known security gaps and mitigations]
```

## docs/RELIABILITY.md Template

```markdown
# Reliability

## Platform Constraints

| Platform | Constraint | Impact |
| --- | --- | --- |
| ... | ... | ... |

## Caching Strategy

[Describe cache layers, TTLs, and invalidation]

## Error Handling and Observability

[Describe error capture, alerting, and logging]

## Graceful Degradation

| Failure | Degraded Behavior |
| --- | --- |
| ... | ... |

## Recovery Runbook

[Step-by-step recovery for known failure modes]
```

## docs/QUALITY_SCORE.md Template

```markdown
# Quality Score

## Targets

| Metric | Target | Current |
| --- | --- | --- |
| Lighthouse Performance | ≥ 90 | — |
| Test Coverage | ... | — |
| Error Rate | ... | — |

## Measurement

[How and when each metric is measured]

## History

[Track score changes across milestones]
```

## docs/PRODUCT_SENSE.md Template

```markdown
# Product Sense

## Problem

[Core user problem being solved]

## Target Users

[Primary and secondary personas]

## Value Proposition

[What makes this product worth using]

## Non-Goals

[Explicitly out of scope]

## Success Metrics

[How success is measured from a product perspective]
```

## docs/DESIGN.md Template

```markdown
# Design Decisions

## Decision Log

| Date | Decision | Rationale | Alternatives Rejected |
| --- | --- | --- | --- |
| ... | ... | ... | ... |

## Open Questions

[Unresolved design decisions]
```

## scripts/init.sh Template

There is no default `scripts/init.sh` template. Generate the script only after project-specific,
safe, idempotent initialization commands are confirmed. Do not generate a comment-only script.
