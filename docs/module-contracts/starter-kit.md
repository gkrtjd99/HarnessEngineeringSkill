# Starter Kit Contract

## Responsibility

`starter-kit/` owns the static reference shape for generated harness documents.

## Public Entry Points

| Name | Kind | Purpose | Source |
| --- | --- | --- | --- |
| Agent entry point | document | Baseline collaboration rules | [starter-kit/AGENTS.md](../../starter-kit/AGENTS.md) |
| Architecture template | document | Stable project structure map | [starter-kit/ARCHITECTURE.md](../../starter-kit/ARCHITECTURE.md) |
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
