---
name: harness-init
description: >-
  Define a new software project through a guided product and engineering interview, then
  generate the repository harness needed for AI-driven development, including product
  context, agent instructions, architecture boundaries, verification rules, and an
  executable first plan. Use when starting a greenfield project, turning an idea into an
  agent-ready repository, or secondarily when adapting the same harness to an existing repository.
disable-model-invocation: false
allowed-tools: Read Write Bash
---

# Harness Init

Build the operating system for an AI-driven software project before feature implementation
starts. Treat new-project bootstrap as the primary workflow. Treat existing-project adoption
as a secondary compatibility path.

## Select the Workflow

- Default to **New Project Bootstrap** when the user is defining an idea, starting a new
  repository, or asking to prepare a project for AI-driven development.
- Use **Existing Project Adoption** only when meaningful code or project documents already
  exist and the user wants to add or improve a harness.
- Use **Audit Only** only when the user explicitly asks for assessment without file changes.

State the selected workflow. Do not make existing-project auditing the opening experience
for a new project.

## Primary Workflow: New Project Bootstrap

### 1. Inspect the Starting Point

Check whether the target directory is empty and read any seed brief, notes, prototypes, or
constraints already supplied. Run `scripts/scan-project.sh <target-directory>` only when the
directory contains useful context to inventory.

Do not ask for facts already present in user-provided material. Separate confirmed facts,
user decisions, proposed defaults, and open questions.

### 2. Define the Project

Read `references/project-definition.md` and run its guided interview.

- Ask one to three related questions per turn.
- Show section progress and summarize each completed section for confirmation.
- Offer concise choices and examples when they reduce user effort; always permit uncertainty.
- Explain unfamiliar product or engineering terms briefly.
- Detect contradictions and resolve them before generating documents.
- Never invent users, requirements, success metrics, dates, security controls, commands,
  ownership, or architectural decisions.
- Persist every confirmed interview section in
  `docs/product-specs/product-definition.draft.md`. Update the progress, confirmed decisions,
  proposed defaults, and open questions after each confirmation so another session can resume
  without replaying the interview.
- Run `scripts/check-generated-harness.sh --draft <target-directory>` after updating the draft
  when the script is available. Correct missing progress, decision, open-question, or next-question
  sections before continuing.

Collect enough detail to connect this chain:

`problem -> target user -> user outcome -> P0 capability -> acceptance criterion -> verification`

Also define the AI development loop:

`context -> scoped task -> implementation -> automated checks -> review checkpoint -> handoff`

Do not force every optional question. Skip sections already answered and go deeper only where
ambiguity would change product scope, architecture, verification, or the first milestone.

When a draft exists, read it before asking questions. State the recovered progress, preserve
confirmed decisions, and ask only the next unresolved consequential question. Treat the draft as
working context, not as final authority: user corrections always supersede it.

### 3. Review the Definition

Before writing the harness, present a concise definition review:

- product one-liner, problem, target user, and value proposition;
- MVP in-scope and out-of-scope;
- P0 user journeys with acceptance criteria;
- measurable success signals;
- confirmed constraints, assumptions, dependencies, and risks;
- proposed stack and architecture decisions, clearly labeled as confirmed or proposed;
- AI agents, autonomy boundaries, human checkpoints, and verification commands;
- first deliverable and its done-when criteria;
- unresolved questions that can safely remain open.

Ask the user to confirm or correct the review unless the user explicitly requested autonomous
execution and provided enough context to resolve all critical decisions.

After confirmation, reconcile the draft into `docs/product-specs/product-definition.md`. Keep
the draft only when material open questions remain; otherwise remove it after the final document
contains every confirmed decision and open question.

### 4. Generate the AI Development Harness

Read `references/templates.md`. Generate concrete project content rather than copying template
markers. Prefer a small authoritative document set over a large empty hierarchy.

Create these bootstrap documents:

1. `README.md` — human-facing purpose, setup status, and usage.
2. `AGENTS.md` — short agent entry point, read order, rules, and done-when summary.
3. `CLAUDE.md` — Claude Code auto-load bridge containing `@AGENTS.md`; keep `AGENTS.md` canonical.
4. `ARCHITECTURE.md` — planned system map, boundaries, dependency direction, and invariants.
5. `docs/product-specs/product-definition.md` — confirmed product definition, requirements,
   journeys, acceptance criteria, success signals, scope, risks, and open questions.
6. `docs/exec-plans/active/EP-0001-initial-delivery.md` — the first independently verifiable
   implementation slice.
7. `docs/references/development-rules.md` — discovery, change, verification, and handoff rules.
8. `docs/generated/code-map.md` — planned source areas and public surfaces, explicitly marked
   as planned until implementation exists.

Create additional documents only when justified:

- `docs/design-docs/core-beliefs.md` for durable product or engineering principles.
- `docs/module-contracts/<module>.md` for a durable multi-file boundary with non-obvious
  ownership or reuse rules.
- `docs/FRONTEND.md`, `docs/BACKEND.md`, `docs/INFRASTRUCTURE.md`, `docs/SECURITY.md`, or
  `docs/RELIABILITY.md` when those concerns materially affect the first milestone.
- stack references only when they contain maintained, project-specific commands, constraints,
  or pitfalls.
- `scripts/init.sh` only when it performs safe, idempotent project initialization beyond
  creating empty directories.

Keep all generated claims traceable to confirmed interview answers, supplied artifacts, or
clearly labeled proposals. Put unresolved non-blocking decisions under `Open Questions`.

### 5. Verify Readiness

Verify the generated harness before reporting completion:

- every internal Markdown link resolves;
- `AGENTS.md` stays under 100 lines and acts as a map;
- product definition, architecture, code map, and first execution plan agree on names,
  boundaries, scope, and done-when criteria;
- every P0 capability has an acceptance criterion;
- the first execution plan produces a user-visible or technically verifiable vertical slice;
- documented commands are either verified or explicitly marked as pending project setup;
- `CLAUDE.md` contains the `@AGENTS.md` bridge without duplicating the canonical agent rules;
- generated files contain no template markers, fake paths, or invented facts.

Run `scripts/check-generated-harness.sh --final <target-directory>` when the script is available.
Treat a failed check as incomplete generation and correct the reported issue before handoff.

Report the created files, confirmed decisions, proposed defaults, remaining open questions,
and the exact first command or task with which development can begin.

## Secondary Workflow: Existing Project Adoption

Run `scripts/scan-project.sh <target-directory>` and read existing instructions, README files,
manifests, CI configuration, architecture documents, and primary code areas. Produce an
evidence-based inventory and gap list before editing.

Preserve useful authority. Improve existing documents in place and add only missing harness
responsibilities. Never create a competing instruction system or replace a human-authored root
document with a generic template. Ask before a substantial rewrite whose purpose conflicts with
the proposed harness.

When Claude Code is a target runtime, preserve or add a root `CLAUDE.md` that imports the
authoritative `AGENTS.md`. Keep the bridge minimal and do not duplicate the project's operating
rules in it.

Use the project-definition interview only for consequential product or engineering facts that
cannot be established from the repository. Verify the same consistency and link rules as the
bootstrap workflow.

## Audit-Only Workflow

Perform the existing-project discovery step and report:

- what already enables AI-driven development;
- missing or contradictory context;
- the highest-leverage harness improvements;
- exact files that would change and why.

Do not write files.

## Language

Conduct the interview and write `README.md` in the user's language unless requested otherwise.
Write agent-operating documents in the project team's chosen working language. Do not impose
English when another language will be maintained more reliably by the team.
