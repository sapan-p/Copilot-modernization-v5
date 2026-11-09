---
name: mod-implement-flow
description: "Scaffolder. Rebuilds one component in modern/ one flow at a time, test first, from its /mod-deepdive flow plans: the business rules (logic map), the design (SDD), the test scenarios (TDD) and the build steps. For code that can't be ported as it is, such as VBA to C# or desktop screens to the web. It checks the deep-dive is done, then proposes the road map: the order of the flows, and each flow's execution path with the build steps along it, for you to accept or change. Each build step: the tests first and failing, then the code until they pass, then a tidy-up; you accept the changes or ask for more. Only what you accept is recorded. Unknowns become questions: three tries, then the next step."
argument-hint: "<component> · <component> road map · <component> \"<flow>\" · <component> \"<flow>\" <build step, e.g. B2>"
disable-model-invocation: true
---

# /mod-implement-flow — Rebuild a component, one flow at a time

**Requires agent: `Scaffolder`.** Under another agent, stop and ask the developer to switch.

Some code can't move as it is: the language or the UI has no counterpart on the target (VBA
to C#, Access forms or WinForms screens to the web). Its behaviour moves instead. The plan
states each business rule, the tests pin down what legacy does, and new code is written to
pass them. Test first, always: a test fails before its code exists, and passes after.

One component per run, along its road map, one build step at a time. Build only this
component's flows; another component is reached the way the step's Needs says. The developer
accepts the road map, approves each step's plan and accepts each step's changes. **Nothing is
recorded before the developer accepts it.** VS Code asks before every edit and command.

Values in `<ANGLE BRACKETS>` come from the text after the command.

| Argument | What you do |
|---|---|
| `<component>` | § 1, then § 2: the road map until it's accepted, then the next steps on it |
| `<component> road map` | § 1, then § 2a: the road map, to review or change it |
| `<component> "<flow>"` | § 1, then § 3 for that flow's next build step |
| `<component> "<flow>" <step>` | § 1, then § 3 for that build step |

**Gate: is the deep-dive done?** Check in this order. The first that fails says what to do,
and you stop:
- not a component: list the 3 closest names;
- no `docs/deepdive/<component>.md`: "Select the Guide and run `/mod-deepdive <component>`
  first: the road map comes from its flows and their plans";
- verdict Keep in `docs/target.md § 6`: "Nothing to build: it stays as it is";
- verdict Port and no flow plan: "It's ported, not rebuilt: run `/mod-implement-port
  <component>`";
- the project that receives the component isn't in `modern/` (`docs/skeleton.md
  § Solution`): "Run `/mod-modern-skeleton`: it adds the missing project and its test
  project".

When it passes, say what you found in one line:

```text
Deep-dive of <component>: YYYY-MM-DD · <f> flows: <b> with build steps, <w> walk-through only, <u> not planned · road map <accepted YYYY-MM-DD | not accepted yet>
```

Only a flow whose plan has Build steps can be built. The others stay on the road map with
their next action: "Select the Guide and run `/mod-deepdive <component> flow \"<flow>\"`: it
adds the design, tests and build steps".

## 1. Read

- `docs/deepdive/<component>.md`: § Flows with its **Flow road map** line, § File map, and
  § Port plan for a Split component (the ported files a flow can use).
- Each flow plan, `docs/deepdive/<component>--<flow>.md`: the walk-through, the logic map
  and its rules, the design (SDD), the tests (TDD) with their fakes and pitfalls, the build
  steps and the open questions.
