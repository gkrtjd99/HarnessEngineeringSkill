# Skill Evaluation Loop Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a local Claude Code CLI-based evaluation loop (Run + Judge) that validates `harness-init` skill changes, plus a model-free CI bundle-structure checker for all four runtime targets.

**Architecture:** Two new shell scripts under `scripts/`, three static content files under `tests/`, one `.gitignore` entry, one new CI step. No new external dependencies. All orchestration is bash + the existing `claude` CLI.

**Tech Stack:** Bash (macOS `/bin/bash` 3.2 compatible where feasible; `mapfile` is bash 4 only so gated behind a helper), Claude Code CLI (already installed locally and logged in), GitHub Actions (ubuntu-latest).

---

## File Structure

Files created:

- `scripts/test-skill-local.sh` — local evaluation loop orchestrator (Run + Judge)
- `scripts/check-bundle-structure.sh` — CI bundle integrity checker
- `tests/fixtures/interview.json` — canonical interview answers
- `tests/prompts/run.md` — Run-phase instruction prefix
- `tests/judge-rubric.md` — Judge-phase rubric and output contract

Files modified:

- `.gitignore` — ignore `tests/reports/`
- `.github/workflows/ci.yml` — add bundle-structure check step

Responsibility boundaries:

- `scripts/test-skill-local.sh`: orchestration only. Never evaluates content directly; delegates to `claude -p` (Run) and `claude -p` (Judge).
- `scripts/check-bundle-structure.sh`: static assertions only. Never calls a model.
- `tests/prompts/run.md` + `tests/fixtures/interview.json`: inputs to Run phase; script concatenates them at runtime.
- `tests/judge-rubric.md`: sole source of Judge instructions and output contract.

---

## Task 1: Static test assets — .gitignore, interview.json

**Files:**

- Modify: `.gitignore` (append one line)
- Create: `tests/fixtures/interview.json`

- [ ] **Step 1: Append `tests/reports/` to .gitignore**

Append to `.gitignore`:

```text

# 평가 리포트
tests/reports/
```

- [ ] **Step 2: Create tests/fixtures/interview.json**

Create `tests/fixtures/interview.json`:

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

- [ ] **Step 3: Verify**

Run: `jq . tests/fixtures/interview.json >/dev/null`
Expected: exits 0 (valid JSON).

- [ ] **Step 4: Commit**

```bash
git add .gitignore tests/fixtures/interview.json
git commit -m "$(cat <<'EOF'
chore: 평가 픽스처와 리포트 경로 gitignore 추가

- tests/fixtures/interview.json에 harness-init 10문항 표준 답변을 고정한다.
- tests/reports/ 디렉토리를 gitignore에 추가해 로컬 평가 리포트가 저장소에 들어가지 않게 한다.
EOF
)"
```

---

## Task 2: Run-phase prompt prefix

**Files:**

- Create: `tests/prompts/run.md`

- [ ] **Step 1: Create tests/prompts/run.md**

Create `tests/prompts/run.md` with exact content:

````markdown
You are operating inside an empty sandbox project directory. The `harness-init` skill is installed at `.claude/skills/harness-init/`.

Your task:

1. Load the `harness-init` skill from `.claude/skills/harness-init/SKILL.md`.
2. Treat the JSON object appended at the end of this prompt as the user's answers to the ten interview questions defined in the skill. The JSON keys map 1:1 to the question subjects in `SKILL.md` (`projectName`, `projectDescription`, `techStack`, `teamSize`, `agentsInUse`, `primaryWorkflows`, `coreConstraints`, `referenceTools`, `doneWhen`, `projectContext`).
3. Execute every generation rule in `SKILL.md` using those answers.
4. Write all generated files into the current working directory.
5. Do not ask clarifying questions. Do not pause for confirmation. Do not modify files under `.claude/`.

When finished, emit exactly one line to stdout: `RUN_DONE`.

Interview answers (JSON):
````

- [ ] **Step 2: Verify file exists and is non-empty**

Run: `test -s tests/prompts/run.md && echo ok`
Expected: `ok`

- [ ] **Step 3: Commit**

