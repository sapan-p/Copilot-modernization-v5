---
name: mod-implement-port
description: "Scaffolder. Ports one component to modern/ file by file, from its /mod-deepdive port plan. It checks the deep-dive is done, then proposes the road map: the file execution path, leaf first, in stages, with the file dependencies, for you to accept or change. Then step by step along it: the same logic with only the changes the target needs, its legacy tests ported and the plan's unit tests added, build and test, and you accept the changes or ask for more. Only what you accept is recorded, including what the components that use it need to know. It never strays into another component. Unknowns become questions: three tries, then the next step."
argument-hint: "<component> · <component> road map · <component> <legacy file | plan step, e.g. P3> · <legacy file>"
disable-model-invocation: true
---

# /mod-implement-port — Port a component, file by file

**Requires agent: `Scaffolder`.** Under another agent, stop and ask the developer to switch.

Porting moves the logic as code: the same structure, names, messages, constants and quirks,
changed only where the target needs it, with tests that show the behaviour stayed the same.
It's for the files the plan ports; logic that's rewritten is planned as a flow instead.

One component per run, along its road map, one plan step at a time. Port only this
component's files, and never suggest a file of another component. The developer accepts the
road map, approves each step's plan and accepts each step's changes. **Nothing is recorded
before the developer accepts it.** VS Code asks before every edit and command.

Values in `<ANGLE BRACKETS>` come from the text after the command.

| Argument | What you do |
|---|---|
| `<component>` | § 1, then § 2: the road map until it's accepted, then the next steps on it |
| `<component> road map` | § 1, then § 2a: the road map, to review or change it |
| `<component> <legacy file \| step>` | § 1, then § 3 for the step that holds the file |
| `<legacy file>` | The same, for the component whose § Files lists it |

**Gate: is the deep-dive done?** Check in this order. The first that fails says what to do,
and you stop:
- not a component: list the 3 closest names;
- no `docs/deepdive/<component>.md`, or no § Port plan in it (its deep-dive chose flows):
  "Select the Guide and run `/mod-deepdive <component> files` first: the road map comes from
  its file map and leaf-first port plan";
- verdict Rewrite in `docs/target.md § 6`, or the file is `rewrite` in § Files: "That's
  rewritten, not ported: run `/mod-implement-flow <component>`, which rebuilds it flow by
  flow";
