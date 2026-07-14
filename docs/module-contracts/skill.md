# Skill Source Contract

## Responsibility

`skill/` owns the canonical `harness-init` new-project definition, AI-development harness
generation, verification, and secondary adoption workflow. It also owns shared references,
runtime install notes, and helper scripts copied into runtime bundles.

## Public Entry Points

| Name | Kind | Purpose | Source |
| --- | --- | --- | --- |
| `harness-init` | skill | Collect project context and generate operating documents | [skill/SKILL.md](../../skill/SKILL.md) |
| Project definition | document | Guide the product, engineering, agent, and verification interview | [skill/references/project-definition.md](../../skill/references/project-definition.md) |
| Template reference | document | Define generated document rules and templates | [skill/references/templates.md](../../skill/references/templates.md) |
| Runtime guides | documents | Provide runtime-specific install and prompt guidance | [skill/runtime-guides/](../../skill/runtime-guides/) |
| Project scan | script | Produce a read-only repository inventory before harness changes | [skill/scripts/scan-project.sh](../../skill/scripts/scan-project.sh) |
| Generated harness check | script | Verify a final harness or persisted interview draft before handoff | [skill/scripts/check-generated-harness.sh](../../skill/scripts/check-generated-harness.sh) |

## Internal Reuse

| Surface | Reuse When | Source |
| --- | --- | --- |
| Optional docs table | Adding generated document types | [skill/references/templates.md](../../skill/references/templates.md) |
| Definition interview | Changing project questions or readiness gates | [skill/references/project-definition.md](../../skill/references/project-definition.md) |
| Mode and generation rules | Changing bootstrap, adoption, or output behavior | [skill/SKILL.md](../../skill/SKILL.md) |
| Repository inventory | Auditing a project before targeted questions or document changes | [skill/scripts/scan-project.sh](../../skill/scripts/scan-project.sh) |
| Harness validation | Verifying generated project documents before reporting readiness | [skill/scripts/check-generated-harness.sh](../../skill/scripts/check-generated-harness.sh) |
| Runtime guide layout | Adding or changing runtime packaging | [skill/runtime-guides/](../../skill/runtime-guides/) |

## File Organization

Keep canonical workflow instructions in `skill/SKILL.md`. Keep reusable template text in `skill/references/`. Keep runtime-specific installation details under `skill/runtime-guides/<runtime>/`. Keep helper scripts under `skill/scripts/`.

## Dependency Rules

`targets/` MUST be generated from `skill/`. Do not copy target-only edits back into `skill/` without checking the canonical contract.

## Verification

Run `bash scripts/sync-skill-targets.sh` after changing `skill/`. Run `bash -n` for changed shell scripts.
