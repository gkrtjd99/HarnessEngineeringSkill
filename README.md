# harness-init

## 배경

OpenAI의 [하네스 엔지니어링](https://openai.com/ko-KR/index/harness-engineering/) 글을 읽고 만들었습니다.

에이전트한테 "이 기능 만들어줘"라고 시키면 처음엔 잘 하다가도, 세션이 바뀌거나 서브에이전트로 넘어가는 순간 맥락이 날아갑니다. 어떤 문서를 먼저 읽어야 하는지, 어떤 제약이 있는지, 완료 기준이 뭔지 — 이게 정리되어 있지 않으면 에이전트는 매번 처음부터 추측합니다.

`harness-init`는 신규 프로젝트를 AI-driven 개발에 맞게 시작하는 스킬입니다. 제품 아이디어를 문제, 사용자, MVP 범위, 인수 기준, 기술 제약, 에이전트 권한, 검증 방식까지 단계적으로 구체화한 뒤 실제 개발을 시작할 수 있는 하네스를 만듭니다.

인터뷰는 한 번에 1~3개의 질문만 진행하며, 이미 답한 내용은 반복하지 않습니다. 모호하거나 충돌하는 결정은 확인하고, 모르는 내용은 추측하지 않습니다. 기존 프로젝트에 같은 하네스를 도입하는 보조 흐름도 지원합니다.

## 동작 흐름

1. 제품의 문제, 사용자, 가치와 MVP 범위를 정의합니다.
2. P0 기능, 사용자 흐름, 인수 기준과 성공 지표를 연결합니다.
3. 기술 스택, 코드 경계, AI 에이전트 권한과 사람의 검토 지점을 정합니다.
4. 제품 정의를 자체 검토한 뒤 문서 간 모순을 해결합니다.
5. 에이전트 진입점, 아키텍처, 제품 스펙, 코드 맵, 개발 규칙과 첫 실행 계획을 생성합니다.

## 사용 모드

| 모드 | 언제 사용하나요? | 결과 |
| --- | --- | --- |
| 신규 프로젝트 | 아이디어나 빈 저장소에서 시작할 때 | 제품 정의와 AI 개발 하네스, 첫 실행 계획 |
| 기존 프로젝트 도입 | 이미 코드와 사람이 작성한 문서가 있을 때 | 기존 권위를 보존한 gap 보완 |
| 감사만 | 변경 없이 상태를 파악할 때 | 인벤토리, 문제점, 우선순위 보고 |

## 검증과 평가

생성된 신규 프로젝트에서는 스킬 번들에 포함된 검증기를 실행할 수 있습니다.

```bash
bash .claude/skills/harness-init/scripts/check-generated-harness.sh --final .
```

인터뷰 중단 후 저장된 제품 정의 초안을 검사할 때는 `--draft`를 사용합니다. 검증기는 필수 문서, P0 인수 기준, 첫 실행 계획, 링크, 템플릿 잔재를 확인합니다.

인터뷰가 끝나기 전에는 `docs/product-specs/product-definition.draft.md`가 작업 원본입니다. 최종 확인 후 `docs/product-specs/product-definition.md`로 정리하고, 에이전트는 `EP-0001`부터 구현을 시작합니다.

저장소 개발자는 로컬 평가 입력(`tests/`, Git 무시 대상)을 준비한 경우 아래 명령으로 실제 Claude CLI 평가를 실행할 수 있습니다. 완성형 신규 프로젝트, 모호한 신규 프로젝트의 초안 저장, 기존 문서 보존 도입의 세 시나리오를 실행합니다.

```bash
bash scripts/test-skill-local.sh
```

실행 전 Claude CLI에서 `/login`을 완료해야 합니다. 입력과 평가 보고서는 모두 Git 무시 대상인 `tests/` 아래에만 둡니다.

특정 시나리오만 실행할 수도 있습니다.

```bash
bash scripts/test-skill-local.sh greenfield-complete
bash scripts/test-skill-local.sh greenfield-ambiguous
bash scripts/test-skill-local.sh adoption-preserve
```

## 설치 및 사용

### Claude Code

```bash
cp -R targets/claude-code/harness-init ~/.claude/skills/harness-init
```

세션에서 아래처럼 요청합니다.

```text
harness-init로 새 프로젝트 아이디어를 구체화하고 AI-driven 개발 하네스를 만들어줘.
```

기존 프로젝트라면 다음처럼 요청할 수 있습니다.

```text
harness-init로 현재 저장소의 에이전트 작업 문서를 감사하고, 중복 없이 필요한 부분만 개선해줘.
```

### Codex

```bash
cp -R targets/codex/harness-init .codex/skills/harness-init
```

세션에서 아래처럼 요청합니다.

```text
Use harness-init to define this new project and create an AI-driven development harness.
```

기존 프로젝트 감사 요청 예시:

```text
Use harness-init to audit this repository's agent operating documents and make only evidence-based, non-duplicative improvements.
```

### OpenCode

프로젝트 로컬 설치 예시는 아래와 같습니다.

```bash
mkdir -p .opencode/skills/harness-init
cp -R targets/opencode/harness-init/* .opencode/skills/harness-init/
```

전역 스킬로 설치하려면 아래처럼 복사합니다.

```bash
mkdir -p ~/.config/opencode/skills/harness-init
cp -R targets/opencode/harness-init/* ~/.config/opencode/skills/harness-init/
```

세션에서 아래처럼 요청합니다.

```text
Use harness-init to define this new project and create an AI-driven development harness.
```

### Claude (claude.ai)

`targets/claude/harness-init/` 폴더를 ZIP으로 압축한 뒤 Claude의 커스텀 스킬 업로드 화면에 등록합니다.

### Antigravity

`targets/antigravity/harness-init/PROMPT.md` 내용을 프로젝트 프롬프트나 agent rules에 붙여 넣습니다.

## 생성 결과물

### 신규 프로젝트 기본 문서

| 파일 | 용도 |
| --- | --- |
| `README.md` | 프로젝트 개요. 사용자 언어로 작성됨 |
| `AGENTS.md` | 에이전트 진입점. 문서 읽기 순서와 저장소 맵 포함 |
| `CLAUDE.md` | Claude Code 자동 로딩용 bridge. `@AGENTS.md`만 import |
| `ARCHITECTURE.md` | 시스템 구조 설명. matklad 스타일의 디렉토리별 코드 맵 |
| `docs/product-specs/product-definition.md` | 문제, 사용자, 요구사항, 범위, 인수 기준과 성공 지표 |
| `docs/exec-plans/active/EP-0001-initial-delivery.md` | 첫 번째 검증 가능한 세로 단위 구현 계획 |
| `docs/generated/code-map.md` | 계획된 코드 영역과 공개 표면. 구현 전에는 planned로 표시 |
| `docs/references/development-rules.md` | 상세 개발 규칙과 서브에이전트 handoff 규칙 |

### 선택 문서 (프로젝트 성격에 따라 생성)

| 파일 | 생성 조건 |
| --- | --- |
| `docs/BACKEND.md` | 백엔드, API, 워커, 큐, 서비스 계층이 있을 때 |
| `docs/FRONTEND.md` | 프론트엔드 기술 스택이 있을 때 |
| `docs/INFRASTRUCTURE.md` | 배포, 호스팅, IaC, CI/CD, 런타임 설정이 있을 때 |
| `docs/SECURITY.md` | 인증/보안이 핵심 제약으로 언급될 때 |
| `docs/RELIABILITY.md` | 가용성·장애 대응이 중요한 서비스일 때 |
| `docs/generated/db-schema.md` | 데이터베이스 구조가 있을 때 |
| `docs/design-docs/core-beliefs.md` | 장기 유지할 제품·엔지니어링 원칙이 확정됐을 때 |
| `docs/module-contracts/<module>.md` | 다중 파일·장기 유지되는 기능, 패키지, 서비스, 인프라 영역, 스크립트 묶음에 명확한 소유권이 있을 때 (단일 파일·일회성 모듈은 생성하지 않음) |
| `docs/exec-plans/active/EP-xxxx.md` | 현재 진행 중인 실행 계획이 있을 때 |
| `docs/product-specs/<feature>.md` | 구체적인 기능 스펙이 있을 때 |
| `docs/DESIGN.md` | 별도로 정리할 설계 결정이 있을 때 |
| `docs/PLANS.md` | 실행 계획 전체를 한 곳에 모을 때 |
| `docs/PRODUCT_SENSE.md` | 제품 방향성과 사용자 관점 정리가 필요할 때 |
| `docs/QUALITY_SCORE.md` | 품질 지표 추적이 필요할 때 |
| `docs/references/*-llms.txt` | 프로젝트에 유지할 구체적인 명령·제약·주의사항이 있을 때 |
| `scripts/init.sh` | 빈 디렉토리 생성 이상으로 안전하고 반복 가능한 초기화 작업이 있을 때 |

## References

- OpenAI: [하네스 엔지니어링: 에이전트 우선 세계에서 Codex 활용하기](https://openai.com/ko-KR/index/harness-engineering/)
- matklad: [ARCHITECTURE.md](https://matklad.github.io/2021/02/06/ARCHITECTURE.md.html)