```bash
git add tests/prompts/run.md
git commit -m "$(cat <<'EOF'
feat: Run 페이즈 프롬프트 추가

- tests/prompts/run.md에 Claude Code CLI가 harness-init 스킬을 무대화 없이 실행하도록 지시하는 고정 프롬프트를 둔다.
- 실행 완료 시그널로 RUN_DONE 한 줄을 stdout에 출력하게 하여 오케스트레이터가 성공 여부를 쉽게 판별하게 한다.
EOF
)"
```

---

## Task 3: Judge rubric

**Files:**

- Create: `tests/judge-rubric.md`

- [ ] **Step 1: Create tests/judge-rubric.md**

Create `tests/judge-rubric.md` with exact content:

````markdown
You are a freshly dispatched subagent with no prior context. You have been asked to continue development work on the project described by the documents below. Your job right now is not to do the work, but to evaluate whether these documents give you enough structure to begin.

Emit a report in Markdown. The very first line MUST be a summary line of exactly the form:

```
SUMMARY: <n>/<total> hard checks passed; subagent-score <average>/5
```

Where `<n>` is the count of `[PASS]` items, `<total>` is 8, and `<average>` is the arithmetic mean of the four subagent-delegation scores rounded to one decimal.

Then produce the two sections below.

## Hard Checklist

For each item, emit exactly one line starting with `- [PASS]` or `- [FAIL]`, followed by a space and a one-sentence justification. Use `[PASS]` / `[FAIL]` markers in this section ONLY; never use them anywhere else in the report.

Items to evaluate (in this order):

1. Root `README.md`, `AGENTS.md`, and `ARCHITECTURE.md` all exist in the generated tree and are non-empty.
2. `AGENTS.md` contains both an explicit read order and a repository map.
3. `ARCHITECTURE.md` follows matklad's system-map style, with sections for high-level overview, code map by directory, and cross-cutting concerns.
4. All four harness core docs exist: `docs/design-docs/index.md`, `docs/design-docs/core-beliefs.md`, `docs/exec-plans/tech-debt-tracker.md`, `docs/product-specs/index.md`.
5. At least one file matching `docs/references/*-llms.txt` exists and is non-empty.
6. `scripts/init.sh` exists.
7. The `doneWhen` / acceptance criteria supplied in the interview answers is reflected both in `AGENTS.md` and in at least one document under `docs/product-specs/` or `docs/exec-plans/active/`.
8. Cross-document Markdown links inside the generated tree use relative paths and every such link resolves to a file that exists in the tree.

## Subagent-Delegation Rubric

For each of the four axes below, assign an integer score from 1 to 5 and write one paragraph of justification. Do NOT use `[PASS]` or `[FAIL]` markers in this section.

- Onboarding clarity: could a subagent pick up work using only these docs?
- Boundary isolation: are modules and responsibilities distinct enough to split work across subagents?
- Decision traceability: are constraints and rationale captured in design docs rather than scattered or missing?
- Actionability: is there a clear first next step a subagent could take, evidenced by the tech-debt tracker or exec-plans content?

---

The generated document tree to evaluate follows below. Read all of it before emitting the report.
````

- [ ] **Step 2: Verify file exists and is non-empty**

Run: `test -s tests/judge-rubric.md && echo ok`
Expected: `ok`

- [ ] **Step 3: Commit**

```bash
git add tests/judge-rubric.md
git commit -m "$(cat <<'EOF'
feat: Judge 루브릭 추가

- tests/judge-rubric.md에 서브에이전트 위임 관점의 하드 체크리스트 8항목과 질적 평가 4축(5점 척도)을 명시한다.
- 응답 첫 줄 SUMMARY 포맷과 [PASS]/[FAIL] 사용 범위 제약을 계약으로 고정해 오케스트레이터의 exit-code 파싱이 깨지지 않도록 한다.
EOF
)"
```

---

## Task 4: Bundle structure checker

**Files:**

- Create: `scripts/check-bundle-structure.sh`

- [ ] **Step 1: Create scripts/check-bundle-structure.sh**

Create `scripts/check-bundle-structure.sh` with exact content:

