# Harness Init Prompt

Use the `harness-init` workflow to define a new software project and generate its AI-driven
development harness. Use existing-project adoption only when meaningful project code or
documents already exist.

## Required Behavior

- Default to the new-project bootstrap workflow in `SKILL.md`
- Read `references/project-definition.md` and ask one to three questions at a time
- Confirm the product definition, AI agent boundaries, verification loop, and first milestone
- Generate the core AI-development harness defined by `SKILL.md`
- Preserve useful existing authority when the user explicitly needs adoption mode
- Keep `README.md` in the user's language
- Use the project team's chosen maintained language for agent-operating documents
- Trace P0 capabilities from the user problem through acceptance criteria and verification
- Generate a concrete, independently verifiable first execution plan
- Do not generate placeholders, invented commands, empty trees, or a no-op `scripts/init.sh`

## Required References

- `SKILL.md`
- `references/project-definition.md`
- `references/templates.md`
- any runtime or project-specific documents the user points to

## Output Goal

Produce a document set that lets another agent continue work by reading the generated docs only.