- The component file: § Suggested approach, § Depends on, § Used by, § Resources used,
  § Notes, and § In the modern solution (what's built so far).
- `docs/target.md`: § 3 construct mapping, § 4 the project that receives the component and
  the naming conventions, § 5 port decisions (behaviour, data, how old and new run side by
  side).
- `docs/skeleton.md`: the project and test project paths, the test framework and the other
  implementation choices, and the build and test commands.
- § In the modern solution of each component this one depends on, when it has one.
- `docs/questions.md`: this component's rows. OPEN ones give their working assumptions;
  ANSWERED ones can change a rule, and its tests with it.
- `modern/`: the component's project and test project as they are now.
- For the step you build: the legacy lines its rules cite, to check the exact constants,
  messages, formats and rounding. `legacy/` is read-only.

**Check the records against `modern/`** (file search only):
- **unrecorded:** a build step not marked done whose modern files exist. Offer to verify it
  (build, run its tests) and then review it (§ 5) like a new step;
- **answered:** a `TODO(Q-###)` marker in the component's modern code whose question is now
  ANSWERED. Offer a follow-up: apply the answer to the rule, its tests and its code, remove
  the marker, and say in the record what the answer changed;
- **no longer waiting:** a component under **Waits for** that's now built. Offer a follow-up
  that switches to its modern project.

## 2. The road map

A flow is **built** when every build step is done, and **building** when some are. A step is
**ready** when what its Needs names is built, or is reached the way the plan says (a fake, an
adapter).

### 2a. Propose the road map

When there's no accepted flow road map, or the developer asks for it. Show, in chat:

- **Progress:** `▓▓░░░░░░░░ 1 of 5 flows built · 1 building · 2 planned · 1 to plan`.
- **The flows, in the order you suggest:**

  | # | Flow | Trigger | Plan | Rules · tests | Shares with | Rests on | Status |
  |---|---|---|---|---|---|---|---|

  Plan: build steps done of total, `walk-through only`, or `to plan`. Shares with: the other
  flows that use the same rules, files or data. The order: a flow that's building first;
  then the flows whose rules or data the others reuse (a validation several flows use, the
  flow that creates what others read); then those with no OPEN H-risk question; then the
  fewest rules. Say where it differs from the flow `/mod-deepdive` suggested first.
- **The flow execution path** of the first flow on the road map: its logic map from the plan
  (trigger → steps and decisions → data → result), each node labelled with the build step
  that builds it and its status (`Apply volume discount - R4<br/>B3 · to do`), with a style:
  done `built`, partial `building`
  ([status styles](../mod-modern-report/diagrams.md#status-styles)), the next step `focus`
  ([diagram rules](../mod-legacy-report/diagrams.md#rules-for-every-diagram), which every
  diagram follows). Then its build steps, in order:

  | # | Step | What to build (in `modern/`) | Rules | Tests | Needs | Status |
  |---|---|---|---|---|---|---|

  And one line on how the flow runs side by side with legacy, from the design's "On the
  target".
- **The questions on the path:** the OPEN ones its rules and steps rest on, H first.

Then ask with `askQuestions` (header "Road map"):
- **★ Accept the road map,** and plan the first build step of `<flow>` (§ 3). When that flow
  has no build steps yet, its plan comes first: the Guide's `/mod-deepdive`;
- **Change the road map** (the developer says what): another flow first, a flow left for
  later, or build steps in another order where their Needs allow;
- **Stop here.**

On a change, show the new road map and ask again. Without the tool, number the options and
stop until the developer replies. Once accepted, the road map is what this chat follows. Show
its record; a flow's build steps are listed only when their order changed:

```text
ROAD MAP RECORD · <component> · flows · accepted YYYY-MM-DD
Flows:  "<flow>" → "<flow>" (B1 → B3 → B2) → …
Later:  <flows left for later, and why | —>
```

### 2b. The next steps on the road map

When the road map is accepted. Show the progress line, the current flow's execution path (the
diagram once per flow in a chat), and its next 3–5 build steps, with anything § 1 found in
front of them. Then ask with `askQuestions` (header "Build"): **★ the next step** (what it
builds, its rules, and why), the next two ready steps, and **Show or change the road map**.
"Other…" takes any build step of this component's flows.

- **A step that isn't ready:** name what it needs, and offer ★ **Build that first** (a port
  step of a Split component: `/mod-implement-port <component> <step>`), or **Go on with a
  fake** where the step's Needs allows one.
- **Another component's code:** "That belongs to `<other>`: build it with its own command",
  and ask again.

## 3. Plan the step (no changes yet)

Show:

- **What it builds:** the step's "What to build", its modern files (from the plan's design,
  in the project `skeleton.md` gives), and the rules it implements, each in business words
  with its exact details (constants, formats, rounding, messages), checked against the
  legacy lines it cites.
- **The tests, written first,** in the test project and test framework that `skeleton.md`
  gives:
  - **planned:** the step's scenarios in § Tests (TDD) (`T4`, `T5`…). Given → arrange (with
    the fakes in § Fakes), When → act, Then → assert, with the expected value exactly as the
    plan states;
  - the pitfalls that touch them (rounding mode, decimal or floating point, dates and time
    zones, culture, null or empty, ordering), pinned down in the test;
  - **added:** what the plan misses for these rules (a boundary, an error path), with its
    expected value from the legacy code, cited, and marked `added`.

  Each planned test carries its ID in its name or a trait (`T4_…`). List the `run legacy`
  ones for the developer to confirm on a legacy run.
- **The design it follows:** the stories and acceptance criteria it covers (`S1`…), the screen
  behaviour, data and integrations in the SDD, and the construct mapping in `target.md § 3`.
  The rules live where `target.md` § 4–5 puts business logic, never only in the UI; data
  access and external calls sit behind the interfaces the plan's fakes stand in for.
- **Reuse:** a rule or code another flow or a ported file already built: use it, never a
  second copy.
