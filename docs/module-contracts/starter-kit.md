# Starter Kit Contract

## Responsibility

`starter-kit/` owns the static reference shape for generated harness documents.

## Public Entry Points

| Name | Kind | Purpose | Source |
| --- | --- | --- | --- |
| Agent entry point | document | Baseline collaboration rules | [starter-kit/AGENTS.md](../../starter-kit/AGENTS.md) |
| Claude Code bridge | document | Auto-loads the canonical agent entry point in Claude Code | [starter-kit/CLAUDE.md](../../starter-kit/CLAUDE.md) |
| Architecture template | document | Stable project structure map | [starter-kit/ARCHITECTURE.md](../../starter-kit/ARCHITECTURE.md) |
| Product definition | document | Trace problems and P0 capabilities to acceptance criteria | [starter-kit/docs/product-specs/product-definition.md](../../starter-kit/docs/product-specs/product-definition.md) |
| First delivery plan | document | Define the first independently verifiable vertical slice | [starter-kit/docs/exec-plans/active/EP-0001-initial-delivery.md](../../starter-kit/docs/exec-plans/active/EP-0001-initial-delivery.md) |
| Optional docs | documents | Reference examples for generated docs | [starter-kit/docs/](../../starter-kit/docs/) |

## Internal Reuse

| Surface | Reuse When | Source |
| --- | --- | --- |
| Generated docs examples | Adding or changing template expectations | [starter-kit/docs/](../../starter-kit/docs/) |
| Starter-kit scripts | Adding sample validation behavior | [starter-kit/scripts/](../../starter-kit/scripts/) |

## File Organization

Keep sample documents in the same relative paths that generated projects should receive.

## Dependency Rules

Starter-kit changes SHOULD stay semantically aligned with `skill/references/templates.md`.

## Verification

Check the starter-kit tree against the template reference when generated document shape changes.