- the project that receives the component isn't in `modern/` (`docs/skeleton.md
  § Solution`): "Run `/mod-modern-skeleton`: it adds the missing project and its test
  project".

When it passes, say what you found in one line:

```text
Deep-dive of <component>: YYYY-MM-DD · map <complete | partial> · <n> files in <s> steps · road map <accepted YYYY-MM-DD | not accepted yet>
```

A partial map: the road map covers the mapped files, and `/mod-deepdive <component> files`
maps the rest.

## 1. Read

- `docs/deepdive/<component>.md`: § Flows, § File map (levels, uses, used by), § Port plan
  with its **Road map** line, § Unit tests and § Open questions.
- The component file: § Files (each file's role, blockers and approach), § Suggested approach
  (the blockers' replacements, and the legacy tests under Safety net), § Depends on, § Used
  by, § Notes, and § In the modern solution (what's ported so far).
- `docs/target.md`: § 3 construct mapping, § 4 the project that receives the component and
  the naming conventions, § 5 port decisions.
- `docs/skeleton.md`: the project and test project paths, the test framework and the other
  implementation choices, and the build and test commands.
- § In the modern solution of each component this one depends on, when it has one.
- `docs/questions.md`: this component's rows. OPEN ones give their working assumptions;
  ANSWERED ones can change what the code must do.
- `modern/`: the component's project and test project as they are now.
- For the step you port: its legacy files and their legacy tests, read whole. `legacy/` is
  read-only.

**Check the records against `modern/`** (file search only):
- **unrecorded:** a step not marked done whose modern files exist. Offer to verify it (build,
  run its tests) and then review it (§ 5) like a new step;
- **answered:** a `TODO(Q-###)` marker in the component's modern code whose question is now
  ANSWERED. Offer a follow-up: apply the answer to the code and its tests, remove the marker,
  and say in the record what the answer changed;
- **no longer waiting:** a component under **Waits for** that's now built. Offer a follow-up
  that switches to its modern project.

## 2. The road map

A file is **ported** when its step is done or partial (partial: what uses it rests on its
question), and **ready** when every file of this component it uses is ported. The leaves
(level 0) are always ready. Only the files the plan ports count; files left to a flow are
shown, never offered.

### 2a. Propose the road map

When the plan has no accepted road map, or the developer asks for it. Show, in chat:

- **Progress:** `▓▓▓░░░░░░░ 7 of 23 files ported · 1 partial · 4 ready`.
- **The file dependency diagram,** from § File map: one subgraph per level, the start files
  on top and the leaves at the bottom, each arrow pointing to the file used. Each label has
  the file, its step and its status (`PriceCalculator.cs<br/>P1 · ported`), with a style:
  ported `built`, partial `building`
  ([status styles](../mod-modern-report/diagrams.md#status-styles)), ready `focus`, other
  components `outside` ([diagram rules](../mod-legacy-report/diagrams.md#rules-for-every-diagram),
  which every diagram follows); a file that isn't ready has none. Over about 25 files: the
  ready files and their neighbours, and a count per level for the rest.
- **The stages,** one per level, leaves first:

  | Stage | Steps | Files | Completes | Rests on |
  |---|---|---|---|---|

  Completes: what is fully ported once the stage is done: a flow from § Flows whose files are
  all ported, or the public members another component uses (§ Used by).
- **The file execution path:** every step, in the order you'll port it:

  | # | Step | Files (legacy → modern) | Level | Uses | Flows | Tests (planned · legacy) | Status |
  |---|---|---|---|---|---|---|---|

  The plan's order, with the unrecorded steps and follow-ups (§ 1) first. Within a level:
  first the steps that unblock the most files, then those with no OPEN H-risk question, then
  the smallest. Say where this differs from the plan's order. Done steps: one row with their
  count.
- **The questions on the path:** the OPEN ones its steps rest on, H first.

Then ask with `askQuestions` (header "Road map"):
- **★ Accept the road map,** and plan its first step (§ 3);
- **Change the road map** (the developer says what): move a step, port steps together (at
  most about 5 files), or leave one for later. A step can't come before a file it uses: say
  which, and offer to port them together;
- **Stop here.**

On a change, show the new path and ask again. Without the tool, number the options and stop
until the developer replies. Once accepted, the road map is what this chat follows. Show its
record:

```text
ROAD MAP RECORD · <component> · files · accepted YYYY-MM-DD
Order:  P1 → P2 → P4 → P3 → P5+P6 → …
Later:  <steps left for later, and why | —>
```

### 2b. The next steps on the road map

When the road map is accepted. Show the progress line, then the next 3–5 steps of the path,
with anything § 1 found (unrecorded steps, follow-ups) in front of them. Then ask with
`askQuestions` (header "Port"): **★ the next step** (its files, and why), the next two ready
steps, and **Show or change the road map**. "Other…" takes any file of this component.

- **A file that isn't ready:** name the files it waits for, and offer ★ **Port those first**
  or **Port them together** in one step, when that's at most about 5 files.
- **A file of another component:** "That belongs to `<other>`: port it with
  `/mod-implement-port <other>`", and ask again.

## 3. Plan the step (no changes yet)

A file moves with its plan step: the files that go together, such as a partial class and its
designer file, or a cycle. Show:

- **Files:** each legacy file → its modern file, as the step's Modern files say (the same
  relative path, in the project `skeleton.md` gives).
- **The changes,** each with its reason and legacy `path:line`, and only these:
  - the step's Changes in the plan;
  - project, namespace and `using` changes, by the naming conventions in `target.md § 4`;
  - the file's port blockers, replaced as § Suggested approach or `target.md § 3` says;
  - the port decisions in `target.md § 5` that touch it (configuration, data access,
    logging);
  - what the target compiler or runtime requires (an API removed or changed), nothing more;
  - names written in strings that change with the namespace: reflection, type names in
    config, serialized type names, resource names;
  - a seam (an interface around a database, file, clock or external call) only where a test
    needs a fake and the step's Needs lists it;
  - calls into another component: built → its modern project, as its § In the modern
    solution says; not built → as the step's Needs says: its legacy build output where
    `target.md § 5` allows it, or an interface here with a fake for the tests, listed under
    **Waits for**.

  Mark a change that isn't in the plan `(not in the plan)`.
- **Kept as it is:** everything else. The logic and control flow, the names, the public
  members other components use (§ Used by), messages, constants, formats, rounding, error
  handling, and code that looks like a defect (a question: § Unknowns). No refactoring,
  renaming, restyling or improvement beyond the changes listed.
- **The tests,** in the test project and test framework that `skeleton.md` gives:
  - **ported:** the legacy tests of these files, with the same assertions; the ones that
    can't be ported, and why;
  - **planned:** the step's unit tests in § Unit tests (`P3.1`, `P3.2`…), except those a
    ported test already covers;
  - **added:** what the plan misses: a branch, boundary or error path no test reaches.

  Every expected value comes from the legacy code, cited, never from the new code. Each test
  can be traced: planned ones carry their ID in the name or a trait (`P3_2_…`), ported ones
  keep their legacy name, added ones are marked `added`. List the `run legacy` ones for the
  developer to confirm on a legacy run.
- **Packages:** only those `skeleton.md` records, or one the developer chooses now (2–4
  options, ★ first with its reason).
- **Commands,** each starting with `Set-Location "<workspace>/modern/…";`: the build, this
  step's tests (filtered by their IDs), then the whole test project.
- **The questions it rests on:** OPEN ones, and new ones with their working assumptions.

Then ask with `askQuestions` (header "Plan"): **★ Run plan** · **Change something** (the
developer says what) · **Cancel**. On a change, update the plan, show only what changed, and
ask again. Without the tool, ask "Reply `run`, or say what to change, or `cancel`", and stop.

## 4. Port (only after Run plan)

1. **Tests first:** write the ported, planned and added tests.
2. **Port the files** with exactly the planned changes. Where the code rests on a question,
   add `TODO(Q-###): <working assumption>` in the target language's comment syntax.
3. **Build and test:** the build, this step's tests, then the whole test project, so nothing
   ported earlier breaks. Quote the lines that show each result.
4. **A failing test:** compare the modern lines with the legacy lines they came from, and fix
   the port, never the test. At most three focused attempts. Still failing → a question with
   the evidence (expected, actual, the legacy and modern lines). The test stays as it is,
   never weakened, skipped or deleted; the step is `partial`; go on to § 5.
5. Change only this step's files. A problem elsewhere in `modern/` is reported, not fixed.

## 5. Review: accept or change

Nothing is recorded yet. Show:
- the files written or changed (`git -C modern status`, read-only), and for each what changed
  from the legacy file and why;
- the test results: passed and failed, per kind (ported, planned, added), quoting the lines;
- the questions it rests on, the new ones with their working assumptions;
- for a `partial` step: what's left, and its question.

Then ask with `askQuestions` (header "Review"):
- **Accept the changes** (★ when every test passes);
- **Change something** (the developer says what): make the change, build and test again, and
  come back to this review. A change beyond the plan is listed in the record as `(asked by
  the developer)`. A test's expected value changes only with evidence (a legacy run, an
  answered question), noted in the record;
- **Discard this step:** undo its changes (delete the files it created, restore the ones it
  changed; VS Code's Undo on the chat's edits does the same). Nothing is recorded, and the
  step stays to do.

Without the tool, ask "Reply `accept`, or say what to change, or `discard`", and stop.

## 6. Record the accepted step, then the next

Only after **Accept**, show the **port record**:

```text
PORT RECORD · <component> · <step> · accepted YYYY-MM-DD
Result:      done | partial: <what's left> (Q-###)
Tests:       <n> pass, <f> fail · <p> ported, <q> planned, <a> added · run legacy: <IDs | —>
Files:       <legacy path> → <modern path>; …
Changes:     <one per line; (not in the plan) or (asked by the developer) where so>
For callers: <project file> · namespace <modern> (was <legacy>) · <type: what changed for its callers | namespace only>
Waits for:   <component: how it's reached until it's built | —>
Choices:     <implementation details chosen in this step, and why | —>
Questions:   <each new question as a row in questions.md's columns; an existing one: Q-### + this component | —>
Component:   <k> of <n> steps done | built: every step done, the whole test project passes (<n> tests)
```

Number new questions after the highest `Q-###` in `docs/questions.md` and any used earlier in
this chat. You can't write `docs/`: the developer chooses the **Record in docs** button, and
the Guide records every accepted record in this chat not yet recorded (the road map and the
steps). Or they paste the records to the Guide.

Then show the progress line and the next steps on the road map, and ask with `askQuestions`
(header "Next step"):

| Option | What happens |
|---|---|
| **★ Port `<next step>`** (its files, and why) | Here: its plan (§ 3) |
| **Port another step, or change the road map** | Here: say which, or what to change (§ 2a) |
| **Record in docs** | Choose the **Record in docs** button below. To carry on, select the Scaffolder in a new chat and type `/mod-implement-port <component>`: it continues from the records |
| **Change something in this step** | Say what: the change is made and reviewed again (§ 5), and the record is shown again |

After about 5 steps in one chat, make **Record in docs** the ★ option: a fresh chat keeps the
work focused, and nothing is lost.

**The road map runs out** (its steps are done, but files of the map aren't in any step):
"Select the Guide and run `/mod-deepdive <component> files`: it continues the plan".

**The component is built** (every step done and, for a Split component, every flow and
screen built with `/mod-implement-flow` and `/mod-implement-ui`; the whole test project
passes): say so; the record's Component line says built. Then the options:
- **★ Record in docs;**
- the components that use it (§ Used by), each with its next command:
  `/mod-implement-port <component>` when it has a port plan, or the Guide's
  `/mod-deepdive <component>` when it doesn't. First the ones whose **Waits for** names this
  component;
- **Review and commit:** look at `git -C modern diff`, then commit it yourself.

## What the Guide records

Only records the developer accepted: their first line says `accepted YYYY-MM-DD`. Anything
else isn't recorded; say so. For each accepted record not yet recorded:
- **a road map record** (`files`): the **Road map** line of `docs/deepdive/<component>.md § Port plan`:
  `accepted YYYY-MM-DD · P1 → P2 → P4 → … · later: <steps, or —>`.
- **a port record:**
  - `docs/deepdive/<component>.md § Port plan`: the step's Status, `done (YYYY-MM-DD)` or
    `partial (YYYY-MM-DD): <what's left> (Q-###)`. The changes marked `(not in the plan)` or
    `(asked by the developer)` are added to its Changes;
  - `docs/questions.md`: the new questions, with their IDs. An ID already taken → the next
    free one, and tell the developer which `TODO(Q-###)` markers to rename;
  - the component file: § In the modern solution, after § Deep-dives (below);
  - `docs/modern.md § Progress`: the component's row. The project is its modern part; the
    status is building, or built when the record says so; the evidence is the steps done and
    the test result with its date.

§ In the modern solution holds what a component that uses this one needs, and nothing more:

```markdown
## In the modern solution

**Status:** <building: k of n steps · j of m flows · s of t screens | built> · **Project:** `modern/…` · **Tests:** `modern/…`: <n> pass (YYYY-MM-DD) · **Updated:** YYYY-MM-DD

**To use it:** reference `<project file>`; namespace `<modern>` (was `<legacy>`)<; the registration or configuration it needs>.

| Legacy | Modern | For callers |
|---|---|---|
| <the other public types> | same names | namespace only |

**Waits for:** <component: how it's reached until that one is built> · or —
```

One row per public type whose use changed for its callers, one per flow rebuilt with
`/mod-implement-flow` (its legacy entry point, and what replaces it), and one per screen
rebuilt with `/mod-implement-ui` (the legacy screen, the new one, how to open it); the last
row covers the rest. The Status leaves out steps, flows or screens the component doesn't
have.

## Unknowns become questions

Whatever the code, the records and reasoning can't settle becomes a question with a working
assumption, and the port goes on with that assumption. Never ask the developer about the
legacy system, and never wait for an answer. A detail of the new code, such as a package, isn't
an unknown: suggest options and let the developer choose.

- **Three tries first,** automatically: a new search or line of reasoning each time (the call
  sites, the config or script that sets a value, the component's other files, its component
  file and plan, the answered questions). Never ask whether to try again.
- **Then a question** → the next step. A `TODO(Q-###)` marker goes where the code rests on
  it, each test that rests on it says so, and the question goes in the port record, recorded
  when the step is accepted.
- **No duplicates.** If an OPEN question already covers it, use that one, and the record adds
  this component to it.

| Unknown | Kind | Ask | Working assumption, for example |
|---|---|---|---|
| A port blocker with no replacement in the records and no built-in equivalent on the target | Technical | Developer | "it goes behind an interface here; the port goes on and its implementation waits (risk M)" |
| Behaviour that depends on settings: culture, time zone, encoding, config values, paths | Operations | Ops · Developer | "the legacy setting the config shows, else the code's default; the tests pin it (risk M)" |
| An expected value the code can't settle: data, rounding, dates, money | Data | Business · DBA | "what the legacy code path gives for the test's Given; marked run legacy (risk M)" |
| Code that looks like a defect | Functional | Business | "kept as legacy does it (risk M)" |
| A legacy test that can't be ported: it needs a database, a UI or a feature the test framework lacks | Technical | Developer | "the planned unit tests cover it against fakes; an integration test comes later (risk L)" |
| A type or resource name that may be stored outside the code: database rows, serialized files, server config | Data | DBA · Ops | "only the copies in the code change; stored ones are updated at cutover (risk H)" |
| A call into another component that the step's Needs doesn't settle | Technical | Developer | "behind an interface here, faked in tests; waits for that component (risk L)" |
| A test still failing after three focused attempts (§ 4) | Technical | Developer | "the legacy behaviour is what the test expects; the port differs at `path:line` (risk M)" |

Write each question so the person asked can answer it without the code: what we need to know,
and why it matters for the port.
