---
name: harness-init
description: Collect project context and generate a harness-engineering repository structure
  including AGENTS.md, docs/, and scripts/. Trigger when a user wants to set up a new
  project, generate AI-agent operating documents, or prepare a repository for agent collaboration.
disable-model-invocation: false
allowed-tools: Read Write Bash
---

# Skill Overview

This skill is the canonical source for a repository operating structure generated from an interview.
It is intended to be packaged for Claude, Claude Code, Codex, and Antigravity without changing the underlying workflow.

## Interview Questions

Ask the following 10 questions in order:

1. Project name
2. Project description
3. Tech stack
4. Team size
5. AI agents in use
6. Primary workflows
7. Core constraints or rules
8. Which libraries or tools need `llms.txt` reference files? (for example: react, nextjs, prisma, uv, nixpacks)
9. What are the project's done-when or acceptance criteria?
10. Which existing files, folders, or documents must be referenced?

Treat a blank answer for question 8 as the fallback placeholder value `미정`.
Treat blank answers for questions 9 and 10 as the same fallback placeholder value.

## Generation Rules

- Summarize the interview into a project-specific `AGENTS.md`.
- Generate a project-specific `README.md`.
- Write `AGENTS.md` as a document map, not a long manual.
- Write `ARCHITECTURE.md` as the top-level structure document for the repository.
- Generate `CLAUDE.md` when it is useful for the target project.
- Always create the base directory structure: `docs/design-docs/`, `docs/exec-plans/active/`, `docs/exec-plans/completed/`, `docs/generated/`, `docs/product-specs/`, `docs/references/`.
- Use matklad's `ARCHITECTURE.md` style as the reference for the root `ARCHITECTURE.md`.
- Always create the harness core documents: `docs/design-docs/index.md`, `docs/design-docs/core-beliefs.md`, `docs/exec-plans/tech-debt-tracker.md`, and `docs/product-specs/index.md`.
- Generate detailed design notes under `docs/design-docs/` only when they are justified by the project.
- When generating `docs/PLANS.md`, follow the structure encouraged by the OpenAI Codex exec-plans article.
- Generate optional documents according to the condition table in `references/templates.md` — each optional document has an explicit condition; generate it only when that condition is met.
- If `referenceTools` is present, generate one `docs/references/<tool>-llms.txt` per tool.
- If `referenceTools` resolves to the fallback placeholder value, generate a single `docs/references/stack-reference-llms.txt`.
- Reflect `doneWhen` in `AGENTS.md` and in at least one document under `docs/product-specs/` or `docs/exec-plans/active/`.
- If `projectContext` is not the fallback placeholder value, reflect it in the `AGENTS.md` read order or repository map.
- Keep installation, run, and usage instructions in `README.md`; keep agent navigation rules in `AGENTS.md`.
- Generate `scripts/init.sh` to automate base directory initialization.
- Write `README.md` in the user's language or the language explicitly requested for the README.
- Write every other document in English, including `AGENTS.md`, `ARCHITECTURE.md`, `CLAUDE.md`, `docs/*`, and `*-llms.txt`.
- Keep the generated document set self-sufficient so another agent can continue work by reading the output docs only.

## Template Source

Use `references/templates.md` as the baseline template source.

## Output Contract

The minimum output must include:

1. `README.md`
2. `AGENTS.md`
3. `ARCHITECTURE.md`
4. The harness core `docs/` set
5. Optional project-specific documents
6. `scripts/init.sh`
