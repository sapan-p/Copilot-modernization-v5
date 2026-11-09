---
name: mod-deepdive
description: "Migration planning for one component, once /mod-target is accepted. Copilot reasons over its execution flows and maps every file from the start file down to the leaf files, shows you the map, and asks one thing: migrate file by file, or one flow at a time. File by file: a leaf-first port plan with unit tests for every step. One flow at a time: a logic map with every business rule, a design (SDD), test scenarios (TDD) and build steps. The Scaffolder builds from these plans. It can also walk through one screen, file, class.method or feature and extract every business rule. Every unknown becomes a question with a working assumption: three tries, then the next step."
argument-hint: "<component> · <component> files · <component> flow \"<flow>\" · <component> <screen | file | class.method | \"feature\">"
disable-model-invocation: true
---

# /mod-deepdive — Plan the migration of a component

**Requires agent: `Guide`.** Under another agent, stop and ask the developer to switch.

Copilot leads the analysis. The only thing you ask the developer is how to migrate the
component (§ 2). Everything else you can't tell goes to the question bank (§ Unknowns
become questions). Write `docs/` as you go.

Values in `<ANGLE BRACKETS>` come from the text after the command.

| Argument | What you do |
|---|---|
| `<component>` | § 1 Map, then § 2 Choose. If `modern.md` already records the mode for it, skip the question and continue with that mode |
| `<component> files` | § 3 File by file (§ 1 first if there's no map) |
| `<component> flow "<flow>"` | § 4 One flow (a flow from the map, or plain words such as "save an order") |
| `<component> <screen \| file \| class.method \| "feature">` | § 5 Walk-through |

The plans go in `docs/deepdive/`, named after the component: `<component>.md` (the map and
the port plan) and `<component>--<flow>.md` (one per flow or walk-through). The formats are in
[formats.md](formats.md). If a file exists, read it first and extend it: keep its IDs and
steps.

If `docs/target.md` and its Solution aren't both accepted, say "Run `/mod-target` first:
the plan needs the accepted target and solution" and stop. If the component has no § Files yet, say "Run
`/mod-discover-comp <component>` first" and stop. A name that isn't a component: list the 3 closest names and stop.

## Read

- The component's file: § Identity, § Files, § Suggested approach, § Depends on, § Used by.
- `docs/target.md`: its structure (§ 4), construct mapping (§ 3), port decisions (§ 5)
  and this component's verdict (§ 6).
- `docs/skeleton.md`, when it's built: the projects' paths as built and the test
  frameworks chosen.
- Its rows in `docs/system.md`, `docs/modern.md` (decisions, plan) and the OPEN questions
  in `docs/questions.md`.
- [formats.md](formats.md), and the diagram rules in
  [../mod-legacy-report/diagrams.md](../mod-legacy-report/diagrams.md#rules-for-every-diagram).

## 1. Map the component

**a. Read how the files use each other.** Scout briefs of about 15 code files each (skip
generated files and resources), at most 3 in parallel:

```text
GOAL:     file map of <component>, batch <k> of <n>
WHERE:    <the batch's files>
LOOK FOR: the types and members each file defines; the types and members it uses from other
          files of the component and from other components; the entry points it holds
          (Main, form and control events, controller actions, service OnStart, timers,
          macros, public API of a library)
READ:     every file whole
RETURN:   file | defines | uses (file or component) | entry points | path:line
LIMIT:    these files only
```

**b. Reason over it:**
- **Levels:** level 0 is a leaf file that uses no other file of the component. Level n uses
  only lower levels. Files that use each other (a cycle) share one level.
- **Start files:** the files that hold an entry point.
- **Flows:** one per entry point that does a distinct job; merge trivial ones (a Close
  button). For each: a name in plain words ("Save an order"), what triggers it, its start
  file, the files it reaches down to the leaves, and the data and external calls on the way
  (from § Resources used and § Files). A library's flows are its public operations, as its
  callers use them (§ Used by).
- Check the citations (agent rule 3).

**c. Write** `docs/deepdive/<component>.md`: § Flows and § File map. Add the link to the
component file's § Deep-dives.

If the run's Scout calls run out, write what's mapped, mark the map `partial`, and continue it
on the next run before planning.

## 2. Choose: file by file, or one flow at a time

Show the developer, in chat:
- the flows table, and the file map diagram (per flow, when it's over about 25 files);
- what the map means in 3–5 plain sentences: where the logic sits, which files are leaves,
  what the component needs from others;
- your recommendation, from its verdict in `target.md § 6`:
  - **Port → file by file:** the logic moves as code, leaf first, and unit tests keep its
    behaviour;
  - **Rewrite → one flow at a time:** each flow's logic is specified, tested and
    re-implemented. Suggest the first flow: the one with the fewest files and no H-risk
    question;
  - **Split → both:** file by file for the files marked `port`, one flow at a time for the
    rest;
  - **Keep:** nothing to migrate; say so and stop.

Then ask with `askQuestions` (header "Mode"), and stop until the developer answers.
Without the tool, show the options numbered:

```text
How do you want to migrate <component>?
  files               file by file, leaf first           <★ when recommended>
  flow "<flow>"       one flow at a time, starting here  <★ when recommended>
  both                files for the ported part, flows for the rest
```

Record the answer in `docs/modern.md § Target and decisions` (Area: the component; Decision:
the mode and the link to the plan), then continue with § 3 or § 4 in the same chat.

## 3. File by file: the port plan

In `docs/deepdive/<component>.md § Port plan`:
- **Step 0,** if `modern/` doesn't have them yet (file search only; `/mod-modern-skeleton`
  normally built them): the new project and its test project, as in `target.md § 4`.
- **Then leaf first:** level 0 before level 1, and so on up to the start files. A step is one
  file, or a few that go together (a class and its partial or designer file, a cycle); at
  most about 5 files.
- **Each step:** the legacy files, the modern files (same relative path inside the project
  that `skeleton.md`, or else `target.md § 4`, gives it), the changes (the blockers and replacements in
  § Suggested approach, the construct mapping and port decisions in `target.md`, project
  and namespace changes), what it needs (earlier steps, other components, fakes).
- **Unit tests for each step:** for each public member, at least the happy path, the
  boundaries (empty, null, zero, limits) and each error path. The expected result is what the
  legacy code does, cited `path:line`, so the port keeps the behaviour. Mark `run legacy`
  where reading the code isn't enough to be sure (rounding, dates, money, data-dependent
  results).
- **Size:** more than about 20 steps → write the first 20 and say "`/mod-deepdive <component>
  files` continues the plan".

## 4. One flow at a time: logic map, SDD and TDD

In `docs/deepdive/<component>--<flow>.md`:
- **Walk-through:** how it's triggered, the path through the code (handler → logic → data)
  with `path:line`, the data read and written, external calls, and the messages shown. Teach
  unfamiliar constructs in a line. Add the sequence diagram.
- **Logic map:** the flow's steps and decisions as a diagram, each decision naming its rule,
  then every business rule (`R1`, `R2`…): in business words, its type, every place it's
  coded, its exact constants, formats, rounding and messages, and whether the copies agree.
  Look in UI handlers, business classes, stored procedures, triggers, queries, config and
  scripts. Code shows what the system does, not what the business wants: every rule is
  unconfirmed until a business person confirms it.
- **Design (SDD):** what the flow does for the business, its actors, stories with acceptance
  criteria (each naming its rules and tests), screen behaviour, data and integrations, how
  it's built on the target (`target.md`) and how it runs side by side with legacy, and what's
  out of scope.
- **Tests (TDD):** technology-neutral scenarios (`T1`, `T2`…). For each rule: a happy path,
  the boundaries, a negative case and each error path. Expected values come from the legacy
  behaviour, never from new code. Mark `run legacy` where needed. List the fakes and the
  pitfalls.
- **Build steps:** ordered tasks for the Scaffolder (`B1`, `B2`…), tests first. Each names
  the modern files, the tests that must pass and what it needs.
- **Size:** more than about 15 rules → write the walk-through and logic map first, then say
  "`/mod-deepdive <component> flow \"<flow>\"` continues with the design, tests and build
  steps".

## 5. Walk-through of a screen, file, method or feature

Find it in the component (search, or one Scout brief when it spans more than about 5 files),
then write `docs/deepdive/<component>--<slug>.md` with the Walk-through and Logic map of § 4.
It's planned later, when the developer wants: `/mod-deepdive <component> flow "<slug>"` adds
the design, tests and build steps to the same file.

## After each part

- The component file: § Deep-dives links every plan; new links, resources or signals go in
  their tables.
- `docs/questions.md`: the new questions.
- **Chat summary** (not saved; at most 15 lines): what was written, the counts (flows, files
  by level, steps, rules, tests), the rules that disagree or look like defects, the new
  questions (H first), and the next step: a port plan → "select the Scaffolder and run
  `/mod-implement-port <component>`"; a flow → "the Scaffolder builds from
  `docs/deepdive/<file>`"; or what continues this plan.

## Unknowns become questions

As in `/mod-discover`: whatever the files and reasoning can't settle becomes a question in
`docs/questions.md`, with a working assumption, and the work goes on with that assumption to
the next step. Never ask the developer about the legacy system, and never wait for an answer.

- **Three tries first.** Each unknown gets up to **three** tries, automatically: a new Scout
  brief or a new line of reasoning each time (other files, the call sites, the config or
  script that sets a value, the other side of a link, the data it reads). Never ask whether
  to try again.
- **Then a question** → the next step. Link it in the plan's § Open questions, and end each
  rule, test or step that rests on it with `(rests on Q-###)`.
- **No duplicates.** If an OPEN question already covers it, add this plan to that question.
- **Budget:** about 15 Scout calls per run, tries included. What's left is noted in the plan,
  and the next run continues it.

| Unknown | Kind | Ask | Working assumption, for example |
|---|---|---|---|
| A call whose target can't be found: late binding, reflection, events wired at runtime | Technical | Developer | "it calls `<closest match>` (risk M)" |
| A flow whose trigger is unclear: who starts it, when, how often | Operations | Ops · Business | "started by a user from the menu (risk M)" |
| A rule whose intent is unclear: magic numbers, copies that disagree, what looks like a defect | Functional | Business | "what the code does is the rule (risk M)" |
| An expected test result that depends on data or settings not in the repository | Data | DBA · Business | "the result the code path gives for typical data (risk M)" |
| A port blocker with no known replacement | Technical | Developer | "that file is rewritten as part of a flow (risk M)" |
| A design choice the target doesn't settle: where a screen goes, sync or async, who owns the data | Technical | Developer | "the closest to how legacy does it (risk M)" |
| A file in the flow that can't be read (binary, protected) | Technical | Developer: "Export `<what>` as text under `legacy/`, then run `/mod-discover-comp <component>`" | "its behaviour is known only from its callers (risk H)" |
| A Scout "Unknowns" line, or a "Not covered" part still open after one follow-up | by topic | by topic | the narrowest reading |

**Questions:** add rows in the format at the top of `docs/questions.md`. The next ID follows
the highest `Q-###` there. Write each so the person asked can answer without the code.
