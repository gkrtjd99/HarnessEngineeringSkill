# Harness Init Skill Kit

Harness Init Skill Kit은 하네스 엔지니어링용 문서 생성 스킬을 한 곳에서 관리하고, 여러 에이전트 툴에 맞는 번들로 배포하기 위한 저장소입니다.
이 레포는 `skill/`을 단일 진실 공급원으로 유지합니다.

## Why This Repository

같은 스킬을 여러 런타임에 붙일 때 가장 자주 깨지는 부분은 지시문 drift입니다.
이 저장소는 핵심 스킬은 한 번만 작성하고, `targets/` 번들은 동기화 스크립트로만 갱신하도록 해서 툴별 배포 결과를 일관되게 유지합니다.

## References

이 저장소의 구조와 생성 규칙은 아래 문서를 참고합니다.

- OpenAI: [하네스 엔지니어링: 에이전트 우선 세계에서 Codex 활용하기](https://openai.com/ko-KR/index/harness-engineering/)
- matklad: [ARCHITECTURE.md](https://matklad.github.io/2021/02/06/ARCHITECTURE.md.html)

## Repository Structure

```text
.
├── README.md
├── AGENTS.md
├── ARCHITECTURE.md
├── docs/
├── scripts/
├── skill/
├── starter-kit/
└── targets/
```

각 디렉토리의 역할은 아래와 같습니다.

- `skill/`: canonical `harness-init` skill source
- `targets/`: Claude, Claude Code, Codex, Antigravity용 배포 번들
- `scripts/`: target bundle 동기화 자동화
- `starter-kit/`: 생성 결과의 정적 기준 예시

## Workflow

이 저장소의 기본 흐름은 아래 3단계입니다.

1. `skill/`에서 핵심 스킬을 수정합니다.
2. `bash scripts/sync-skill-targets.sh`로 각 런타임 번들을 갱신합니다.
3. 원하는 툴에 맞는 `targets/<tool>/harness-init/` 번들을 설치합니다.

## Tool Targets

### Claude

Claude 웹 앱에서는 `targets/claude/harness-init/` 디렉토리를 ZIP으로 묶어 custom skill로 업로드하면 됩니다.

### Claude Code

```bash
mkdir -p ~/.claude/skills/harness-init
cp targets/claude-code/harness-init/SKILL.md ~/.claude/skills/harness-init/
cp -R targets/claude-code/harness-init/references ~/.claude/skills/harness-init/
cp -R targets/claude-code/harness-init/scripts ~/.claude/skills/harness-init/
```

### Codex

```bash
mkdir -p .codex/skills/harness-init
cp targets/codex/harness-init/SKILL.md .codex/skills/harness-init/
cp -R targets/codex/harness-init/references .codex/skills/harness-init/
cp -R targets/codex/harness-init/scripts .codex/skills/harness-init/
```

### Antigravity

Antigravity는 `targets/antigravity/harness-init/PROMPT.md`를 프로젝트 프롬프트 또는 agent rules에 붙여 넣는 방식으로 사용합니다.
같은 디렉토리의 `INSTALL.md`에는 추천 사용 방식과 가져갈 파일 범위를 정리해 두었습니다.

## Sync

`targets/`는 직접 수정하지 않는 것이 원칙입니다.
핵심 스킬을 수정한 뒤에는 반드시 아래 명령으로 번들을 다시 생성해야 합니다.

```bash
bash scripts/sync-skill-targets.sh
```

동기화 후에는 아래 검사를 권장합니다.

```bash
bash starter-kit/scripts/lint-architecture.sh docs/design-docs
bash starter-kit/scripts/check-doc-links.sh .
bash -n scripts/sync-skill-targets.sh
bash -n skill/scripts/scan-project.sh
```

## What The Skill Generates

`harness-init` 스킬은 프로젝트 인터뷰 결과를 바탕으로 아래 문서 집합을 생성하도록 설계되어 있습니다.

- `README.md`
- `AGENTS.md`
- `ARCHITECTURE.md`
- `docs/design-docs/index.md`
- `docs/design-docs/core-beliefs.md`
- `docs/exec-plans/tech-debt-tracker.md`
- `docs/product-specs/index.md`
- `docs/references/*-llms.txt`
- `scripts/init.sh`

## Repository Map

- `AGENTS.md`: 이 저장소 자체를 위한 에이전트 진입점
- `ARCHITECTURE.md`: 이 저장소 자체의 구조 설명
- `docs/design-docs/`: 설계 상세와 근거 문서
- `docs/references/harness-engineering.md`: 핵심 원칙 참조
- `skill/`: `harness-init`의 canonical source
- `targets/`: 런타임별 배포 번들
- `starter-kit/`: 생성 결과의 정적 기준 예시

## CI

루트 GitHub Actions는 push 및 pull request마다 아래 검증을 실행합니다.

- 루트 `docs/`와 `starter-kit/docs/`의 Markdown 및 아키텍처 문서 검사
- `starter-kit/scripts/`, `skill/scripts/`, `scripts/`의 셸 문법 검사
- `bash scripts/sync-skill-targets.sh` 실행
- 동기화 후 worktree가 깨끗한지 검사