```bash
#!/usr/bin/env bash
set -euo pipefail

: '
check-bundle-structure.sh

Validates that every runtime bundle under targets/<runtime>/harness-init/ has
the required files, SKILL.md frontmatter keys, and intra-bundle relative link
integrity. Exits non-zero on the first violation with a clear message.
'

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGETS_DIR="$ROOT_DIR/targets"

REQUIRED_COMMON=(
  "SKILL.md"
  "INSTALL.md"
  "references/templates.md"
  "scripts/scan-project.sh"
)

REQUIRED_FRONTMATTER_KEYS=(
  "name:"
  "description:"
  "disable-model-invocation:"
)

fail() {
  echo "[check-bundle-structure] FAIL: $1" >&2
  exit 1
}

check_bundle() {
  local runtime="$1"
  local bundle="$TARGETS_DIR/$runtime/harness-init"
  local rel path skill doc doc_dir refs ref

  [[ -d "$bundle" ]] || fail "$runtime: bundle directory missing: $bundle"

  for rel in "${REQUIRED_COMMON[@]}"; do
    path="$bundle/$rel"
    [[ -s "$path" ]] || fail "$runtime: required file missing or empty: $rel"
  done

  [[ -x "$bundle/scripts/scan-project.sh" ]] \
    || fail "$runtime: scripts/scan-project.sh is not executable"

  skill="$bundle/SKILL.md"
  head -1 "$skill" | grep -q '^---$' \
    || fail "$runtime: SKILL.md is missing its YAML frontmatter opener"
  for rel in "${REQUIRED_FRONTMATTER_KEYS[@]}"; do
    grep -q "^$rel" "$skill" \
      || fail "$runtime: SKILL.md frontmatter missing key: $rel"
  done

  if [[ "$runtime" == "antigravity" ]]; then
    [[ -s "$bundle/PROMPT.md" ]] \
      || fail "$runtime: PROMPT.md missing or empty"
  fi

  for doc in "$skill" "$bundle/INSTALL.md"; do
    doc_dir="$(dirname "$doc")"
    refs="$(grep -oE '\]\([^)]+\)' "$doc" | sed -E 's/^\]\(|\)$//g' || true)"
    while IFS= read -r ref; do
      [[ -z "$ref" ]] && continue
      case "$ref" in
        http*|/*|\#*) continue ;;
      esac
      ref="${ref%%#*}"
      [[ -z "$ref" ]] && continue
      [[ -e "$doc_dir/$ref" ]] \
        || fail "$runtime: $doc references non-existent path: $ref"
    done <<< "$refs"
  done

  echo "[check-bundle-structure] PASS: $runtime"
}

for runtime in claude claude-code codex antigravity; do
  check_bundle "$runtime"
done

echo "[check-bundle-structure] All bundles OK."
```

- [ ] **Step 2: Make executable**

Run: `chmod +x scripts/check-bundle-structure.sh`

- [ ] **Step 3: Syntax check**

Run: `bash -n scripts/check-bundle-structure.sh`
Expected: no output, exit 0.

