---
name: mod-implement
description: "Scaffolder. Builds one component in modern/, step by step, from its accepted /mod-deepdive plan. Copilot picks the next step from the order of work, whatever its kind (port a file, build a flow test first, rebuild a screen), says why, plans it, builds it after you choose Run plan, and asks you to accept the changes or ask for more; only what you accept is recorded. At any point you can ask in plain words: change this step, rework or revert an accepted one, change a behaviour, fix what's wrong, or re-plan. When it's stuck, it shows what it tried and lets you choose the way out. Unknowns become questions: three tries, then the next step."
argument-hint: "<component> [your instructions] · <component> <step | file | flow nn | screen nn> · <component> road map"
disable-model-invocation: true
---

# /mod-implement — Build a component, step by step

**Requires agent: `Scaffolder`.** Under another agent, stop and ask the developer to switch.

The plan decides what to build and in what order; the developer decides, step by step, that
it's right. Every step, whatever its kind, goes through the same loop: plan → **Run plan** →
build → review → **Accept** → record. **Nothing is recorded before the developer accepts
it.** VS Code asks before every edit and command. Build only this component; another
component is reached the way the plan says.

Each kind of step has a recipe. Read it when a step of that kind comes up:

| Kind | Recipe | Builds |
|---|---|---|
| port | [port-step.md](port-step.md) | a ported file: the same logic, with only the changes the target needs |
| flow | [flow-step.md](flow-step.md) | a flow's build step: the tests first and failing, then the code |
| screen | [screen-step.md](screen-step.md) | a screen's backend piece, or the screen itself |

Values in `<ANGLE BRACKETS>` come from the text after the command. Any other text is the
developer's instructions, for example "one page per tab" or "keep the legacy layout": they
shape the steps of this chat, and the records keep them.

| Argument | What you do |
|---|---|
| `<component>` | § 1, then § 2: the next step on the order of work |
| `<component> <step \| file \| flow nn \| screen nn>` | § 1, then § 3 for that step (`P3`, `F02-B1`, `S01-U1`), or the next step of that file, flow or screen |
| `<component> road map` | § 1, then the order of work, to review or change it (§ 2) |

**Gate,** in this order. The first that fails says what to do, and you stop:
- not a component: list the 3 closest names;
- no accepted plan (`deepdive.md` says **Plan:** accepted): "Select the Guide and run
  `/mod-deepdive <component>`: the build follows its accepted plan";
