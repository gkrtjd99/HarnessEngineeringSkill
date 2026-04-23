# Antigravity Install

이 디렉토리는 Antigravity용 adapter prompt 번들의 기준 파일입니다.

## Install

1. `targets/antigravity/harness-init/PROMPT.md`를 엽니다.
2. Antigravity의 프로젝트 프롬프트, agent rules, 또는 공통 instruction 입력 위치에 붙여 넣습니다.
3. 필요하면 같은 디렉토리의 `references/`와 `scripts/`를 프로젝트 문맥 파일로 함께 복사합니다.

## Notes

- Antigravity 번들은 filesystem skill 자동 검색 대신 prompt adapter를 기본 방식으로 사용합니다.
- 이 번들은 `skill/`에서 자동 생성되므로 직접 수정하지 않습니다.