- **Kept from legacy:** messages, constants, formats, rounding and quirks, and code that looks
  like a defect (a question: § Unknowns), unless an answered question or `target.md § 5` says
  otherwise.
- **Packages:** only those `skeleton.md` records, or one the developer chooses now (2–4
  options, ★ first with its reason).
- **Commands,** each starting with `Set-Location "<workspace>/modern/…";`: the build, this
  step's tests (filtered by their IDs: red, then green), then the whole test project.
- **The questions it rests on:** OPEN ones, and new ones with their working assumptions.

Then ask with `askQuestions` (header "Plan"): **★ Run plan** · **Change something** (the
developer says what) · **Cancel**. On a change, update the plan, show only what changed, and
ask again. Without the tool, ask "Reply `run`, or say what to change, or `cancel`", and stop.

## 4. Build, test first (only after Run plan)

1. **Red:** write the tests, and only the empty types and members they need to compile, each
   throwing "not implemented". Run them: each must fail because the behaviour is missing. A
   test that already passes is suspect: find out why (the behaviour exists elsewhere, or the
   test asserts too little) and report it. Strengthen a test that asserts too little; never
   weaken one.
2. **Green:** write the code that makes them pass, following the design. Where a rule is
   enforced, a short comment names the plan and the rule (`// save-order R3: credit limit`).
   Where the code rests on a question, `TODO(Q-###): <working assumption>` in the target
   language's comment syntax.
3. **Tidy up:** with the tests green, remove duplication and make the names say what the rules
   say. The behaviour doesn't change; run the tests again.
4. **Build and test:** the build, this step's tests, then the whole test project, so nothing
   built earlier breaks. Quote the lines that show red, then green.
5. **A failing test:** check the code against the rule and its legacy lines, and fix the
   code, never the test. At most three focused attempts. Still failing → a question with the
   evidence (expected, actual, the rule, the legacy and modern lines). The test stays as it
   is, never weakened, skipped or deleted; the step is `partial`; go on to § 5.
6. Change only what this step builds, and the code it reuses only as the plan says. A problem
   elsewhere in `modern/` is reported, not fixed.

## 5. Review: accept or change

