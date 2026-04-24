---
title: Harness-Init Skill Evaluation Loop
description: >-
  Design for a local, zero-cost automated evaluation loop that exercises the
  `harness-init` skill via Claude Code CLI and uses an LLM-as-judge phase to
  verify whether generated harness documents are sufficient for a fresh
  subagent to continue work, plus a model-free CI structural check for bundle
  integrity across all runtime targets.
---

## Context

This repository is the canonical source and multi-runtime distribution
channel for the `harness-init` skill. The skill interviews a project owner
and generates a starter set of harness documents (`README.md`, `AGENTS.md`,
`ARCHITECTURE.md`, `docs/*`, `scripts/init.sh`) that downstream agents read
before doing any work.

The skill's `SKILL.md` evolves as we tune wording, interview flow, and
output contract. Today we have no automated way to answer two questions
when a change lands:

1. Does the skill still produce a well-formed harness document tree?
2. Is the generated tree good enough that a freshly dispatched subagent
   could read it and continue project work without extra context?

The `starter-kit/` directory holds a static reference example of what a
"good" harness looks like, and `starter-kit/scripts/lint-architecture.sh`
plus `starter-kit/scripts/check-doc-links.sh` already enforce structural
expectations on committed docs. What is missing is an end-to-end loop that
exercises the skill itself.

## Goals

- Exercise `harness-init` end-to-end without paid API calls.
- Let an AI evaluate whether the generated harness is usable by a subagent.
- Keep CI deterministic and model-free; no API keys in CI.
- Ship the skill to four runtimes by committing `targets/` bundles only,
  without introducing a CLI or package.

## Non-Goals

- Automating installation into the four target runtimes.
- Guaranteeing byte-identical output across runs (LLM output is not
  deterministic; we accept structural and qualitative checks instead).
- Evaluating Codex or Antigravity execution locally. Those runtimes are
  covered by CI structural checks only.
- Building a golden-master regression fixture. Baseline drift is not
  worth the maintenance cost at this stage.

## Architecture

Five roles, of which only the local evaluation loop and the CI structural
check are new. The rest already exist and are unchanged.

| Layer | Path | When it runs | Model calls |
| --- | --- | --- | --- |
| Source of truth | `skill/` | Edited by humans or agents | None |
| Sync | `scripts/sync-skill-targets.sh` | Local and CI | None |
| Local evaluation loop | `scripts/test-skill-local.sh` | Developer runs before release | Two `claude -p` calls |
| CI structural check | `scripts/check-bundle-structure.sh` + existing lint | Every push/PR | None |
| Distribution | `targets/<runtime>/harness-init/` | Committed | None |

Flow:

1. A human or agent edits `skill/`.
2. `bash scripts/sync-skill-targets.sh` regenerates all four bundles in
   `targets/`.
3. The developer runs `bash scripts/test-skill-local.sh`. The script
   executes the skill once and judges the output once, writing a report.
4. The developer reads the report, decides whether to iterate on `skill/`
   or commit.
5. CI runs lint, sync idempotency, and the new bundle-structure check.
   CI never invokes a model.
6. Downstream users install each bundle by following the
   `INSTALL.md` inside the corresponding `targets/<runtime>/harness-init/`.

### Evaluation loop phases

The loop is two sequential `claude -p` headless calls with file handoff
between them.

1. Run phase. Creates an empty sandbox directory with `mktemp -d`, copies
   the Claude Code bundle from `targets/claude-code/harness-init/` into
   `<sandbox>/.claude/skills/harness-init/`, changes working directory
   into the sandbox, and invokes `claude -p` with a prompt that instructs
   the model to execute `harness-init` using the answers provided in the
   fixture file. The skill writes the harness document tree into the
   sandbox.

2. Judge phase. Invokes a second `claude -p` call, passing:
   - The judge rubric file (`tests/judge-rubric.md`) as the primary
     instruction.
   - A list of the sandbox's generated files with their contents concatenated.

   The judge produces a Markdown report on stdout in the format the rubric
   prescribes. The orchestration script captures that stdout into
   `tests/reports/<timestamp>/report.md` alongside a copy of the generated
   tree (`tests/reports/<timestamp>/generated/`), excluding the
   `.claude/skills/harness-init/` bundle copy, for post-hoc inspection.

3. Cleanup. The sandbox under `/tmp/` is removed on script exit via a
   trap, regardless of success or failure. Reports under `tests/reports/`
   persist but are gitignored.

### Exit code policy

The orchestration script exits non-zero when the judge report contains
any line matching `^- \[FAIL\]`. The rubric reserves `[PASS]` / `[FAIL]`
markers for the hard-checklist section only, so a plain `grep` is a
sufficient gate. Qualitative comments never cause failure. Non-zero exit
signals the developer to iterate; it is not a CI signal.