- verdict Keep, or nothing in the plan to build: "Nothing to build: it stays as it is";
- the project that receives the component isn't in `modern/` (`docs/skeleton.md
  § Solution`): "Run `/mod-modern-skeleton`: it adds the missing project and its test
  project".

## 1. Read

- `docs/components/<component>/deepdive.md`: § How each file moves, § Order of work, § File
  map and § Flows.
- The plan of the step, and the recipe for its kind: its row and tests in `port.md`; or the
  flow's `logic.md`, `sdd.md` and `tdd.md`; or the screen's plan in `screens/`.
- `component.md`: § Files, § Suggested approach, § Depends on, § Used by, § Notes, and § In
  the modern solution.
- `docs/target.md` § 2–5, and `docs/skeleton.md`: the project paths, test frameworks,
  implementation choices, and the build, test and run commands.
- § In the modern solution of each component this one depends on, when it has one.
- `docs/questions.md`: this component's rows. OPEN ones give their working assumptions;
  ANSWERED ones can change what the code must do.
- `modern/`: the component's projects and tests as they are now.
- For the step: the legacy files it moves, or the lines its rules cite, read whole. `legacy/`
  is read-only.

**Check the records against `modern/`** (file search, and `git -C modern status`, read-only),
and put what you find first in § 2:
- **unrecorded:** a step not marked done whose modern files exist. Verify it (build, run its
  tests), then review it (§ 5) like a new step;
- **your own edits:** changed files of accepted steps. Run their tests, and offer to record
  them as a rework by the developer;
- **answered:** a `TODO(Q-###)` marker whose question is now ANSWERED. Offer a follow-up:
  apply the answer to the code and its tests, and remove the marker;
- **no longer waiting:** a component or step under **Waits for** that's now built. Offer a
  follow-up that switches to it.

## 2. The next step

An item is **ready** when everything under its Needs is done; a `partial` one counts as done,
and what uses it rests on its question. Show:
- **the progress line:** `▓▓▓░░░░░░░ 9 of 24 items done · 1 building · 1 partial · next: F01-B2`;
- **the order of work** around the next step: what's done, the next 3–5 ready steps, and what
  the others wait for;
- **the next step's picture,** as its recipe says;
- **why it's next:** the first ready item in the order of work, its kind, and what it
  unblocks.

Then ask with `askQuestions` (header "Next"): **★ the next step** (what, its kind, and why),
the next two ready steps, and **Show or change the road map**. "Other…" takes any step of this
component, or anything in plain words (§ 7).

- **A step that isn't ready:** name what it needs, and offer ★ **Build that first**, or **Go
  on with a fake** where the plan allows one (listed under **Waits for**).
- **Another component's file:** "That belongs to `<other>`: run `/mod-implement <other>`",
  and ask again.
- **The road map:** the order of work with its statuses. A change (another order, an item
  left for later) must keep each item after its Needs: say which, and offer the nearest order
  that works. An accepted change is a record of kind `order`.

## 3. Plan the step (no changes yet)

Show, from the plan and the recipe:
- **what it builds, and from what:** the legacy files or the rules; the modern files, in the
  projects `skeleton.md` gives, named by `target.md § 4`;
- **the changes or the design,** as the recipe says;
- **the tests, written first:** ported, planned (with their IDs) and added. Every expected
  value comes from the legacy code, cited, or as the plan works it out. List the `run legacy`
  ones for the developer to confirm on a legacy run;
- **packages:** only those `skeleton.md` records, or one the developer chooses now (2–4
  options, ★ first with its reason, and its licence);
- **commands,** each starting with `Set-Location "<workspace>/modern/…";`: the build, this
  step's tests, then the whole test projects;
- **the questions it rests on:** OPEN ones, and new ones with their working assumptions.

Then ask with `askQuestions` (header "Plan"): **★ Run plan** · **Change something** (the
developer says what) · **Cancel**. On a change, update the plan, show only what changed, and
ask again. Without the tool, ask "Reply `run`, or say what to change, or `cancel`", and stop.

## 4. Build (only after Run plan)

1. Build the step as its recipe says, tests first.
2. Where the code rests on a question, add `TODO(Q-###): <working assumption>` in the target
   language's comment syntax.
3. **Build and test:** the build, this step's tests, then the whole test projects, so nothing
   built earlier breaks. Quote the lines that show each result.
4. **A failing test:** fix the code, never the test. At most three focused attempts; then
   § 8.
5. Change only what this step builds. A problem elsewhere in `modern/` is reported, and
   offered as a fix step (§ 7).

## 5. Review: accept or change

Nothing is recorded yet. Show:
- the files written or changed (`git -C modern status`, read-only), what changed in each, and
  why;
- the tests: passed and failed by kind, quoting the lines;
- what the recipe adds to the review;
- the questions it rests on, the new ones with their working assumptions; for a `partial`
  step, what's left.

Then ask with `askQuestions` (header "Review"):
- **Accept the changes** (★ when every test passes);
- **Change something** (the developer says what): make it, build and test again, and come
  back to this review;
- **Discard this step:** undo its changes (delete the files it created, restore the ones it
  changed, or VS Code's Undo on the chat's edits). Nothing is recorded, and the step stays to
  do.

Without the tool, ask "Reply `accept`, or say what to change, or `discard`", and stop.

## 6. Record, then the next step

Only after **Accept**, show the **build record**:

```text
BUILD RECORD · <component> · <step> · <build | rework | fix | revert | order> · accepted YYYY-MM-DD
Result:       done | partial: <what's left> (Q-###) | reverted
What:         <the file ported, the flow step, the screen step, or the change asked for>
Files:        <legacy path → modern path; the modern paths written or changed>
Tests:        <n> pass, <f> fail · <p> ported, <q> planned, <a> added · red seen: <yes | which not, and why | —> · run legacy: <IDs | —>
Rules:        <F02-R3 → modern path:line; … | —>
Checked:      <side by side by the developer | not checked yet | —>
Changes:      <beyond the plan: (not in the plan), (asked by the developer), the developer's instructions | —>
Decisions:    <a behaviour that now differs from legacy: the rule, what legacy does, what it does now, and why | —>
Plan changes: <file § section: the correction, one per line | —>
For callers:  <project file · namespace (was <legacy>) · what changed for callers; how to open a screen | —>
Waits for:    <component or step: how it's reached until it's built | —>
Choices:      <implementation details chosen, and why | —>
Questions:    <each new question as a row in questions.md's columns; an existing one: Q-### + this component | —>
Progress:     <k> of <n> items done · <item>: <k> of <n> steps | component built: every item done, the whole test projects pass (<n> tests)
```

Number new questions after the highest `Q-###` in `docs/questions.md` and any used earlier in
this chat. You can't write `docs/`: the developer chooses the **Record in docs** button, and
the Guide records every accepted record in this chat not yet recorded. Or they paste the
records to the Guide.

Then show the progress line and the next ready steps, and ask with `askQuestions` (header
"Next step"):

| Option | What happens |
|---|---|
| **★ Build `<next step>`** (what, and why) | Here: its plan (§ 3) |
| **Another step, or change the road map** | Here: say which, or what to change (§ 2) |
| **Record in docs** | Choose the **Record in docs** button below. To carry on, select the Scaffolder in a new chat and type `/mod-implement <component>`: it continues from the records |
| **Change something in this step** | Say what: the change is made and reviewed again (§ 5), and the record is shown again |

After about 5 steps in one chat, make **Record in docs** the ★ option: a fresh chat keeps the
work focused, and nothing is lost.

**An item is done:** say so. When it's a flow, suggest confirming its rules with a business
person: share its `logic.md` and `tdd.md`, then tell the Guide who confirmed them, and when.

**The component is built** (every item in the order of work done; the whole test projects
pass): say so; the record's Progress line says so. Then the options: **★ Record in docs**;
the components that use it (§ Used by), each with its next command (`/mod-implement
<component>` when its plan is accepted, or the Guide's `/mod-deepdive <component>`), first the
ones whose **Waits for** names this component; **Review and commit:** look at `git -C modern
diff`, then commit it yourself.

## 7. Changes and problems, at any point

The developer can say what they want in plain words, at any point. Say what kind of request it
is and what you'll do, then handle it like any step: plan → Run plan → build → review →
Accept → record.

| The developer says | It is | What you do |
|---|---|---|
| a change to the current step, before it's accepted | a change | update the plan or the code, build and test, and review again |
| a change to an accepted step ("in P3, use Dapper") | **rework** | a rework step on it. Its tests must still pass: the behaviour doesn't change |
| a change of behaviour ("the discount is 10%", "drop this field") | **a decision** | name the rule and what legacy does (`F02-R3: 5%, Pricing.cs:41`), and ask the developer to confirm. Confirmed: build it, change the expected values it affects (their source: the decision), and record it under Decisions and Plan changes |
| a package, library or tool | an implementation detail | suggest 2–4 options, ★ first with its reason; the developer chooses |
| another framework, a database, a message broker | an architecture change | "That changes the architecture: select the Guide and run `/mod-target <change>`", and go on without it |
| "rebuild this instead of porting it", a new flow or screen, or the plan doesn't fit the code | **re-plan** | it needs fresh analysis: "Select the Guide and run `/mod-deepdive <component> change \"<what>\"`". Meanwhile, offer the next step that doesn't depend on it |
| "this is wrong", "the screen differs from legacy" | **a fix** | compare the code with the legacy lines and the plan, show the cause, and propose ★ a fix as a step. When legacy really does what was seen and the plan was wrong, the correction goes under Plan changes |
| "undo P3" | **revert** | delete the files the step created and restore the ones it changed, never with a git command. List what depends on it first |
| a question ("why does it round like this?") | a question | answer from the plan and the legacy lines; change nothing |
| a problem outside the code: a missing SDK, a failed restore, a database it can't reach | an environment problem | say what's wrong and what to do; change no code; offer **Retry** |

Never weaken a test. An expected value changes only for a decision the developer confirmed,
an answered question, or a recorded legacy run.

## 8. When stuck

After three focused attempts (a test still failing, a build error, a blocker without a
replacement), don't loop, and don't give up silently. Show:
- what fails, with the output lines;
- the three attempts, and what each one showed;
- the likely cause, with the legacy and modern lines.

Then ask with `askQuestions` (header "Stuck"):
- **★ the fix you'd try next,** specific: "round each line before summing, as
  `Pricing.cs:38` does";
- **another fix,** when there is one;
- **Keep it as a decision,** when the difference is acceptable (a behaviour change, § 7);
- **Park it:** a question with the evidence, the step `partial`, and on to the next ready step;
- **Re-plan:** `/mod-deepdive <component> change "<what>"`.

A fix the developer chooses is their decision, not a loop. Without the tool, number the
options and stop. With no answer, park it: the work never waits.

## What the Guide records

Only records the developer accepted: their first line says `accepted YYYY-MM-DD`. Anything
else isn't recorded; say so. For each accepted record not yet recorded:
- **the step's status** in its plan (`port.md`, the flow's `tdd.md § Build steps`, or the
  screen plan's § Steps), as
  [formats.md § Statuses](../mod-deepdive/formats.md#statuses) says, and the item's status in
  `deepdive.md § Order of work`;
- **an `order` record:** `deepdive.md § Order of work` as accepted;
- **Plan changes:** each in the file and section it names. `logic.md` changes only when it
  was wrong about what legacy does; a decision never changes it;
- **Decisions:** a row in `docs/modern.md § Target and decisions` (Area: the component), and
  a "May differ" row in the flow's `sdd.md § Behaviour parity` with the decision as its
  source;
- **Questions:** the new rows in `docs/questions.md`, with their IDs. An ID already taken →
  the next free one, and tell the developer which `TODO(Q-###)` markers to rename. An existing
  question gets this component;
- **`component.md § In the modern solution`,** after § Deep-dives (below);
- **`docs/modern.md § Progress`:** the component's row. The project is its modern part; the
  status is building, or built when the record says so; the evidence is the items done and
  the test result with its date.

§ In the modern solution holds what a component that uses this one needs, and nothing more:

```markdown
## In the modern solution

**Status:** <building: k of n items | built> · **Project:** `modern/…` · **Tests:** `modern/…`: <n> pass (YYYY-MM-DD) · **Updated:** YYYY-MM-DD

**To use it:** reference `<project file>`; namespace `<modern>` (was `<legacy>`)<; the registration or configuration it needs>.

| Legacy | Modern | For callers |
|---|---|---|
| <the other public types> | same names | namespace only |

**Waits for:** <component: how it's reached until that one is built> · or —
```

One row per public type whose use changed for its callers, one per rebuilt flow (its legacy
entry point, and what replaces it), and one per screen (the legacy screen, the new one, and
how to open it); the last row covers the rest.

## Unknowns become questions

Whatever the plan, the code, the records and reasoning can't settle becomes a question with a
working assumption, and the build goes on with that assumption. Never ask the developer about
the legacy system, and never wait for an answer. A choice about the new code isn't an unknown
(a package, a design detail the plan leaves open, a layout the instructions don't settle):
suggest 2–4 options, ★ first with its reason, and let the developer choose; it goes in the
record's Choices.

- **Three tries first,** automatically: a new search or line of reasoning each time (the call
  sites, the config or script that sets a value, the component's other files, the plans, the
  answered questions). Never ask whether to try again.
- **Then a question** → the next step. A `TODO(Q-###)` marker goes where the code rests on
  it, each test that rests on it says so, and the question goes in the build record,
  recorded when the step is accepted.
- **No duplicates.** If an OPEN question already covers it, use that one, and the record adds
  this component to it.

| Unknown | Kind | Ask | Working assumption, for example |
|---|---|---|---|
| A port blocker or legacy construct with no replacement in the records, and no built-in equivalent on the target | Technical | Developer | "it goes behind an interface here; the build goes on and its implementation waits (risk M)" |
| Behaviour that depends on settings or the runtime: culture, time zone, encoding, config values, paths | Operations | Ops · Developer | "the legacy setting the config shows, else the code's default; the tests pin it (risk M)" |
| An expected value the plan and the code can't settle: data, rounding, dates, money | Data | Business · DBA | "what the legacy code path gives; marked run legacy (risk M)" |
| A rule whose intent is unclear, and the plan doesn't settle it | Functional | Business | "what the code does on the main path is the rule (risk M)" |
| Code that looks like a defect | Functional | Business | "kept as legacy does it (risk M)" |
| A legacy test that can't be ported: it needs a database, a UI or a feature the test framework lacks | Technical | Developer | "the planned tests cover it against fakes; an integration test comes later (risk L)" |
| A type or resource name that may be stored outside the code: database rows, serialized files, server config | Data | DBA · Ops | "only the copies in the code change; stored ones are updated at cutover (risk H)" |
| How old and new run side by side, when the plan and `target.md § 5` don't say | Operations | Ops · Business | "legacy stays the system of record until this part is live (risk H)" |
| Behaviour that depends on the user, role or machine: permissions that hide controls, printers, local files | Operations | Ops · Business | "as the code shows for the usual user; access checks go to the backend (risk M)" |
| A call into another component that the plan doesn't settle | Technical | Developer | "behind an interface here, faked in tests; waits for that component (risk L)" |
| A step parked after three focused attempts (§ 8) | Technical | Developer | "the legacy behaviour is what the test expects; the code differs at `path:line` (risk M)" |

Write each question so the person asked can answer it without the code: what we need to know,
and why it matters for the new system.
