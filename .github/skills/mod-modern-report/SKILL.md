---
name: mod-modern-report
description: "Any time. Explains the migration to the new system in detail, with Mermaid diagrams: what the new system is for, its target, the plan of execution, the progress made, how old and new run side by side, what's pending and what to do next. Before anything is planned it suggests a plan from the legacy layers, and it always names the information that's still missing. With no argument it writes the whole picture to docs/modern-report.md; a topic, a component, a wave, a flow or a question is answered in chat. Reads docs/ and checks it against modern/."
argument-hint: "nothing = full report · summary · target · plan · progress · coexistence · pending · risks · <component> · wave <n> · flow \"<process>\" · \"<question>\""
disable-model-invocation: true
---

# /mod-modern-report — Explain the migration and its progress

**Requires agent: `Guide`.** Under another agent, stop and ask the developer to switch.

Explain where the migration stands to a developer or a stakeholder, from what `docs/`
records. Never ask the developer anything, never call a Scout and never read `legacy/`.
Look at `modern/` only to check the records (below).

If `docs/system.md § Components` is empty, say "The legacy system isn't discovered yet: run
`/mod-discover` first; the plan builds on it" and stop.

## What to report

Values in `<ANGLE BRACKETS>` come from the text after the command. Plain words map to the
closest row ("what's next" → `pending`, "briefly" → `summary`). Text that is neither a topic
nor a component name is a question.

| Argument | What you give | Where |
|---|---|---|
| nothing or `all` | Sections 1–9 | `docs/modern-report.md`, then the chat summary |
| `summary` | Section 1 and the next steps, about one screen | chat |
| `target` | Sections 2–3 | chat |
| `plan` | Section 4 | chat |
| `progress` | Section 5 | chat |
| `coexistence` | Section 6 | chat |
| `pending` | Section 7, every row | chat |
| `risks` | Section 8 | chat |
| `<component>` | The component view (below); a legacy or a modern name | chat |
| `wave <n>` | That wave: its components with status and readiness, the migration map of the wave, what's left and its "done when" | chat |
| `flow "<process>"` | The flow (below) | chat |
| `"<question>"` | The answer with its evidence, a diagram if it helps, and the sections that hold more | chat |

A chat answer ends with the next step it affects and the information it lacked (at most 3).

## Read

- `docs/modern.md`, `docs/target.md`, `docs/skeleton.md`, `docs/system.md`, and the OPEN
  rows of `docs/questions.md`.
- The deep-dive plans in `docs/deepdive/` (their Status columns) for the components in
  scope.
- The component files a section needs (search across `docs/components/` for the rows you
  need when there are more than about 15). Their § In the modern solution says what's
  ported, how other components use it, and what it still waits for.
- [diagrams.md](diagrams.md) and the rules in
  [../mod-legacy-report/diagrams.md](../mod-legacy-report/diagrams.md#rules-for-every-diagram)
  before you draw.

**Check against `modern/`** with file searches only (project files, test projects, the paths
named in § Progress), never deep reading and never running anything:
- a modern part in § Progress that isn't in `modern/`;
- code in `modern/` that no row of § Progress names;
- built or live without evidence.

Each mismatch is a pending row: "tell the Guide to correct § Progress".

## Rules

- **Records first.** Every fact comes from `docs/` (or the check above) and keeps its
  evidence. Never mark progress the records don't show.
- **Decided or suggested.** What `modern.md` and an ACCEPTED `target.md` hold is decided;
  a DRAFT target is shown as a draft. Anything you propose (a
  plan, a next step, a target option) is marked **SUGGESTED** and is never written into
  `modern.md`. The developer adopts it by telling the Guide ("use the suggested plan").
- **Rests on a question:** a statement that depends on an OPEN question ends with
  `(rests on Q-###)`.
- **Explain, then show.** Each section opens with 2–4 plain sentences on what it means, then
  the table or diagram, then what to notice in it.
- **Progress numbers:** count components, not effort. Done means built or live. Leave kept
  components out of the total and say how many there are.
- **Big systems:** no table over about 40 rows. Show counts, the top items and a link.

## Derived facts

- **Ready:** a component that isn't started is ready when everything it depends on (in
  `system.md § Dependencies`) is built, live or kept, or is reached through an adapter
  recorded in § Plan.
- **Blocked:** not ready, or one of its H-risk questions is OPEN. Say by what.
- **Next steps,** first match wins:
  1. no accepted target or solution → `/mod-target <your stack>`, or accept the draft;
  2. `docs/skeleton.md` not BUILT → Scaffolder: `/mod-modern-skeleton`;
  3. no plan → agree a plan (the suggested one, or your own);
  4. components that are building → finish them;
  5. ready components of the current wave (the lowest wave not done), lowest layer first:
     with no deep-dive plan → `/mod-deepdive <component>`; with a port plan → Scaffolder:
     `/mod-implement-port <component>`; with a flow plan → its next build step for the
     Scaffolder;
  6. the next wave's foundation work, then its ready components.

