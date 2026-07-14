# Project Definition Interview

Use this reference for the new-project bootstrap workflow. Its purpose is to collect enough
product and engineering truth to generate an executable AI-development harness, not to produce
a ceremonial PRD.

## Contents

1. Interview behavior
2. Product definition sections
3. AI-development sections
4. Interview persistence
5. Definition quality gate
6. Harness mapping

## Interview Behavior

- Ask one to three related questions per turn.
- Start each turn with `[Progress: n/14 sections confirmed]`, translated to the user's language.
- Prefer short A/B/C choices when they clarify a real tradeoff. Include `Not sure yet`.
- When the user is unsure, give two or three relevant examples, explain the tradeoff, and ask
  again. Do not silently choose.
- Explain an acronym or specialist term the first time it appears.
- After each section, summarize the confirmed answer in one or two lines and ask whether the
  understanding is correct.
- Mark each statement as one of: `Confirmed`, `Proposed`, or `Open`.
- Point out contradictions immediately and resolve consequential ones before continuing.
- Skip questions already answered by the user's brief or earlier answers.

### Opening Turn

Start with a short explanation that this interview will turn the idea into an AI-agent-ready
project rather than only a PRD. Then ask the first one to three identity questions. For example:

```markdown
[Progress: 0/14 sections confirmed]

먼저 제품의 출발점을 잡겠습니다.

1. 프로젝트의 작업 이름은 무엇인가요?
2. “어떤 사용자가 어떤 결과를 얻도록 돕는 제품”인지 한 문장으로 설명하면 무엇인가요?

A. 바로 설명할 수 있어요.
B. 아이디어는 있지만 한 문장으로 정리가 어려워요.
C. 비슷한 제품 예시를 먼저 보고 싶어요.
D. 아직 잘 모르겠어요.
```

Adapt the wording and choices to context; do not repeat this example mechanically.

## Interview Persistence

After the user confirms a section, create or update
`docs/product-specs/product-definition.draft.md`. Use the draft template in
`references/templates.md` and keep it concise enough to read at the start of the next session.

- Record the confirmed section number, a dated progress marker, confirmed decisions, proposed
  defaults, and open questions.
- Write only user-confirmed statements under `Confirmed Decisions`; do not promote a proposal
  because the session ends.
- Add the next consequential question under `Next Questions` so a new agent can continue without
  reconstructing chat history.
- Run `scripts/check-generated-harness.sh --draft <target-directory>` when available after each
  draft update; fix structural omissions before asking the next question.
- On a later invocation, read the draft first, summarize its recovered state, and continue from
  the first unresolved section. Do not replay confirmed questions.
- After the definition quality gate passes, transfer the content to
  `docs/product-specs/product-definition.md`. Remove the draft only after that final document
  includes the confirmed decisions and still-relevant open questions.
- Run `scripts/check-generated-harness.sh --final <target-directory>` after final generation.
- Keep the draft when the user deliberately pauses, accepts open risks, or asks another agent to
  continue the interview.

## Product Definition Sections

### 1. Project Identity

Establish the working name and a one-line definition in the form “a product that helps [user]
achieve [outcome].” Ask what kind of product it is and where it will be used.

Exit when the user, outcome, and product category are distinguishable.

### 2. Problem and Current Alternative

Ask who experiences what problem, in which situation, and with what consequence. Ask how they
solve it today and why the current alternative is insufficient.

Exit when `who + context + pain + current alternative` are concrete.

### 3. Target Users

Identify the primary user, secondary users, technical comfort, frequency of use, environment,
and purchaser or administrator when different from the user.

Exit when the first release can optimize for one primary user rather than “everyone.”

### 4. Value Proposition and Solution

Ask how the product changes the user's situation, why it is meaningfully better than the current
alternative, and what evidence would make the user trust it.

Exit when the solution explains an outcome rather than merely listing features.

### 5. MVP Capabilities and Priority

Identify three to five must-have capabilities. Assign P0, P1, or P2 priority, where P0 means the
first release fails without it. Ask why each P0 capability is necessary.

For every P0 item, collect at least one observable acceptance criterion using Given/When/Then or
an equally testable form.

Exit when the P0 set is small enough for the first milestone and every P0 item traces to the
problem.

### 6. User Journeys

Walk through at least one happy path and the most important failure or recovery path. Capture the
trigger, steps, expected outcome, and failure feedback. Add more journeys only when another actor
or materially different workflow changes the architecture.