- [ ] **Step 4: Positive run against current targets/**

Run: `bash scripts/check-bundle-structure.sh`
Expected stdout (order matters):

```
[check-bundle-structure] PASS: claude
[check-bundle-structure] PASS: claude-code
[check-bundle-structure] PASS: codex
[check-bundle-structure] PASS: antigravity
[check-bundle-structure] All bundles OK.
```

Exit code: 0.

- [ ] **Step 5: Negative test — temporarily corrupt a bundle and verify failure**

Run:

```bash
mv targets/claude-code/harness-init/INSTALL.md targets/claude-code/harness-init/INSTALL.md.bak
bash scripts/check-bundle-structure.sh; echo "exit=$?"
mv targets/claude-code/harness-init/INSTALL.md.bak targets/claude-code/harness-init/INSTALL.md
```

Expected: second line includes `FAIL: claude-code: required file missing or empty: INSTALL.md` and `exit=1`.

- [ ] **Step 6: Commit**

```bash
git add scripts/check-bundle-structure.sh
git commit -m "$(cat <<'EOF'
feat: 타겟 번들 구조 검증 스크립트 추가

- scripts/check-bundle-structure.sh가 4개 런타임 번들의 필수 파일, SKILL.md frontmatter, 상대경로 링크 무결성을 검사한다.
- antigravity만 PROMPT.md를 추가로 요구하는 런타임별 차이를 단일 스크립트에서 분기한다.
- 모델 호출 없이 순수 bash로 동작해 CI에서 결정적으로 돌 수 있게 한다.
EOF
)"
```

---

## Task 5: Wire bundle-structure check into CI

**Files:**

- Modify: `.github/workflows/ci.yml`

- [ ] **Step 1: Insert the step between "Sync Skill Targets" and "Verify Clean Worktree"**

Locate in `.github/workflows/ci.yml` the block:

```yaml
      - name: Sync Skill Targets
        run: bash scripts/sync-skill-targets.sh

      - name: Verify Clean Worktree
```

Insert between them:

```yaml
      - name: Sync Skill Targets
        run: bash scripts/sync-skill-targets.sh

      - name: Check Bundle Structure
        run: bash scripts/check-bundle-structure.sh

      - name: Verify Clean Worktree
```

- [ ] **Step 2: Workflow syntax sanity**

Run: `bash -n scripts/check-bundle-structure.sh && python3 -c 'import yaml; yaml.safe_load(open(".github/workflows/ci.yml"))'`
Expected: no errors. (If `python3` is unavailable, skip the YAML parse and only `bash -n` the script.)

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/ci.yml
git commit -m "$(cat <<'EOF'
ci: 번들 구조 검증 스텝 추가

- sync-skill-targets 직후 check-bundle-structure.sh를 실행해 동기화된 번들이 스키마를 만족하는지 push/PR마다 확인한다.
- verify-clean-worktree 앞에 배치해 구조 문제와 sync 불일치를 구분해 알려준다.
EOF
)"
```

---

## Task 6: Scaffold test-skill-local.sh (no model calls yet)

**Files:**

- Create: `scripts/test-skill-local.sh`

- [ ] **Step 1: Create scripts/test-skill-local.sh (scaffolding only)**

Create `scripts/test-skill-local.sh` with exact content:

```bash
#!/usr/bin/env bash
set -euo pipefail

: '
test-skill-local.sh

Runs the harness-init skill end-to-end in a throwaway sandbox using Claude
Code CLI, then invokes a second CLI call as a judge to score the output
against tests/judge-rubric.md. Writes a report to tests/reports/<timestamp>/
and exits non-zero if any hard-checklist item failed.
'

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUNDLE="$ROOT_DIR/targets/claude-code/harness-init"
FIXTURE="$ROOT_DIR/tests/fixtures/interview.json"
PROMPT_RUN="$ROOT_DIR/tests/prompts/run.md"
RUBRIC="$ROOT_DIR/tests/judge-rubric.md"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
REPORT_DIR="$ROOT_DIR/tests/reports/$STAMP"
SANDBOX=""

require_file() {
  : '
  require_file PATH

  Abort with exit 2 if PATH does not exist or is empty.
  '
  [[ -s "$1" ]] || { echo "[test-skill-local] missing or empty: $1" >&2; exit 2; }
}

require_cmd() {
  : '
  require_cmd NAME

  Abort with exit 2 if NAME is not on PATH.
  '
  command -v "$1" >/dev/null 2>&1 \
    || { echo "[test-skill-local] required command not found: $1" >&2; exit 2; }
}

cleanup() {
  [[ -n "$SANDBOX" && -d "$SANDBOX" ]] && rm -rf "$SANDBOX"
}

main() {
  require_cmd claude
  require_file "$FIXTURE"
  require_file "$PROMPT_RUN"
  require_file "$RUBRIC"
  [[ -d "$BUNDLE" ]] || { echo "[test-skill-local] bundle missing: $BUNDLE" >&2; exit 2; }

  SANDBOX="$(mktemp -d)"
  trap cleanup EXIT

  mkdir -p "$REPORT_DIR"
  mkdir -p "$SANDBOX/.claude/skills"
  cp -R "$BUNDLE" "$SANDBOX/.claude/skills/harness-init"

  echo "[test-skill-local] sandbox: $SANDBOX"
  echo "[test-skill-local] report dir: $REPORT_DIR"
  echo "[test-skill-local] scaffold OK (no model calls yet)"
}

main "$@"
```

- [ ] **Step 2: Make executable and syntax-check**

Run: `chmod +x scripts/test-skill-local.sh && bash -n scripts/test-skill-local.sh`
Expected: no output, exit 0.

- [ ] **Step 3: Dry run the scaffolding**

Run: `bash scripts/test-skill-local.sh`
Expected stdout contains `scaffold OK (no model calls yet)` and a report directory line. Exit code 0. Verify report dir exists afterward:

```bash
ls -d tests/reports/*/ | tail -1
```

Expected: one directory matching `tests/reports/<timestamp>/`.

- [ ] **Step 4: Commit**

```bash
git add scripts/test-skill-local.sh
git commit -m "$(cat <<'EOF'
feat: 로컬 평가 루프 오케스트레이터 뼈대 추가