## The full report

`docs/modern-report.md` is generated: write it whole in one edit at the end of the run,
replacing the previous one. It starts with:

```markdown
# <system name, or "The new system"> — migration report

**Generated:** YYYY-MM-DD by `/mod-modern-report` from `docs/`, checked against `modern/`. Regenerate it any time; don't edit it by hand.
```

1. **At a glance:** 4–6 plain bullets: what is being replaced and with what, where the work
   stands, the current wave, the next step and the biggest risk. Then the progress line:
   `▓▓▓▓░░░░░░ 4 of 10 components done (40%) · building 1 · kept 1`, the status pie, and
   the last 5 updates from § Progress.
2. **What the new system is for:** what the legacy system does (from `system.md § Architecture
   in brief`), what the new one replaces and keeps, and why (from the decisions).
3. **Target:** the stack by layer from `target.md` (and its status), the verdict and
   complexity counts, the capability gaps, the other decisions, the areas still undecided,
   and the target architecture diagram.
4. **Plan of execution:**
   - the waves table with a progress bar per wave, "why now" and "done when"; the gantt when
     the waves have dates;
   - the migration map;
   - no plan recorded → a **SUGGESTED** plan (below) and the decisions it needs.
5. **Progress made:** one row per component: status · modern part · evidence · ready or
   blocked by what; plan steps done of total when it has a deep-dive plan; built and live
   first. Then the mismatches with `modern/`.
6. **Coexistence:** what still runs on legacy, the bridges between old and new (a shared
   database written by both, adapters, facades) and the coexistence diagram for the 1–2
   flows most affected.
7. **Pending and next:**
   - the next 3–5 steps in order (§ Derived facts), each with who does it and its command or
     what to tell the Guide;
   - what's left, by wave;
   - blockers, including port steps left `partial` and the questions they rest on;
   - missing information (below).
8. **Risks:** shared writes while old and new coexist, cycles not yet planned, legacy that
   stays live on out-of-support technology, modern parts without tests, decisions resting on
   H-risk questions. Each with why it matters and its evidence.
9. **Sources:** links to `modern.md`, `system.md`, the component files and `questions.md`.

**Chat summary** after writing (at most 15 lines): the link to the file, the progress line,
the current wave, the next 3 steps, the top 3 risks, and "Open it in Markdown preview
(Ctrl+Shift+V) to see the diagrams".

## Suggested plan

Only when § Plan is empty. Built from `system.md § Layers`, § Cycles and § Hotspots:
- Wave 0: the foundation: the new solution, its pipeline, shared concerns, and adapters to
  the legacy resources the first waves need;
- then leaf first: lower layers before the components that depend on them, 3–6 components
  per wave;
- the members of a cycle move in the same wave;
- a Port component can move early; a Rewrite or Split one needs its logic specified
  first, so give it room in its wave (the approach from `system.md § Components`);
- a resource written by several components needs its side-by-side approach decided before
  its first writer moves.

Give each wave its components, why now, and a suggested "done when".

## Component view

For `<component>` (a legacy component, or a modern part named in § Progress):
- what it does (from its component file), what replaces it, and how other components use
  it (§ In the modern solution);
- its suggested approach, and its verdict and complexity in `target.md § 6`;
- its status, evidence and wave, and whether it's ready or blocked, and by what;
- its deep-dive plan, the steps done of total, and the next steps on its accepted road map;
- the neighbourhood diagram, coloured by status;
- the decisions that affect it, how it runs side by side with legacy, and its open questions;
- its next step.

## Flow

For `flow "<process>"`, a business or data flow in plain words: find the components and
resources involved in the records, then draw the coexistence diagram for it: which steps
already run on the new system, which still run on legacy, and where they meet. The flow is
inferred: say so once above the diagram. Nothing matches → say so and list the 3 closest
components.

## Missing information

The information that would make the plan and this report better, from the records only. One
row per item: what's missing · why it helps · what to tell the Guide.

| Check | Example of what to tell the Guide |
|---|---|
| No accepted target, or layers `undecided` in it | run `/mod-target`, or answer its questions |
| Components without a suggested approach | run `/mod-discover-comp <component>` |
| Components in the current wave without a deep-dive plan | run `/mod-deepdive <component>` |
| Suggested approaches not decided yet | "orders-core: port, as suggested" |
| Legacy components in no wave, or with no modern part | "orders-winforms goes in wave 2, as `modern/src/Orders.Web`" |
| Waves without "side by side" or "done when" | "Wave 1 is done when the new pricing API serves the web app in test" |
| Built or live without evidence | "orders-core tests passed today, 42 of 42" |
| Components that may stay legacy | "keep the vendor DLL wrapper as it is, because…" |
| Dates, for a timeline | "wave 1 runs January to March 2027" |
| OPEN H-risk questions on the next wave's components | answer them to the Guide in chat |
