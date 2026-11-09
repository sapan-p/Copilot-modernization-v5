---
name: mod-deepdive
description: "Migration planning for one component, once /mod-target is accepted. Copilot maps every file from the start files down to the leaves and numbers the flows, then decides how each file moves (port the code, rebuild its logic through a flow, rebuild the screen, or keep it) and the order of work across all of it, for you to accept or change. Then it writes the plans that apply, with intense care for the legacy behaviour: port.md (port steps, unit tests, the runtime differences that could change behaviour), a numbered folder per rebuilt flow (logic.md with every method on its path read whole and every rule checked twice, sdd.md, and tdd.md with the build steps), and a plan per screen (its inventory and UI/backend split). change \"<what>\" re-plans. Unknowns become questions: three tries, then the next step."
argument-hint: "<component> · <component> change \"<what>\" · <component> flow <nn> [logic | sdd | tdd] · <component> screen <nn> · <component> <file | class.method | \"feature\">"
disable-model-invocation: true
---

# /mod-deepdive — Plan the migration of a component

**Requires agent: `Guide`.** Under another agent, stop and ask the developer to switch.

Copilot leads the analysis and decides. The developer accepts or changes the plan (§ 2) and
any change to it (§ 7); everything else you can't tell goes to the question bank (§ Unknowns
become questions). Write `docs/` as you go.

**The behaviour is the contract.** The new system is built and tested against these plans, so
they must say exactly what legacy does: every method on a flow's path read whole, every
branch accounted for, every rule checked twice, every expected value worked out from the
legacy lines. Write what the code does, never what it should do. Never cut the analysis short
to save calls: a run that reaches its budget pauses, and the next run carries on.

Values in `<ANGLE BRACKETS>` come from the text after the command.

