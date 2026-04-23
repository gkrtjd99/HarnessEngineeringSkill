# Targets

`targets/`는 배포용 산출물 디렉토리입니다.
핵심 스킬은 `skill/`에서 관리하고, 이 디렉토리는 `bash scripts/sync-skill-targets.sh`로만 갱신합니다.

## Layout

- `claude/`: Claude 웹 업로드용 skill bundle
- `claude-code/`: Claude Code용 filesystem skill bundle
- `codex/`: Codex용 filesystem skill bundle
- `antigravity/`: Antigravity용 prompt adapter bundle

## Rule

직접 수정하지 말고 `skill/`과 `skill/runtime-guides/`를 수정한 뒤 동기화 스크립트를 다시 실행합니다.
