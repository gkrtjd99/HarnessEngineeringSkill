# harness-init

## 배경

OpenAI의 [하네스 엔지니어링](https://openai.com/ko-KR/index/harness-engineering/) 글을 읽고 만들었습니다.

에이전트한테 "이 기능 만들어줘"라고 시키면 처음엔 잘 하다가도, 세션이 바뀌거나 서브에이전트로 넘어가는 순간 맥락이 날아갑니다. 어떤 문서를 먼저 읽어야 하는지, 어떤 제약이 있는지, 완료 기준이 뭔지 — 이게 정리되어 있지 않으면 에이전트는 매번 처음부터 추측합니다.

`harness-init`는 코드를 짜기 전에 이 구조를 먼저 잡아주는 스킬입니다. 프로젝트에 대한 질문에 답하면, 에이전트가 맥락 없이도 바로 이어받을 수 있는 문서 세트를 생성합니다.

## 설치 및 사용

### Claude Code

```bash
cp -R targets/claude-code/harness-init ~/.claude/skills/harness-init
```

세션에서 아래처럼 요청합니다.

```text
harness-init 스킬로 프로젝트 문서 구조를 초기화해줘.
```

### Codex

```bash
cp -R targets/codex/harness-init .codex/skills/harness-init
```

세션에서 아래처럼 요청합니다.

```text
Use the harness-init skill to scaffold the project operating documents.
```

### Claude (claude.ai)

`targets/claude/harness-init/` 폴더를 ZIP으로 압축한 뒤 Claude의 커스텀 스킬 업로드 화면에 등록합니다.

### Antigravity

`targets/antigravity/harness-init/PROMPT.md` 내용을 프로젝트 프롬프트나 agent rules에 붙여 넣습니다.

## 생성 결과물

### 기본 문서 (항상 생성)

| 파일 | 용도 |
| --- | --- |
| `README.md` | 프로젝트 개요. 사용자 언어로 작성됨 |
| `AGENTS.md` | 에이전트 진입점. 문서 읽기 순서와 저장소 맵 포함 |
| `ARCHITECTURE.md` | 시스템 구조 설명. matklad 스타일의 디렉토리별 코드 맵 |
| `docs/design-docs/index.md` | 설계 결정 목록과 색인 |
| `docs/design-docs/core-beliefs.md` | 프로젝트의 핵심 원칙과 제약 |
| `docs/exec-plans/tech-debt-tracker.md` | 기술 부채 추적 |
| `docs/product-specs/index.md` | 제품 스펙 목록 |
| `docs/references/*-llms.txt` | 사용 기술 스택의 LLM 참조 문서 |
| `scripts/init.sh` | 클론 후 빈 폴더 구조를 복원하는 스크립트 |

### 선택 문서 (프로젝트 성격에 따라 생성)

| 파일 | 생성 조건 |
| --- | --- |
| `docs/FRONTEND.md` | 프론트엔드 기술 스택이 있을 때 |
| `docs/SECURITY.md` | 인증/보안이 핵심 제약으로 언급될 때 |
| `docs/RELIABILITY.md` | 가용성·장애 대응이 중요한 서비스일 때 |
| `docs/generated/db-schema.md` | 데이터베이스 구조가 있을 때 |
| `docs/exec-plans/active/EP-xxxx.md` | 현재 진행 중인 실행 계획이 있을 때 |
| `docs/product-specs/<feature>.md` | 구체적인 기능 스펙이 있을 때 |
| `docs/DESIGN.md` | 별도로 정리할 설계 결정이 있을 때 |
| `docs/PLANS.md` | 실행 계획 전체를 한 곳에 모을 때 |
| `docs/PRODUCT_SENSE.md` | 제품 방향성과 사용자 관점 정리가 필요할 때 |
| `docs/QUALITY_SCORE.md` | 품질 지표 추적이 필요할 때 |

## References

- OpenAI: [하네스 엔지니어링: 에이전트 우선 세계에서 Codex 활용하기](https://openai.com/ko-KR/index/harness-engineering/)
- matklad: [ARCHITECTURE.md](https://matklad.github.io/2021/02/06/ARCHITECTURE.md.html)