Exit when an implementer can identify the first vertical slice.

### 7. Scope Boundaries

Confirm in-scope and explicitly out-of-scope behavior for the first release. Ask which tempting
features should be deferred and what would cause scope to expand.

Exit when likely scope creep has named boundaries.

### 8. Success Signals

Ask which user behavior or operational result would show that the product works. Prefer a metric
with a value, unit, population, and time window. For prototypes, allow a qualitative learning goal
with a clear evaluation method.

Exit when success can be observed rather than described as “good,” “easy,” or “fast.”

### 9. Non-Functional Requirements

Ask only relevant questions about latency, scale, availability, privacy, security, accessibility,
localization, data retention, compliance, cost, and supported devices. Turn important adjectives
into measurable constraints or explicitly mark them open.

Exit when constraints that affect architecture or acceptance are known.

## AI-Development Sections

### 10. Stack and Architecture Constraints

Ask about required platforms, languages, frameworks, storage, hosting, external APIs, deployment
environment, and prohibited choices. Distinguish hard constraints from preferences. When the user
has no preference, propose a minimal stack with rationale and ask for confirmation.

Exit when the first milestone has a coherent proposed or confirmed technical path.

### 11. Agent Operating Model

Identify the human team size and responsibilities, which AI agents or tools will work on the
project, whether they may edit files, run tests, install dependencies, use the network, delegate,
commit, or deploy, and which actions require human confirmation. Ask about expected human review
points and ownership when multiple people or agents collaborate.

Exit when autonomy boundaries and escalation points are explicit.

### 12. Repository Boundaries and Context

Define the planned top-level code areas, ownership boundaries, dependency direction, generated
artifacts, reference documents, and sources of truth. Ask which modules are likely to be durable
enough to justify explicit contracts.

Exit when agents can know where new behavior belongs and which documents override derived maps.

### 13. Verification and Handoff

Define done-when criteria, expected test levels, lint/type/build checks, manual checks, quality
budgets, and what a handoff must report. If commands do not exist yet, define the desired checks
without inventing command names and mark command wiring as part of the first plan.

Exit when an agent can prove completion rather than merely report that code was written.

### 14. First Milestone, Dependencies, and Risks

Choose the smallest end-to-end deliverable that validates a P0 user outcome. Identify dependencies,
assumptions, highest-impact risks, mitigations, target timing if meaningful, and explicit non-goals.

Exit when the milestone can become `EP-0001` with ordered tasks and an independently verifiable
result.

## Definition Quality Gate

Review the confirmed definition before generating files. Resolve or explicitly surface failures:

| Check | Pass condition |
| --- | --- |
| Problem clarity | Primary user, context, pain, and current alternative are present |
| Traceability | Every P0 capability maps to the problem and a user journey |
| Testability | Every P0 capability has an observable acceptance criterion |
| Scope | First-release in-scope and out-of-scope are explicit |
| Success | A measurable signal or explicit prototype learning goal exists |
| Constraints | Architecture-changing product and non-functional constraints are known |
| Feasibility | Stack decisions distinguish confirmed constraints from proposals |
| Agent safety | Autonomy, human checkpoints, and escalation boundaries are explicit |
| Verification | Completion evidence and desired checks are defined |
| Executability | The first milestone is a vertical slice with clear done-when criteria |
| Consistency | Product, architecture, scope, and schedule statements do not conflict |
| Unknowns | Remaining open questions are visible and non-blocking for the first milestone |

Ask follow-up questions for the three highest-impact failures. Repeat until critical checks pass or
the user explicitly accepts the listed open risks.

## Harness Mapping

Map confirmed definition sections into generated files:

| Definition | Primary destination |
| --- | --- |
| Identity, value, setup status | `README.md` |
| Read order, agent model, done-when summary | `AGENTS.md` |
| Claude Code instruction loading | `CLAUDE.md` |
| Stack, boundaries, dependency direction, invariants | `ARCHITECTURE.md` |
| Problem, users, journeys, requirements, scope, metrics | `docs/product-specs/product-definition.md` |
| First milestone, tasks, risks, verification | `docs/exec-plans/active/EP-0001-initial-delivery.md` |
| Change rules, checks, handoff expectations | `docs/references/development-rules.md` |
| Planned source areas and reusable surfaces | `docs/generated/code-map.md` |

Do not duplicate full sections across files. Put the authoritative detail in the primary destination
and link to it from navigation documents.