- scripts/test-skill-local.sh가 prereq 검사, 샌드박스 생성, 번들 복사, 리포트 디렉토리 준비까지 수행하는 스캐폴드를 잡는다.
- 모델 호출 없이 먼저 구조만 검증할 수 있도록 단계화하여 다음 작업에서 Run/Judge 페이즈만 얹으면 되게 한다.
EOF
)"
```

---

## Task 7: Complete test-skill-local.sh with Run + Judge + exit gate

**Files:**

- Modify: `scripts/test-skill-local.sh`

- [ ] **Step 1: Replace the placeholder echo block inside `main()` with the Run phase, generated-tree copy, Judge phase, and exit gate.**

Replace the line `echo "[test-skill-local] scaffold OK (no model calls yet)"` and everything after it inside `main()` up to the closing brace `}` with:

```bash
  local run_prompt
  run_prompt="$(cat "$PROMPT_RUN")"$'\n\n```json\n'"$(cat "$FIXTURE")"$'\n```\n'

  echo "[test-skill-local] Run phase: invoking claude -p..."
  (
    cd "$SANDBOX"
    claude -p "$run_prompt" --permission-mode bypassPermissions
  ) > "$REPORT_DIR/run-stdout.log"

  if ! grep -q '^RUN_DONE$' "$REPORT_DIR/run-stdout.log"; then
    echo "[test-skill-local] WARNING: RUN_DONE marker not found in run stdout" >&2
  fi

  mkdir -p "$REPORT_DIR/generated"
  (
    cd "$SANDBOX"
    find . -mindepth 1 \( -path './.claude' -prune \) -o -print \
      | while IFS= read -r entry; do
          [[ "$entry" == "." ]] && continue
          [[ -d "$entry" ]] && mkdir -p "$REPORT_DIR/generated/$entry" && continue
          mkdir -p "$REPORT_DIR/generated/$(dirname "$entry")"
          cp "$entry" "$REPORT_DIR/generated/$entry"
        done
  )

  local judge_input judge_prompt
  judge_input="$(mktemp)"
  trap 'rm -f "$judge_input"; cleanup' EXIT
  {
    cat "$RUBRIC"
    echo ""
    echo "## Generated Tree"
    (
      cd "$SANDBOX"
      find . -type f -not -path './.claude/*' | sort | while IFS= read -r f; do
        echo ""
        echo "### ${f#./}"
        echo '```'
        cat "$f"
        echo '```'
      done
    )
  } > "$judge_input"

  echo "[test-skill-local] Judge phase: invoking claude -p..."
  judge_prompt="$(cat "$judge_input")"
  claude -p "$judge_prompt" --permission-mode bypassPermissions \
    > "$REPORT_DIR/report.md"

  echo "[test-skill-local] report: $REPORT_DIR/report.md"

  if grep -q '^- \[FAIL\]' "$REPORT_DIR/report.md"; then
    echo "[test-skill-local] hard-checklist FAIL detected; exiting 1" >&2
    exit 1
  fi
