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
