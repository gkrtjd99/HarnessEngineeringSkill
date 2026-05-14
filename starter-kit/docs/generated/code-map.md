# Code Map

This generated index helps agents find and reuse existing code before adding new files.

## How To Use

Read the relevant rows before implementation. Update this file when module ownership, public entry points, or file layout changes.

## Surfaces

| Area | Owner Module | Entry Points | Responsibility | Reuse Before Adding | Source |
| --- | --- | --- | --- | --- | --- |
| Frontend | `app/` | Routes, pages, UI components | User-facing screens and interactions | Existing routes, feature components, shared UI primitives | `app/` |
| Backend | `server/` | API handlers, services, workers | Server-side behavior and data workflows | Existing services, repositories, validators, jobs | `server/` |
| Infra | `infra/` | IaC, deployment config, CI/CD | Runtime platform and operational wiring | Existing modules, environment conventions, workflow jobs | `infra/` |
| Scripts | `scripts/` | Shell or task scripts | Local and CI automation | Existing commands and shared script helpers | `scripts/` |
| Shared | `packages/` | Public package exports | Cross-runtime reusable logic | Existing package exports and module contracts | `packages/` |
| Styles | `styles/` | Tokens, resets, globals | App-wide styling foundations | Existing tokens, CSS modules, component-local styles | `styles/` |
| Tests | `tests/` | Fixtures, prompts, test helpers, reports | Verification and regression coverage | Existing fixtures, helpers, snapshots, and test conventions | `tests/` |
| Generated | `docs/generated/` | Generated indexes and derived facts | Machine- or tool-generated project references | Existing generated docs before adding derived surfaces | `docs/generated/` |
| Development rules | `docs/references/development-rules.md` | Code discovery, file organization, surface update, handoff rules | Detailed implementation behavior that should not live in `AGENTS.md` | Existing development rules before changing agent behavior | `docs/references/development-rules.md` |

## Large Files

| File | Lines | Owner | Split Plan |
| --- | --- | --- | --- |
| `[path]` | `[count]` | `[owner]` | `[split or keep rationale]` |
