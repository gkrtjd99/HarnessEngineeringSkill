# Claude Code Install

이 디렉토리는 Claude Code용 개인 또는 프로젝트 skill 번들의 기준 파일입니다.

## Install

프로젝트 로컬 설치 예시는 아래와 같습니다.

```bash
mkdir -p ~/.claude/skills/harness-init
cp targets/claude-code/harness-init/SKILL.md ~/.claude/skills/harness-init/
cp -R targets/claude-code/harness-init/references ~/.claude/skills/harness-init/
cp -R targets/claude-code/harness-init/scripts ~/.claude/skills/harness-init/
```

## Notes

- Claude Code는 skill 폴더 구조를 그대로 읽도록 번들을 유지합니다.
- 이 번들은 `skill/`에서 자동 생성되므로 직접 수정하지 않습니다.
