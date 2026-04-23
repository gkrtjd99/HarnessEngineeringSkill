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

Generate the following documents only when the project needs them:

- `docs/exec-plans/active/EP-xxxx.md`
- `docs/exec-plans/completed/EP-xxxx.md`
- `docs/generated/db-schema.md`
- `docs/product-specs/<feature>.md`
- `docs/DESIGN.md`
- `docs/FRONTEND.md`
- `docs/PLANS.md`
- `docs/PRODUCT_SENSE.md`
- `docs/QUALITY_SCORE.md`
- `docs/RELIABILITY.md`
- `docs/SECURITY.md`

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

## scripts/init.sh Template

```bash
#!/usr/bin/env bash
set -euo pipefail

mkdir -p docs/design-docs docs/exec-plans/active docs/exec-plans/completed docs/generated docs/product-specs docs/references scripts
```
