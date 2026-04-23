# Codex Install

이 디렉토리는 Codex용 skill 번들의 기준 파일입니다.

## Install

프로젝트 로컬 설치 예시는 아래와 같습니다.

```bash
mkdir -p .codex/skills/harness-init
cp targets/codex/harness-init/SKILL.md .codex/skills/harness-init/
cp -R targets/codex/harness-init/references .codex/skills/harness-init/
cp -R targets/codex/harness-init/scripts .codex/skills/harness-init/
```

## Notes

- Codex에서는 이 번들을 project skill로 두는 것을 기본 경로로 가정합니다.
- 이 번들은 `skill/`에서 자동 생성되므로 직접 수정하지 않습니다.