| Argument | What you do |
|---|---|
| `<component>` | § 1 Map (when there's none, or it's partial), § 2 The plan (when it isn't accepted), then the next plan still to write, in the order of work (§ 3–5) |
| `<component> change "<what>"` | § 7 Re-plan |
| `<component> flow <nn \| "<flow>"> [logic \| sdd \| tdd]` | § 4 for that flow: its next file still to write, or the file named, written again with its IDs kept. Plain words that match no flow add one, with the next free number |
| `<component> screen <nn \| "<screen>">` | § 5 for that screen |
| `<component> <file \| class.method \| "feature">` | § 6 Walk-through |

## Where the plans go

Everything about a component is in its folder, `docs/components/<component>/`. Only the plans
the component needs are written:

```text
docs/components/<component>/
├── component.md            from discovery; § Deep-dives links every plan
├── deepdive.md             the map, how each file moves, the order of work
├── port.md                 port steps and unit tests (when files are ported)
├── flows/
│   └── 01-<flow>/          one folder per rebuilt flow: logic.md · sdd.md · tdd.md
└── screens/
    └── 01-<screen>.md      one plan per screen (when the UI technology changes)
```

- **Numbers:** flows and screens are numbered in the order of work, and a number never
  changes once given: links, records and test names use it. A new one takes the next free
  number.
- **IDs:** inside its own file a flow's IDs are `R3`, `T4`, `B1`; anywhere else they carry its
  number: `F02-R3`, `F02-T4`, `F02-B1`. A screen's steps are `S01-B1`, `S01-U1`. Port steps
  are `P1`, `P2`… and their tests `P3.2`.
- **Folder and file names:** the two-digit number, then the flow or screen in at most about 5
  words, lowercase with hyphens: `02-save-an-order`.
- The formats are in [formats.md](formats.md). If a file exists, read it first and extend it:
  keep its numbers, IDs and steps.

If `docs/target.md` and its Solution aren't both accepted, say "Run `/mod-target` first: the
plan needs the accepted target and solution" and stop. If `component.md` has no § Files yet,
say "Run `/mod-discover-comp <component>` first" and stop. A name that isn't a component: list
the 3 closest names and stop.

## Read

- `component.md`: § Identity, § Files, § Suggested approach, § Depends on, § Used by,
  § Resources used.
- `docs/target.md`: § 2 the technologies (the UI technology above all), § 3 construct
  mapping, § 4 structure, § 5 port decisions, and this component's verdict in § 6.
- `docs/skeleton.md`, when it's BUILT or EXISTING: the projects' paths as built and the test frameworks
  chosen.
- Its rows in `docs/system.md` and `docs/modern.md` (decisions, plan), and this component's
  rows in `docs/questions.md`: OPEN ones, and ANSWERED ones, which can change a rule.
- [formats.md](formats.md), [runtime-differences.md](runtime-differences.md), and the diagram
  rules in [../mod-legacy-report/diagrams.md](../mod-legacy-report/diagrams.md#rules-for-every-diagram).

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
  callers use them (§ Used by). Number them in the order of work (§ 2b); flows that already
  have a number keep it.
- Check the citations (agent rule 3).

**c. Write** `deepdive.md`: § Flows and § File map. Add its line to `component.md`
§ Deep-dives.

If the run's Scout calls run out, write what's mapped, mark the map `partial`, and continue it
on the next run before planning.

## 2. The plan: how each file moves, and the order of work

**a. How each file moves,** from § Files (its Approach column), the verdict in
`target.md § 6` and the UI technology in `target.md § 2`:

| Moves by | When |
|---|---|
| **port** | the code moves as it is, with only the changes the target needs: § Files says `port`, and a UI file keeps its UI technology |
| **rebuild** | its logic is re-implemented, test first, through the flows that cross it: § Files says `rewrite`, and it isn't a screen |
| **screen** | a form, window, view, page or user control whose UI technology changes: it's rebuilt in the new UI, and the logic in its handlers is rebuilt through the flows it starts |
| **regenerate** | generated code made again on the target (a service reference): a port step |
| **keep** | it stays as it is, as `target.md` says |

Files that aren't code (resources, settings) go with the file that uses them. Verdict Keep:
nothing to plan; say so and stop.

- **Flows to rebuild:** a flow whose path crosses a `rebuild` or `screen` file gets flow
  files. A flow entirely in ported files doesn't: it's "ported: P2–P5".
- **Screens:** each `screen` file, and the shell (the main window, menu or layout the other
  screens plug into) when the UI technology changes.

**b. The order of work:** every item as early as its needs allow:
- port steps, leaf first (§ 3 sizes them);
- each flow right after the last port step on its path;
- the shell before the other screens; each screen after the flows it starts and the port
  steps it uses.

Number the flows and screens in this order.

**c. Show it, and ask.** In chat:
- the counts: files by how they move, flows to rebuild, screens;
- how each file moves, as a table (grouped by folder and level over about 40 files);
- the order of work;
- the reasons in 3–5 plain sentences, and the OPEN questions the plan rests on, H first.

Then ask with `askQuestions` (header "Plan"):
- **★ Accept the plan;**
- **Change something** (the developer says what): a file moved another way, another order,
  something left for later;
- **Stop here.**

On a change, show what changed and ask again. Without the tool, number the options and stop
until the developer replies.

**d. On Accept,** write `deepdive.md` § How each file moves and § Order of work (`accepted
YYYY-MM-DD`), and a row in `docs/modern.md § Target and decisions` (Area: the component;
Decision: the plan, its counts, and the link to `deepdive.md`). Then write the plans in the
order of work: `port.md` (§ 3), then each flow (§ 4) and screen (§ 5). The Scaffolder can
start `/mod-implement <component>` as soon as the first item's plan is written.

## 3. `port.md`: the port steps

- **Step 0,** if `modern/` doesn't have them yet (file search only; `/mod-modern-skeleton`
  normally built them): the new project and its test project, as in `target.md § 4`.
- **Then leaf first:** level 0 before level 1, and so on. A step is one file, or a few that go
  together (a class and its partial or designer file, a cycle); at most about 5 files.
- **Each step:** the legacy files, the modern files (the same relative path inside the
  project that `skeleton.md`, or else `target.md § 4`, gives), the changes (the blockers and
  replacements in § Suggested approach, the construct mapping and port decisions in
  `target.md`, project and namespace changes), and what it needs (earlier steps, other
  components, fakes).
- **The behaviour risks of each step:** every change it makes, and every runtime difference
  in [runtime-differences.md](runtime-differences.md) that touches its files. Code that looks
  the same can behave differently on the new runtime.
- **Unit tests for each step:** for each public member, the happy path, both sides of each
  boundary (empty, null, zero, limits), and each error path; every branch of the code the
  step changes; and a test for each behaviour risk. The expected result is what the legacy
  code does, worked out from its lines and cited `path:line`. Mark `run legacy` where reading
  the code isn't enough to be sure (rounding, dates, money, data, the runtime).
- **Size:** more than about 20 steps → write the first 20, and the next run continues.

## 4. A rebuilt flow: `logic.md`, `sdd.md`, `tdd.md`

Write the flow's files in order: `logic.md`, then `sdd.md`, then `tdd.md`. Each builds on the
one before, so each starts only when the previous one's gate passes. Write each file as you
go; when the run's Scout budget is spent, stop after what's written, and say where the next
run carries on.

### 4a. `logic.md`: what legacy does, exactly

1. **The call tree.** From the flow's entry point, list every method it reaches, all the way
   down: the component's own code, the members it calls in other components, down to the
   framework calls. Include what runs without a direct call: handlers wired at runtime,
   overrides and interface implementations chosen at runtime (each one, and when it's
   chosen), reflection and late binding, timers and callbacks.
2. **Read every method whole.** Scout briefs of about 15 methods each, at most 3 in
   parallel:

   ```text
   GOAL:     logic of flow <nn> "<flow>" in <component>, batch <k> of <n>
   WHERE:    <the files of the batch's methods>
   METHODS:  <each method, with its path:line>
   LOOK FOR: every branch (if and else, switch and case, loop exit, early return, guard,
             catch, finally) and what decides it; every constant, format, rounding and
             conversion; every message, word for word; every read and write of data,
             config, files and shared state; every call out, with its arguments; side
             effects and their order; what each caught exception does
   READ:     every method in METHODS whole
   RETURN:   method | branch or statement | what it does, exactly | path:line
   LIMIT:    these methods only; list callees not in METHODS under Not covered
   ```

   Add the callees a report lists under Not covered to the next batch, until none are left.
   Then read what the code reaches outside the code: the SQL it runs; the stored procedures,
   triggers and views; the defaults, constraints and computed columns of the tables it
   writes; the config keys it reads; resource strings; the validation attributes and
   formatters on the data it binds.
3. **The coverage ledger:** one row per method reached. Every branch maps to a rule, or is
   marked `technical` with the reason (logging, a guard against a programming error, retry
   plumbing). A method that can't be read is never skipped silently: it's a question (§
   Unknowns), and the ledger says so.
4. **The rules** (`R1`, `R2`…): each in business words; its type; every place it's coded
   (UI handlers, business classes, stored procedures, triggers, queries, config, scripts);
   its exact details (constants, formats, rounding mode, messages word for word, the order
   validations run in, which decides the message the user sees first); whether the copies
   agree; and how it moves: `rebuilt`, or `port P3` when it's coded in a ported file (it
   moves with that step, and isn't built twice). A rule an earlier flow already has is
   referenced (`F01-R2`), never written again. Code that looks wrong is written down as it
   is, with a question: never corrected.
5. **The traps,** named where they occur, each with what legacy does: the default rounding
   mode (.NET's `Math.Round` rounds halves to even), integer division, decimal or floating
   point, implicit conversions, culture and time-zone defaults, string comparison and
   collation, null, empty and whitespace, ordering without `ORDER BY`, truncation and maximum
   lengths, swallowed exceptions, transaction boundaries.
6. **The walk-through:** how it's triggered, the path through the code (handler → logic →
   data) with `path:line`, the data read and written, external calls, and the messages
   shown. Teach unfamiliar constructs in a line. Add the sequence diagram and the logic map.
7. **Check it, independently.** A separate Scout pass, in briefs of about 15 rules, checks
   each rule against its cited lines ("does the code there do exactly this, no more and no
   less?"), and searches the flow's files for a method or branch the ledger misses. Then
   read the cited lines yourself for every calculation and decision rule. Fix what doesn't
   hold, and mark each rule checked.

**Gate:** every method in the ledger is read, every branch is a rule or technical, every rule
is checked. Then `logic.md` is `complete`. Rules stay unconfirmed until a business person
confirms them.

### 4b. `sdd.md`: the design, keeping the behaviour

From `logic.md` and `target.md`:
- what the flow does for the business, and its actors;
- stories with acceptance criteria, each criterion naming its rules;
- the screen behaviour: every field and control, its data, validation, default, and the
  messages word for word;
- the data: every table and column read and written; the integrations; the side effects, in
  their order;
- **behaviour parity:** what must stay identical (results, messages, data written, side
  effects and their order), and what may differ, only where `target.md § 5` or a recorded
  decision says so, with its source;
- how it's built on the target (`target.md` § 3–5), calling the ported code for the rules
  that move by port; how it runs side by side with legacy; and what's out of scope.

Nothing that `logic.md` doesn't show. A difference on the new system is a decision, listed with
its source in § Behaviour parity; never a silent change.

**Gate:** every rule is in at least one criterion, every criterion names its rules, and every
difference has its source. Then `sdd.md` is `complete`.

### 4c. `tdd.md`: tests that pin the behaviour down, then the build steps

- **Scenarios** (`T1`, `T2`…), technology-neutral. For each rebuilt rule: the happy path,
  both sides of every boundary (limit − 1, limit, limit + 1), a negative case and each error
  path. For each branch of rebuilt code in the ledger, at least one scenario. Each trap gets
  its own. Side effects are asserted too: the data written, the messages, the calls out. A
  rule that moves by port is covered by its port tests: name them (`P3.2`) instead of
  writing it again. Add at least one end-to-end scenario of the whole flow, through the
  ported code.
- **Expected values, worked out from the legacy lines:** step by step for calculations
  ("100 × 0.15 = 15.00; `Math.Round` to even → 15.00"), cited. Never from new code, and never
  what the result should be. Where working it out isn't certain (data, chains of rounding,
  dates), mark the test `run legacy` and add it to § Golden examples: the inputs for the
  developer to run on legacy, and the output to record.
- **Fakes** for the database, files and shares, clock, user, culture and external calls;
  **pitfalls** to watch in the new code.
- **Build steps** (`B1`, `B2`…): ordered tasks for the Scaffolder, tests first. Each names
  the modern files, the tests that must pass, and what it needs (earlier steps, port steps).

**Gate:** every rebuilt rule and every branch of rebuilt code has a test, every test is in a
build step, and every expected value is cited or marked `run legacy`. Then `tdd.md` is
`complete`.

## 5. A screen: `screens/<nn>-<screen>.md`

Read the screen's files whole (Scout, `READ: every file whole`): the layout (designer file,
XAML, Razor view, exported form), the code-behind or view-model, its texts and images. Screen
logic hides in more places than the handlers:

