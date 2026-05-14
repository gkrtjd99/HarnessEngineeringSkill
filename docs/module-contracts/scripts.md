# Automation Contract

## Responsibility

`scripts/` owns repeatable repository automation for syncing runtime bundles.

## Public Entry Points

| Name | Kind | Purpose | Source |
| --- | --- | --- | --- |
| `sync-skill-targets.sh` | script | Regenerate runtime bundles from canonical skill source | [scripts/sync-skill-targets.sh](../../scripts/sync-skill-targets.sh) |

## Internal Reuse

| Surface | Reuse When | Source |
| --- | --- | --- |
| `prepare_bundle` | shell function | Adding or changing runtime bundle sync behavior | [scripts/sync-skill-targets.sh](../../scripts/sync-skill-targets.sh) |

## File Organization

Keep repository-level automation under `scripts/`. Shell constants MUST use uppercase names and local variables MUST use lowercase names.

## Dependency Rules

Scripts SHOULD operate from the repository root and avoid runtime-specific logic outside explicit runtime guide handling.

## Verification

Run `bash -n scripts/sync-skill-targets.sh` after shell changes.
