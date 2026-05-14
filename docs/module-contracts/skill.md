# Skill Source Contract

## Responsibility

`skill/` owns the canonical `harness-init` workflow, generation rules, template reference, runtime install notes, and helper scripts copied into runtime bundles.

## Public Entry Points

| Name | Kind | Purpose | Source |
| --- | --- | --- | --- |
| `harness-init` | skill | Collect project context and generate operating documents | [skill/SKILL.md](../../skill/SKILL.md) |
| Template reference | document | Define generated document rules and templates | [skill/references/templates.md](../../skill/references/templates.md) |
| Runtime guides | documents | Provide runtime-specific install and prompt guidance | [skill/runtime-guides/](../../skill/runtime-guides/) |
| Project scan | script | Inspect a target project document tree | [skill/scripts/scan-project.sh](../../skill/scripts/scan-project.sh) |

## Internal Reuse

| Surface | Reuse When | Source |
| --- | --- | --- |
| Optional docs table | Adding generated document types | [skill/references/templates.md](../../skill/references/templates.md) |
| Generation rules | Changing output behavior | [skill/SKILL.md](../../skill/SKILL.md) |
| Runtime guide layout | Adding or changing runtime packaging | [skill/runtime-guides/](../../skill/runtime-guides/) |

## File Organization

Keep canonical workflow instructions in `skill/SKILL.md`. Keep reusable template text in `skill/references/`. Keep runtime-specific installation details under `skill/runtime-guides/<runtime>/`. Keep helper scripts under `skill/scripts/`.

## Dependency Rules

`targets/` MUST be generated from `skill/`. Do not copy target-only edits back into `skill/` without checking the canonical contract.

## Verification

Run `bash scripts/sync-skill-targets.sh` after changing `skill/`. Run `bash -n` for changed shell scripts.