| Legacy UI | Look in |
|---|---|
| WinForms | the form's event handlers; the designer file's properties (formats, data sources, validation events); binding sources; timers; user controls |
| WPF | code-behind; bindings with converters and string formats; triggers; validation rules; commands and view-models |
| MVC views | Razor conditions and loops; helpers; ViewBag and ViewData values the controller computes; validation attributes; inline scripts; partial views |
| VBA and Access forms | event procedures (BeforeUpdate, AfterUpdate, Current, Load); RecordSource and RowSource queries; a control's Default Value and Validation Rule; conditional formatting; DLookup and DoCmd calls; macros |

Write:
- **the inventory:** every control (its label, the data it shows or edits, format, default,
  when it's read-only, hidden or disabled, validation, tab order), every event and what it
  does, the data loaded and saved, the navigation in and out, and every message word for
  word;
- **the split:** each piece of the screen's code goes to the UI or the backend. The test:
  **would it still be needed if this screen didn't exist?** Then it's backend.
  - **UI:** layout, display formats, what's shown, hidden, enabled or focused, navigation,
    dialogs, the messages shown;
  - **UI and backend:** a validation the user should see at once: the backend enforces it,
    the UI repeats it;
  - **backend:** rules, data access, integrations. Each says where it's built: a port step, a
    flow's build step (`F01-B2`), or this screen's own backend step. The same logic in
    several screens is one backend piece;
- **the steps:** `B1`… for the backend pieces this screen builds itself (test first), then
  `U1`… for the screen, one per tab or section when it has more than about 30 controls;
- **the side-by-side check:** what the developer compares with the legacy screen open next
  to the new one.

**Gate:** every control and every handler is in the inventory and in the split. Then the
screen plan is `complete`.

## 6. Walk-through of a file, method or feature

Find it in the component (search, or one Scout brief when it spans more than about 5 files),
give it the next free flow number, and write `flows/<nn>-<slug>/logic.md` with the same care as
§ 4a. It's marked `walk-through` in § Flows. `/mod-deepdive <component> flow <nn>` later adds
`sdd.md` and `tdd.md`, if it's to be rebuilt.

## 7. Re-plan: `change "<what>"`

From the developer, or sent by `/mod-implement` when the plan doesn't fit what it finds: "move
`PriceCalculator.cs` to rebuild", "add the export screen", "`OrderService` isn't what the plan
says".
- Read what the change touches (Scout as needed), and what's already built: the statuses in
  the plans and `component.md § In the modern solution`.
- Work out the new plan: how the files move, the plans affected (a port step removed, a
  flow's or a screen's files written), and the order of work.
- Built work is never dropped silently: a done step that no longer fits is listed, with the
  rework or revert step `/mod-implement` should do.
- Show what changes (before → after), and ask with `askQuestions` (header "Plan change"):
  **★ Accept the change** · **Change something** · **Cancel**. On Accept, write it, and add a
  row to `docs/modern.md § Target and decisions`.

Then: "Select the Scaffolder and run `/mod-implement <component>`".

## After each part

- `component.md § Deep-dives`: a line for `deepdive.md`, for `port.md`, and one per flow and
  screen with the state of its files.
- `deepdive.md`: § Flows and the plan columns of § Order of work.
- New links, resources or signals in their tables in `component.md`.
- `docs/questions.md`: the new questions.
- **Chat summary** (not saved; at most 15 lines):
  - what was written;
  - the counts: files by how they move, port steps, flows and screens; methods read and
    branches accounted for; rules, tests and steps;
  - the rules whose copies disagree or that look like defects;
  - the golden examples to run on legacy;
  - the new questions, H first;
  - the next step: "select the Scaffolder and run `/mod-implement <component>`" once the
    first item's plan is written; or where the next run carries on.

## Unknowns become questions

As in `/mod-discover`: whatever the files and reasoning can't settle becomes a question in
`docs/questions.md`, with a working assumption, and the work goes on with that assumption to
the next step. Never ask the developer about the legacy system, and never wait for an answer.

- **Three tries first.** Each unknown gets up to **three** tries, automatically: a new Scout
  brief or a new line of reasoning each time (other files, the call sites, the config or
  script that sets a value, the other side of a link, the data it reads). Never ask whether
  to try again.
- **Then a question** → the next step. Link it in the file's § Open questions, and end each
  rule, test or step that rests on it with `(rests on Q-###)`. A gate whose last gaps rest
  on questions passes as "complete, resting on Q-###".
- **No duplicates.** If an OPEN question already covers it, add this plan to that question.
- **Budget:** about 15 Scout calls per run, tries included. What's left is noted in the
  file, and the next run continues it.

| Unknown | Kind | Ask | Working assumption, for example |
|---|---|---|---|
| A call whose target can't be found: late binding, reflection, events wired at runtime | Technical | Developer | "it calls `<closest match>` (risk M)" |
| A method on the path that can't be read: no source, a binary library, generated code | Technical | Developer · Vendor | "it does what its callers rely on, nothing more (risk H)" |
| A flow whose trigger is unclear: who starts it, when, how often | Operations | Ops · Business | "started by a user from the menu (risk M)" |
| A rule whose intent is unclear: magic numbers, copies that disagree, what looks like a defect | Functional | Business | "what the code does is the rule (risk M)" |
| An expected test result that depends on data, settings or the runtime | Data | DBA · Business | "the result the code path gives for typical data; marked run legacy (risk M)" |
| A port blocker with no known replacement | Technical | Developer | "that file moves by rebuild (risk M)" |
| Code whose place isn't clear: it formats what's shown and also decides something | Technical | Developer | "backend, repeated in the UI where the user needs it at once (risk L)" |
| A design choice the target doesn't settle: where a screen goes, sync or async, who owns the data | Technical | Developer | "the closest to how legacy does it (risk M)" |
| A file that can't be read (binary, protected, an Access form not exported) | Technical | Developer: "Export `<what>` as text under `legacy/`, then run `/mod-discover-comp <component>`" | "its behaviour is known only from its callers (risk H)" |
| A Scout "Unknowns" line, or a "Not covered" part still open after one follow-up | by topic | by topic | the narrowest reading |

**Questions:** add rows in the format at the top of `docs/questions.md`. The next ID follows
the highest `Q-###` there. Write each so the person asked can answer without the code.
