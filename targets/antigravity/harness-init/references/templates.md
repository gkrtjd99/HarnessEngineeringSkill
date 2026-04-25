# Template Reference

This document defines the generation rules used by the `harness-init` skill.

The repository treats this file and `skill/SKILL.md` as the canonical content source for all runtime bundles.

## Core Rule

Treat the following files as the core harness-engineering set:

- `README.md`
- `AGENTS.md`
- `ARCHITECTURE.md`
- `docs/design-docs/index.md`
- `docs/design-docs/core-beliefs.md`
- `docs/exec-plans/tech-debt-tracker.md`
- `docs/product-specs/index.md`
- at least one `docs/references/*-llms.txt` file

## Optional Docs

Generate each document only when its stated condition is met:

| File | Generate when... |
| --- | --- |
| `docs/FRONTEND.md` | A frontend tech stack is present (e.g., React, Vue, Next.js, SvelteKit) |
| `docs/SECURITY.md` | Authentication, authorization, or RLS is a core constraint |
| `docs/RELIABILITY.md` | Availability, resource limits, or fault tolerance matter (free-tier infra, SLAs, uptime targets) |
| `docs/generated/db-schema.md` | A database schema is described or implied |
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

If the input is blank or resolves to the fallback placeholder value, generate only `docs/references/stack-reference-llms.txt`.

## Language Rule

- `README.md` may be written in the user's language.
- Every other generated document must be written in English.

## AGENTS.md Template

```markdown
# AGENTS

## Read Order

1. ARCHITECTURE.md
2. docs/product-specs/index.md
3. docs/exec-plans/active/
4. docs/design-docs/
5. docs/references/

## Repository Map

- app/
- docs/
- scripts/
```

## README.md Template

```markdown
# Project Name

Brief project overview.

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

## Invariants
```

## docs/design-docs/index.md Template

```markdown
# Design Docs Index

- [ ] Core beliefs
- [ ] Architecture decisions
- [ ] Domain guides
```

## docs/design-docs/core-beliefs.md Template

```markdown
# Core Beliefs

## Product Principles

## Engineering Principles

## Verification Principles
```

## docs/exec-plans/tech-debt-tracker.md Template

```markdown
# Tech Debt Tracker

## Open Debt

## Prioritized Debt

## Resolved Debt
```

## docs/product-specs/index.md Template

```markdown
# Product Specs Index

## Active Specs

## Archived Specs
```

## docs/product-specs/<feature>.md Template

```markdown
# Feature Spec

## Problem

## Scope

## Constraints

## Done When
```

## docs/exec-plans/active/EP-0001-template.md Template

```markdown
# Execution Plan

## Goal

## Context

## Tasks

- [ ] task 1
- [ ] task 2

## Done When
```

## docs/references/stack-reference-llms.txt Template

```text
Reference for agents.
Include concise commands, constraints, and known pitfalls.
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

## Performance Budget

[Lighthouse targets and Core Web Vitals targets]
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

```bash
#!/usr/bin/env bash
set -euo pipefail

mkdir -p docs/design-docs docs/exec-plans/active docs/exec-plans/completed docs/generated docs/product-specs docs/references scripts
```