```

- [ ] **Step 2: Syntax check**

Run: `bash -n scripts/test-skill-local.sh`
Expected: no output, exit 0.

- [ ] **Step 3: Commit without running it yet**

The smoke run is its own task so that if something breaks we can debug separately. Do not run the full script here.

```bash
git add scripts/test-skill-local.sh
git commit -m "$(cat <<'EOF'
feat: Run/Judge 페이즈 및 exit 게이트 구현

- Run 페이즈가 tests/prompts/run.md와 tests/fixtures/interview.json을 합성해 claude -p에 stdin으로 전달한다.
- 샌드박스에서 .claude 번들을 제외한 생성 트리만 리포트 디렉토리로 보존한다.
- Judge 페이즈는 tests/judge-rubric.md 뒤에 생성 트리 덤프를 이어 붙여 또 한 번의 claude -p 호출로 리포트를 만든다.
- 리포트에 [FAIL] 체크리스트 항목이 있으면 exit 1로 종료해 개발자에게 재조정 신호를 준다.
EOF
)"
```

---

## Task 8: End-to-end smoke run and report capture

**Files:** none modified; this task produces a report artifact under `tests/reports/` (gitignored) and a single commit with an excerpt captured into the plan's own follow-up notes.

- [ ] **Step 1: Run the full loop**

Run: `bash scripts/test-skill-local.sh`

Expected: the script prints `Run phase`, `Judge phase`, and `report:` lines. Exit code 0 or 1. Either exit code is acceptable — a `[FAIL]` line just means the current `SKILL.md` needs tuning, not that the harness is broken.

- [ ] **Step 2: Locate and read the report**

Run:

```bash
LATEST="$(ls -1dt tests/reports/*/ | head -1)"
echo "$LATEST"
head -20 "$LATEST/report.md"
```

Expected: the first line of `report.md` matches `^SUMMARY: [0-9]+/8 hard checks passed; subagent-score [0-9.]+/5$`.

- [ ] **Step 3: Sanity-check the generated tree**

Run:

```bash
find "$LATEST/generated" -maxdepth 3 -type f | sort
```

Expected: includes at minimum `README.md`, `AGENTS.md`, `ARCHITECTURE.md`, and files under `docs/`.

- [ ] **Step 4: If the report contains unexpected `[FAIL]` items, iterate**

If the hard-checklist has `[FAIL]` items that are clearly the Judge's mistake (e.g., it claims a file is missing that is present in `generated/`), this is a Judge rubric issue — revise `tests/judge-rubric.md` and re-run from Step 1.

If `[FAIL]` items are legitimate (a required file is genuinely missing from the generated tree), this is a `skill/SKILL.md` issue and falls outside this plan.

- [ ] **Step 5: Commit only if anything under version control changed**

Most likely nothing under version control changed (reports are gitignored). Confirm:

```bash
git status --short
```

Expected: empty. If non-empty (e.g., you revised `tests/judge-rubric.md` in Step 4), commit those changes with a descriptive Conventional Commit message.

- [ ] **Step 6: Report to user**

Print the first 30 lines of `report.md` and the tree listing from Step 3 to the user as the smoke-run evidence.

---

## Self-Review Notes

Spec coverage:

- `scripts/test-skill-local.sh` — Tasks 6 and 7.
- `scripts/check-bundle-structure.sh` — Task 4.
- `tests/fixtures/interview.json` — Task 1.
- `tests/prompts/run.md` — Task 2.
- `tests/judge-rubric.md` — Task 3.
- `.gitignore` change — Task 1.
- `.github/workflows/ci.yml` change — Task 5.
- End-to-end smoke validation — Task 8.

Type consistency: the rubric's `SUMMARY: <n>/<total>` contract is referenced only in Task 3 and Task 8; totals match (8 hard checks, 4 subagent axes). `[FAIL]` marker is used in Task 7's exit-gate grep and Task 3's rubric constraint; consistent.

Placeholders: none — every code block is complete. The only "open" moment is Task 8 Step 4, which depends on the live run and is necessarily conditional.
