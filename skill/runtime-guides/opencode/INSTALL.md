# OpenCode Install

이 디렉토리는 OpenCode용 project 또는 global skill 번들의 기준 파일입니다.

## Install

프로젝트 로컬 설치 예시는 아래와 같습니다.

```bash
mkdir -p .opencode/skills/harness-init
cp targets/opencode/harness-init/SKILL.md .opencode/skills/harness-init/
cp -R targets/opencode/harness-init/references .opencode/skills/harness-init/
cp -R targets/opencode/harness-init/scripts .opencode/skills/harness-init/
```

전역 스킬로 설치하려면 아래처럼 복사합니다.

```bash
mkdir -p ~/.config/opencode/skills/harness-init
cp targets/opencode/harness-init/SKILL.md ~/.config/opencode/skills/harness-init/
cp -R targets/opencode/harness-init/references ~/.config/opencode/skills/harness-init/
cp -R targets/opencode/harness-init/scripts ~/.config/opencode/skills/harness-init/
```

## Notes

- OpenCode는 `SKILL.md`가 있는 skill 폴더 구조를 그대로 읽도록 번들을 유지합니다.
- 이 번들은 `skill/`에서 자동 생성되므로 직접 수정하지 않습니다.
