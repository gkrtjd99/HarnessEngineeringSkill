You are a freshly dispatched subagent with no prior context. You have been asked to continue development work on the project described by the documents below. Your job right now is not to do the work, but to evaluate whether these documents give you enough structure to begin.

Emit a report in Markdown. The very first line MUST be a summary line of exactly the form:

```
SUMMARY: <n>/<total> hard checks passed; subagent-score <average>/5
```

Where `<n>` is the count of `[PASS]` items, `<total>` is 8, and `<average>` is the arithmetic mean of the four subagent-delegation scores rounded to one decimal.

Then produce the two sections below.

## Hard Checklist

For each item, emit exactly one line starting with `- [PASS]` or `- [FAIL]`, followed by a space and a one-sentence justification. Use `[PASS]` / `[FAIL]` markers in this section ONLY; never use them anywhere else in the report.

Items to evaluate (in this order):

1. Root `README.md`, `AGENTS.md`, and `ARCHITECTURE.md` all exist in the generated tree and are non-empty.
2. `AGENTS.md` contains both an explicit read order and a repository map.
3. `ARCHITECTURE.md` follows matklad's system-map style, with sections for high-level overview, code map by directory, and cross-cutting concerns.
4. All four harness core docs exist: `docs/design-docs/index.md`, `docs/design-docs/core-beliefs.md`, `docs/exec-plans/tech-debt-tracker.md`, `docs/product-specs/index.md`.
5. At least one file matching `docs/references/*-llms.txt` exists and is non-empty.
6. `scripts/init.sh` exists.
7. The `doneWhen` / acceptance criteria supplied in the interview answers is reflected both in `AGENTS.md` and in at least one document under `docs/product-specs/` or `docs/exec-plans/active/`.
8. Cross-document Markdown links inside the generated tree use relative paths and every such link resolves to a file that exists in the tree.

## Subagent-Delegation Rubric

For each of the four axes below, assign an integer score from 1 to 5 and write one paragraph of justification. Do NOT use `[PASS]` or `[FAIL]` markers in this section.

- Onboarding clarity: could a subagent pick up work using only these docs?
- Boundary isolation: are modules and responsibilities distinct enough to split work across subagents?
- Decision traceability: are constraints and rationale captured in design docs rather than scattered or missing?
- Actionability: is there a clear first next step a subagent could take, evidenced by the tech-debt tracker or exec-plans content?

---

The generated document tree to evaluate follows below. Read all of it before emitting the report.