## Component Designs

### `scripts/test-skill-local.sh`

Purpose: orchestrate Run phase, Judge phase, report capture, cleanup.

Inputs:

- `tests/fixtures/interview.json` (answers to the ten interview questions)
- `tests/prompts/run.md` (Run-phase instruction)
- `tests/judge-rubric.md` (judge prompt and checklist)
- `targets/claude-code/harness-init/` (bundle to exercise)

Outputs:

- `tests/reports/<ISO8601 timestamp>/report.md`
- `tests/reports/<ISO8601 timestamp>/generated/` (generated tree only,
  excluding the `.claude/skills/harness-init/` bundle copy)
- Exit code 0 if no `[FAIL]` checklist lines, 1 otherwise

Behavior sketch (pseudocode, not final source):

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUNDLE="$ROOT_DIR/targets/claude-code/harness-init"
FIXTURE="$ROOT_DIR/tests/fixtures/interview.json"
RUBRIC="$ROOT_DIR/tests/judge-rubric.md"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
REPORT_DIR="$ROOT_DIR/tests/reports/$STAMP"
SANDBOX="$(mktemp -d)"

cleanup() { rm -rf "$SANDBOX"; }
trap cleanup EXIT

mkdir -p "$SANDBOX/.claude/skills"
cp -R "$BUNDLE" "$SANDBOX/.claude/skills/harness-init"
mkdir -p "$REPORT_DIR"

# Run phase
(
  cd "$SANDBOX"
  claude -p "$(cat "$ROOT_DIR/tests/prompts/run.md")" \
    --permission-mode bypassPermissions
) > "$REPORT_DIR/run-stdout.log"

mkdir -p "$REPORT_DIR/generated"
(cd "$SANDBOX" && find . -mindepth 1 -not -path './.claude*' \
   -exec cp -R --parents {} "$REPORT_DIR/generated/" \;)

# Judge phase
JUDGE_INPUT="$(mktemp)"
{
  cat "$RUBRIC"
  echo "---"
  echo "## Generated Tree"
  (cd "$SANDBOX" && find . -type f -not -path './.claude/*' | sort \
     | while read -r f; do
         echo "### $f"
         echo '```'
         cat "$f"
         echo '```'
       done)
} > "$JUDGE_INPUT"

claude -p "$(cat "$JUDGE_INPUT")" --permission-mode bypassPermissions \
  > "$REPORT_DIR/report.md"

if grep -q '^- \[FAIL\]' "$REPORT_DIR/report.md"; then
  exit 1
