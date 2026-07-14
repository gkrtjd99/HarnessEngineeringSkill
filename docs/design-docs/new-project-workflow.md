# New Project Workflow

## Context

A fixed repository-setup questionnaire can collect tool names and folder preferences without
defining what the product must achieve. That produces documents that look complete while leaving
agents to guess user problems, MVP scope, acceptance criteria, autonomy boundaries, and proof of
completion.

Existing-project adoption is useful, but making audit behavior the default obscures the primary
value of `harness-init`: establishing a greenfield project for AI-driven development before code
and conventions begin to drift.

## Decision

Make new-project bootstrap the default workflow. Guide the user through product, engineering,
agent-operating, and verification decisions in small question groups. Require traceability from
the user problem to P0 capabilities, acceptance criteria, and verification evidence.

Generate a compact initial harness whose required documents include a Claude Code bridge, product
definition, and an independently verifiable first execution plan. Keep `AGENTS.md` as the
canonical cross-runtime entry point and make `CLAUDE.md` import it instead of duplicating rules.
Treat code paths as planned until implementation creates them. Generate optional domain documents
only when the definition provides durable content.

Keep existing-project adoption as a secondary workflow that inventories and preserves current
authority before filling gaps.

## Interview Design

The detailed interview lives in `skill/references/project-definition.md` so `SKILL.md` can retain
the high-level operating sequence. The interview asks one to three related questions per turn,
supports uncertainty with examples, confirms each section, and checks cross-section consistency
before generation.

After each confirmed section, the workflow persists a compact product-definition draft containing
progress, confirmed decisions, proposed defaults, open questions, and next questions. A later
agent resumes from that draft instead of reconstructing the conversation. The final definition
replaces the draft only after the quality gate passes.

## Verification and Evaluation

The runtime bundle includes a deterministic generated-harness checker. It validates final
documents or an in-progress draft for required structure, P0 traceability, first-plan completion
evidence, broken internal links, and remaining template markers.

The repository keeps a local Claude CLI evaluation runner with three isolated scenarios: complete
greenfield generation, ambiguous greenfield interview persistence, and existing-project adoption
that preserves human-authored authority. A Claude judge reviews the raw result after deterministic
checks. These evaluations are intentionally local because they require a configured model account.

## Tradeoffs

The definition phase takes longer than collecting stack metadata. It reduces later rework by
making product scope, agent permissions, and completion evidence explicit before implementation.

A product definition can still become stale. The generated harness therefore assigns authority to
specific documents and requires plans, architecture, and code maps to stay consistent with them.

## Success Criteria

A newly started agent can identify the first user outcome, locate authoritative context, work
within explicit permissions and module boundaries, and prove the first plan's done-when criteria
without inventing missing requirements.