Nothing is recorded yet. Show:
- the files written or changed (`git -C modern status`, read-only), and what each holds;
- each rule built, and where: `R3 → modern/…:line`;
- the tests: red seen (or which weren't, and why), then passed and failed, planned and
  added, quoting the lines;
- the questions it rests on, the new ones with their working assumptions;
- for a `partial` step: what's left, and its question.

Then ask with `askQuestions` (header "Review"):
- **Accept the changes** (★ when every test passes);
- **Change something** (the developer says what): make the change, test first when it changes
  behaviour, build and test again, and come back to this review. A change beyond the plan is
  listed in the record as `(asked by the developer)`. A test's expected value changes only
  with evidence (a legacy run, an answered question), noted in the record;
- **Discard this step:** undo its changes (delete the files it created, restore the ones it
  changed; VS Code's Undo on the chat's edits does the same). Nothing is recorded, and the
  step stays to do.

Without the tool, ask "Reply `accept`, or say what to change, or `discard`", and stop.

## 6. Record the accepted step, then the next

Only after **Accept**, show the **flow record**:

```text
FLOW RECORD · <component> · "<flow>" · <step> · accepted YYYY-MM-DD
Result:      done | partial: <what's left> (Q-###)
Tests:       <n> pass, <f> fail · <t> planned, <a> added · red seen: <yes | which not, and why> · run legacy: <IDs | —>
Rules:       <R3 → modern path:line; …>
Files:       <modern paths>
Changes:     <(asked by the developer) items | —>
For callers: <legacy entry point → what replaces it (page, endpoint, service) and how to reach it | —>
Waits for:   <component: how it's reached until it's built | —>
Choices:     <implementation details chosen in this step, and why | —>
Questions:   <each new question as a row in questions.md's columns; an existing one: Q-### + this component | —>
Flow:        <k> of <n> steps done | built: every step done, every test passes
Component:   <j> of <m> flows built | built: every flow built (and every port step and screen it has), the whole test project passes (<n> tests)
```

Number new questions after the highest `Q-###` in `docs/questions.md` and any used earlier in
this chat. You can't write `docs/`: the developer chooses the **Record in docs** button, and
the Guide records every accepted record in this chat not yet recorded (the road map and the
steps). Or they paste the records to the Guide.

Then show the progress line and the next steps on the road map, and ask with `askQuestions`
(header "Next step"):

| Option | What happens |
|---|---|
| **★ Build `<next step>`** (what it builds, and why) | Here: its plan (§ 3) |
| **Build another step, or change the road map** | Here: say which, or what to change (§ 2a) |
| **Record in docs** | Choose the **Record in docs** button below. To carry on, select the Scaffolder in a new chat and type `/mod-implement-flow <component>`: it continues from the records |
| **Change something in this step** | Say what: the change is made and reviewed again (§ 5), and the record is shown again |

After about 5 steps in one chat, make **Record in docs** the ★ option: a fresh chat keeps the
work focused, and nothing is lost.

**A flow is built** (every step done, every test passes): say so. Then the options:
- **★ Record in docs;**
- **the next flow on the road map:** its first build step here, or, when it has none yet, the
  Guide's `/mod-deepdive <component> flow "<flow>"`;
- **confirm the rules:** they're unconfirmed until a business person confirms them. Share the
  flow plan's logic map and tests, then tell the Guide who confirmed them, and when;
- **Review and commit:** look at `git -C modern diff`, then commit it yourself.

**The component is built** (every flow built and, for a Split component, every port step
and screen done; the whole test project passes): say so; the record's Component line says built. Then
the options: **★ Record in docs**; the components that use it (§ Used by), each with its next
command, first the ones whose **Waits for** names this component; **Review and commit.**

## What the Guide records

Only records the developer accepted: their first line says `accepted YYYY-MM-DD`. Anything
else isn't recorded; say so. For each accepted record not yet recorded:
- **a road map record** (`flows`): the **Flow road map** line of
  `docs/deepdive/<component>.md § Flows`: `accepted YYYY-MM-DD · "<flow>" → "<flow>" (B1 → B3
  → B2) → … · later: <flows, or —>`.
- **a flow record:**
  - the flow plan's § Build steps: the step's Status, `done (YYYY-MM-DD)` or
    `partial (YYYY-MM-DD): <what's left> (Q-###)`. The changes marked `(asked by the
    developer)` are added to the step;
  - `docs/questions.md`: the new questions, with their IDs. An ID already taken → the next
    free one, and tell the developer which `TODO(Q-###)` markers to rename;
  - the component file: § In the modern solution, in the format of
    [/mod-implement-port § What the Guide records](../mod-implement-port/SKILL.md#what-the-guide-records):
    its status, and once the flow is built, a row for the flow's legacy entry point and what
    replaces it;
  - `docs/modern.md § Progress`: the component's row. The project is its modern part; the
    status is building, or built when the record says so; the evidence is the flows built and
    the test result with its date.

## Unknowns become questions

Whatever the plan, the code, the records and reasoning can't settle becomes a question with a
working assumption, and the build goes on with that assumption. Never ask the developer about
the legacy system, and never wait for an answer. A choice about the new code isn't an unknown
(a package, or a design detail the plan leaves open, such as sync or async, or where a
validation runs): suggest 2–4 options, ★ first with its reason, and let the developer choose;
it goes in the record's Choices.

- **Three tries first,** automatically: a new search or line of reasoning each time (every
  copy of the rule, the call sites, the config or script that sets a value, the walk-through,
  the other flow plans, the answered questions). Never ask whether to try again.
- **Then a question** → the next step. A `TODO(Q-###)` marker goes where the code rests on
  it, each test that rests on it says so, and the question goes in the flow record, recorded
  when the step is accepted.
- **No duplicates.** If an OPEN question already covers it, use that one, and the record adds
  this component to it.

| Unknown | Kind | Ask | Working assumption, for example |
|---|---|---|---|
| A rule whose intent is unclear, or whose copies disagree, and the plan doesn't settle it | Functional | Business | "what the code does on the flow's main path is the rule (risk M)" |
| An expected value the plan and the code can't settle: data, rounding, dates, money | Data | Business · DBA | "what the legacy code path gives for the test's Given; marked run legacy (risk M)" |
| Behaviour that depends on settings: culture, time zone, encoding, config values, paths | Operations | Ops · Developer | "the legacy setting the config shows, else the code's default; the tests pin it (risk M)" |
| Code that looks like a defect | Functional | Business | "kept as legacy does it (risk M)" |
| How the flow runs side by side with legacy, when the plan and `target.md § 5` don't say: which system writes the data, how users switch | Operations | Ops · Business | "legacy stays the system of record until the flow is live (risk H)" |
| A legacy construct with no counterpart in `target.md § 3` (a form event, a macro action, a report) | Technical | Developer | "the closest target construct that keeps what the user sees and the data written (risk M)" |
| A call into another component that the step's Needs doesn't settle | Technical | Developer | "behind an interface here, faked in tests; waits for that component (risk L)" |
| A test still failing after three focused attempts (§ 4) | Technical | Developer | "the rule is what the test expects; the code differs at `path:line` (risk M)" |

Write each question so the person asked can answer it without the code: what we need to know,
and why it matters for the new system.
