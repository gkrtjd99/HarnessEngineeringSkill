# Development Rules

This document holds detailed development rules that should not live in `AGENTS.md`.
`AGENTS.md` stays a short navigation map.

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