fi
```

Design points:

- The Run phase runs with `--permission-mode bypassPermissions` inside a
  throwaway directory so the model can freely create files without prompting.
- The Judge phase receives the rubric plus a concatenated tree dump. No
  tool calls are required on the judge side, so `bypassPermissions` is
  acceptable and keeps the call non-interactive.
- The sandbox is copied into the report directory before cleanup so that
  a failed run's artifacts are preserved for the developer to inspect.

### `tests/fixtures/interview.json`

Holds one canonical set of answers for the ten questions in `SKILL.md`.
JSON keeps the file diffable when we revise. Example shape:

```json
{
  "projectName": "acme-orders",
  "projectDescription": "Internal order intake service for ACME warehouse ops.",
  "techStack": "TypeScript, Fastify, PostgreSQL, Prisma",
  "teamSize": "Three engineers",
  "agentsInUse": "Claude Code, Codex",
  "primaryWorkflows": "Order intake, inventory reservation, shipping handoff",
  "coreConstraints": "No PII leaks, all mutations traced via request-id",
  "referenceTools": "fastify, prisma, postgres",
  "doneWhen": "Orders can be created, read, reserved, and shipped via API.",
  "projectContext": "Existing repo with legacy `lib/` that must stay compatible."
}
```

The Run-phase prompt embeds these values by reading the JSON and
formatting them into the interview exchange expected by `SKILL.md`.

### `tests/prompts/run.md`

Static instruction file the Run phase feeds to `claude -p`. It tells the
model: load the `harness-init` skill, treat the following JSON object as
the ten interview answers, execute the skill's generation rules, and
write the output files into the current directory. This file is short
and committed to the repo so that what the Run phase instructs is always
reviewable without reading shell.

### `tests/judge-rubric.md`

The rubric is the heart of the evaluation. Its framing is:

> You are a freshly dispatched subagent with no prior context. You are
> being asked to continue development work on the project described by
> the documents below. Before you accept the task, evaluate whether
> these documents give you enough structure to begin.

The rubric has two sections.

1. Hard checklist. Every item is reported as `- [PASS] ...` or `- [FAIL] ...`
   with a one-sentence justification. `[FAIL]` lines are what fail the run.
   Items:

   - Root `README.md`, `AGENTS.md`, `ARCHITECTURE.md` exist and are non-empty.
   - `AGENTS.md` contains a read order and a repository map.
   - `ARCHITECTURE.md` follows matklad's system-map style (sections for
     overview, code map, and cross-cutting concerns).
   - `docs/design-docs/index.md`, `docs/design-docs/core-beliefs.md`,
     `docs/exec-plans/tech-debt-tracker.md`, `docs/product-specs/index.md`
     all exist.
   - At least one `docs/references/*-llms.txt` exists.
   - `scripts/init.sh` exists and is executable.
   - `doneWhen` from the fixture is reflected in `AGENTS.md` and in at
     least one doc under `docs/product-specs/` or `docs/exec-plans/active/`.
   - Cross-document links use relative Markdown references and resolve
     to existing paths in the generated tree.

2. Subagent-delegation rubric (qualitative). Open-ended comments scored
   out of 5 with one paragraph of justification each. The judge must not
   use `[PASS]` / `[FAIL]` markers in this section.

   - Onboarding clarity: could a subagent pick up work using only these
     docs?
   - Boundary isolation: are modules and responsibilities distinct enough
     to split work?
   - Decision traceability: are constraints and rationale captured in
     design docs rather than scattered or missing?
   - Actionability: is there a clear first next step a subagent could
     take, evidenced by the tech-debt tracker or exec-plans content?

Note: v1 intentionally omits any direct comparison to `starter-kit/`.
The judge evaluates only the generated tree against intrinsic criteria.
Comparison can be added later by extending the judge input with selected
starter-kit documents.

The rubric ends with an instruction to emit, on the very first line of
the response, a summary of the form `SUMMARY: <n>/<total> hard checks
passed; subagent-score <average>/5`.

### `scripts/check-bundle-structure.sh`

Runs in CI. Walks each `targets/<runtime>/harness-init/` directory and
asserts:

- `SKILL.md` exists, is non-empty, and has a YAML frontmatter block
  containing at least `name`, `description`, and `disable-model-invocation`.
- `INSTALL.md` exists and is non-empty.
- `references/templates.md` exists.
- `scripts/scan-project.sh` exists and is executable.
- For `antigravity` only, `PROMPT.md` also exists.
- Every relative path referenced from `SKILL.md` and `INSTALL.md` resolves
  to an existing file within the bundle.

Script is pure `bash`. No model calls. Fails with a non-zero exit code
on first violation and prints the offending runtime and path.

### CI wiring

Add one step to `.github/workflows/ci.yml`:

```yaml
- name: Check Bundle Structure
  run: bash scripts/check-bundle-structure.sh
```

Placed after `Sync Skill Targets` and before `Verify Clean Worktree`, so
the check runs against freshly synced bundles.

## File Layout

New or changed paths:

| Path | Status | Purpose |
| --- | --- | --- |
| `scripts/test-skill-local.sh` | new | Local evaluation orchestrator |
| `scripts/check-bundle-structure.sh` | new | CI bundle schema check |
| `tests/fixtures/interview.json` | new | Canonical interview answers |
| `tests/prompts/run.md` | new | Run-phase instruction |
| `tests/judge-rubric.md` | new | Judge-phase rubric |
| `tests/reports/` | new (gitignored) | Per-run reports |
| `.gitignore` | modified | Add `tests/reports/` |
| `.github/workflows/ci.yml` | modified | Add bundle-structure step |

Unchanged: `skill/`, `targets/`, `starter-kit/`, `scripts/sync-skill-targets.sh`,
`README.md`, `AGENTS.md`, `ARCHITECTURE.md`.

## Risks and Mitigations

- Model output non-determinism may cause transient `[FAIL]` lines on
  re-runs. Mitigation: run the loop a second time when a FAIL is in
  doubt, and keep the hard checklist narrow to structural facts that
  a reasonable generation always satisfies.
- Large sandbox dumps could blow the judge call's context window.
  Mitigation: the Run phase's fixture is intentionally small and
  `harness-init` only generates the core document set; truncation is
  unnecessary in practice but the script can be extended to exclude
  `docs/references/*-llms.txt` from the judge input if needed.
- `claude -p` auth requires a Claude Code login on the developer's
  machine. This is a documented prerequisite rather than a mitigation,
  but the script will print a clear error if the `claude` binary is
  missing.

## Open Questions

None at design time. If the judge proves too lenient or too strict in
practice, the rubric file is the single place to tune.
