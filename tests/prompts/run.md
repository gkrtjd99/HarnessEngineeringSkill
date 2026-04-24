You are operating inside an empty sandbox project directory. The `harness-init` skill is installed at `.claude/skills/harness-init/`.

Your task:

1. Load the `harness-init` skill from `.claude/skills/harness-init/SKILL.md`.
2. Treat the JSON object appended at the end of this prompt as the user's answers to the ten interview questions defined in the skill. The JSON keys map 1:1 to the question subjects in `SKILL.md` (`projectName`, `projectDescription`, `techStack`, `teamSize`, `agentsInUse`, `primaryWorkflows`, `coreConstraints`, `referenceTools`, `doneWhen`, `projectContext`).
3. Execute every generation rule in `SKILL.md` using those answers.
4. Write all generated files into the current working directory.
5. Do not ask clarifying questions. Do not pause for confirmation. Do not modify files under `.claude/`.

When finished, emit exactly one line to stdout: `RUN_DONE`.

Interview answers (JSON):
