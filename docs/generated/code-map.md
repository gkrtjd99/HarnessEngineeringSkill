# Code Map

This generated index helps agents find and reuse existing repository surfaces before adding new files.

## How To Use

Read the relevant rows before implementation. Update this file when module ownership, public entry points, or file layout changes.

## Surfaces

| Area | Owner Module | Entry Points | Responsibility | Reuse Before Adding | Source |
| --- | --- | --- | --- | --- | --- |
| Skill source | `skill/` | `SKILL.md`, `references/project-definition.md`, `references/templates.md`, `runtime-guides/`, `scripts/scan-project.sh`, `scripts/check-generated-harness.sh` | Canonical new-project definition, persistent interview, harness generation, and final-output validation | Existing interview sections, generation rules, templates, inventory output, validator, and runtime guide structure | [skill/SKILL.md](../../skill/SKILL.md) |
| Runtime bundles | `targets/` | Runtime-specific `harness-init/` bundles | Generated installable outputs for supported agent runtimes | `bash scripts/sync-skill-targets.sh`; do not edit bundles by hand | [targets/README.md](../../targets/README.md) |
| Starter kit | `starter-kit/` | Root docs including the `CLAUDE.md` bridge, optional docs, sample workflows, helper scripts | Static reference shape for generated project harnesses | Existing starter-kit docs before changing templates | [starter-kit/AGENTS.md](../../starter-kit/AGENTS.md) |
| Repository automation | `scripts/` | `sync-skill-targets.sh`, `test-skill-local.sh` | Synchronize canonical skill source into runtime targets and optionally run a model-based evaluation | Existing sync flow, evaluation runner, and shell conventions | [scripts/sync-skill-targets.sh](../../scripts/sync-skill-targets.sh) |
| Design docs | `docs/design-docs/` | `architecture.md`, `new-project-workflow.md`, `skill-distribution.md`, `code-organization-contract.md` | Rationale, tradeoffs, and evolution notes | Existing design note before adding new rationale | [docs/design-docs/index.md](../design-docs/index.md) |
| References | `docs/references/` | `harness-engineering.md` | Durable harness principles and generator contract | Existing reference contract before expanding templates | [docs/references/harness-engineering.md](../references/harness-engineering.md) |
| Development rules | `docs/references/development-rules.md` | Code discovery, file organization, surface update, handoff rules | Detailed implementation behavior that should not live in `AGENTS.md` | Existing development rules before changing agent behavior | [docs/references/development-rules.md](../references/development-rules.md) |
| Tests | `tests/` (gitignored, local-only) | Fixtures, prompts, judge rubric, and reports for optional local evaluation | Local skill evaluation inputs and results; not part of the committed runtime surface | Existing local fixtures and rubric before changing the evaluator | `tests/` |
| Generated docs | `docs/generated/` | `code-map.md`, `db-schema.md` | Generated indexes and derived repository facts | Existing generated document ownership before adding derived docs | [docs/generated/db-schema.md](db-schema.md) |
| Module contracts | `docs/module-contracts/` | `README.md`, module contract files | Module ownership, public surfaces, dependency rules, verification commands | Relevant module contract before implementation | [docs/module-contracts/README.md](../module-contracts/README.md) |

## Large Files

| File | Lines | Owner | Split Plan |
| --- | --- | --- | --- |
| `[path]` | `[count]` | `[owner]` | Add a split plan when a file crosses the repository threshold. |
