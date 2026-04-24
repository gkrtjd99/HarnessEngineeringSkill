# harness-init

에이전트에게 기능 개발을 시키기 전에 먼저 문서 구조와 운영 규칙부터 잡아야 합니다.
`harness-init`는 그 첫 단계를 자동화하는 스킬입니다.
프로젝트 인터뷰에 답하면 에이전트가 바로 이어받을 수 있는 문서 세트를 생성합니다.

## 생성 결과물

```text
README.md
AGENTS.md
ARCHITECTURE.md
docs/design-docs/index.md
docs/design-docs/core-beliefs.md
docs/exec-plans/tech-debt-tracker.md
docs/product-specs/index.md
docs/references/*-llms.txt
scripts/init.sh
```

프로젝트 성격에 따라 `docs/exec-plans/active/`, `docs/product-specs/<feature>.md` 등이 추가로 생성될 수 있습니다.

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

## References

- OpenAI: [하네스 엔지니어링: 에이전트 우선 세계에서 Codex 활용하기](https://openai.com/ko-KR/index/harness-engineering/)
- matklad: [ARCHITECTURE.md](https://matklad.github.io/2021/02/06/ARCHITECTURE.md.html)
