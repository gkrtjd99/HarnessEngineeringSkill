# Module Contracts

Module contracts describe owned repository areas so agents can reuse existing surfaces and avoid catch-all files.

## Contract Index

| Module | Contract | Owner | Scope |
| --- | --- | --- | --- |
| Skill source | [skill.md](skill.md) | `skill/` | Canonical skill workflow, templates, runtime guides, helper scripts |
| Runtime bundles | [targets.md](targets.md) | `targets/` | Generated runtime packages |
| Starter kit | [starter-kit.md](starter-kit.md) | `starter-kit/` | Static reference harness documents |
| Automation | [scripts.md](scripts.md) | `scripts/` | Repository synchronization and validation scripts |

## Rules

- Agents MUST read the relevant contract before editing an owned area.
- Agents MUST add or update a module contract when creating a new long-lived feature, package, service, infrastructure area, or script suite.
- Contracts MUST name public entry points, reusable internals, forbidden dependencies, local file organization, and verification commands.
