# Runtime Bundles Contract

## Responsibility

`targets/` owns generated runtime bundles for supported agent tools.

## Public Entry Points

| Name | Kind | Purpose | Source |
| --- | --- | --- | --- |
| Claude bundle | generated bundle | Uploadable Claude skill package | [targets/claude/harness-init/](../../targets/claude/harness-init/) |
| Claude Code bundle | generated bundle | Filesystem skill package for Claude Code | [targets/claude-code/harness-init/](../../targets/claude-code/harness-init/) |
| Codex bundle | generated bundle | Filesystem skill package for Codex | [targets/codex/harness-init/](../../targets/codex/harness-init/) |
| OpenCode bundle | generated bundle | Filesystem skill package for OpenCode | [targets/opencode/harness-init/](../../targets/opencode/harness-init/) |
| Antigravity bundle | generated bundle | Prompt adapter bundle for Antigravity | [targets/antigravity/harness-init/](../../targets/antigravity/harness-init/) |

## Internal Reuse

| Surface | Reuse When | Source |
| --- | --- | --- |
| Sync script | Updating generated bundles | [scripts/sync-skill-targets.sh](../../scripts/sync-skill-targets.sh) |
| Canonical skill source | Changing bundle content | [skill/](../../skill/) |

## File Organization

Each runtime bundle lives under `targets/<runtime>/harness-init/`.

## Dependency Rules

Agents MUST NOT hand-edit runtime bundle content when the same change belongs in `skill/`.

## Verification

Run `bash scripts/sync-skill-targets.sh` and inspect the resulting target changes.
