---
name: mod-implement-ui
description: "Scaffolder. Rebuilds a component's screens in the target UI technology, in modern/: WinForms or WPF forms, MVC views, VBA or Access forms become pages, views or components of the new UI. Give the component and any instructions of your own. It checks the deep-dive is done, then proposes the road map: the screens in order and how they open each other, for you to accept or change. For each screen it splits the legacy code into what stays in the UI and what goes to the backend (rules, data, integrations), reuses what's already built, builds the missing backend test first, then the screen and its tests. You check it side by side with legacy and accept the changes or ask for more; only what you accept is recorded. Unknowns become questions: three tries, then the next step."
argument-hint: "<component> [your instructions] · <component> road map · <component> <screen> [your instructions]"
disable-model-invocation: true
---

# /mod-implement-ui — Rebuild a component's screens

**Requires agent: `Scaffolder`.** Under another agent, stop and ask the developer to switch.

A legacy screen mixes three things: what the user sees, the business rules, and the data
access. The new screen keeps the first. The other two go to the backend, where any screen,
API or job can use them. For each screen you split its code, reuse the backend parts already
built, build the missing ones test first, then build the screen in the target UI technology,
so the user sees and does the same things.

One component per run, along its road map, one screen step at a time. Build only this
component's screens; another component is reached the way its records say. The developer
accepts the road map, approves each step's plan and accepts each step's changes. **Nothing is
recorded before the developer accepts it.** VS Code asks before every edit and command.

Values in `<ANGLE BRACKETS>` come from the text after the command. A name that matches a
screen of the component is a screen; any other text is the developer's instructions, for
example "one page per tab", "start with order entry" or "keep the legacy layout". They shape
the road map and every screen in this chat, and the road map record keeps them.

| Argument | What you do |
|---|---|
| `<component> [instructions]` | § 1, then § 2: the road map until it's accepted, then the next steps on it |
| `<component> road map` | § 1, then § 2a: the road map, to review or change it |
| `<component> <screen> [instructions]` | § 1, then § 3 for that screen's next step |

**Instructions that go further:**
- one that changes the architecture (another UI framework, a new database): "That changes the
  architecture: select the Guide and run `/mod-target <change>`", and go on without it;
- one that changes or drops a business rule: name the rule and what users would lose, and ask
  the developer to confirm. A confirmed one is recorded as a decision (§ 6).

**Gate: is the deep-dive done?** Check in this order. The first that fails says what to do,
and you stop:
- not a component: list the 3 closest names;
- no `docs/deepdive/<component>.md`: "Select the Guide and run `/mod-deepdive <component>`
  first: the road map comes from its file map and flows";
- no screens in its § File map (forms, windows, views, pages, dialogs): "`<component>` has no
  screens: its logic moves with `/mod-implement-port` or `/mod-implement-flow`";
- verdict Keep in `docs/target.md § 6`, or `target.md § 2` keeps the UI: "Nothing to rebuild:
  the target keeps it";
- the UI stays in the same technology (`target.md § 2`, such as WinForms on .NET Framework to
  WinForms on .NET 10): "Its screens are ported, not rebuilt: run `/mod-implement-port
  <component>`";
- the UI project isn't in `modern/` (`docs/skeleton.md § Solution`): "Run
  `/mod-modern-skeleton`: it adds the missing project and its test project".

When it passes, say what you found in one line:

```text
Deep-dive of <component>: YYYY-MM-DD · <s> screens: <p> with a flow plan or walk-through, <n> without · UI: <legacy> → <target> · road map <accepted YYYY-MM-DD | not accepted yet>
```

## 1. Read

- `docs/deepdive/<component>.md`: § Flows (what each screen starts), § File map (the screen
  files, what they use, what opens them), § Port plan for a Split component, and § Screens
  with its road map, when there is one.
- The flow plans and walk-throughs that touch a screen: the walk-through, the rules, the
  design's screen behaviour (fields, validation, defaults, messages) and the tests.
- The component file: § Files, § Suggested approach, § Depends on, § Resources used, § Notes,
  and § In the modern solution (what's built so far).
- `docs/target.md`: § 2 the UI technology, § 3 construct mapping (legacy controls and
  patterns → target), § 4 the UI and backend projects, § 5 port decisions (how old and new
  run side by side).
- `docs/skeleton.md`: the project paths, the UI and backend test frameworks, the other
  implementation choices (a component library, styling), and the build, test and run
  commands.
- § In the modern solution of each component this one depends on, when it has one.
- `docs/questions.md`: this component's rows. OPEN ones give their working assumptions;
  ANSWERED ones can change what a screen must do.
- `modern/`: the UI project, the backend projects and the test projects as they are now.
- For the screen you build: its legacy files, read whole: the layout (designer file, XAML,
  Razor view, exported form), the code-behind or view-model, its texts and images, and the
  code of this component its handlers call. `legacy/` is read-only.

**Check the records against `modern/`** (file search only):
- **unrecorded:** a screen not marked done whose modern files exist. Offer to verify it
  (build, run its tests) and then review it (§ 5) like a new step;
- **answered:** a `TODO(Q-###)` marker in the component's modern code whose question is now
  ANSWERED. Offer a follow-up: apply the answer, adjust its tests, remove the marker, and say
  in the record what the answer changed;
- **no longer waiting:** a backend piece under **Waits for** that's now built. Offer a
  follow-up that replaces the fake with it.

## 2. The road map

A screen is **built** when its steps are done (§ Screens), or a flow's build step already
built it; such a screen is offered only for what the flow left out. It's **ready** when the
backend pieces it needs are built, or reached through a fake the developer accepted.

### 2a. Propose the road map

When there's no accepted screen road map, or the developer asks for it. Show, in chat:

- **Progress:** `▓▓░░░░░░░░ 2 of 9 screens built · 1 building · 3 ready`.
- **The screen map:** a diagram of the screens and how they open each other (menu → list →
  detail → dialog), from the file map, the flows' triggers and the navigation calls
  (`Show()`, `ShowDialog()`, `DoCmd.OpenForm`, `RedirectToAction`, `Navigate`). Each label has
  the screen, its steps and its status, with a style: built `built`, building `building`
  ([status styles](../mod-modern-report/diagrams.md#status-styles)), the next screen `focus`,
  another component's screens `outside`
  ([diagram rules](../mod-legacy-report/diagrams.md#rules-for-every-diagram), which every
  diagram follows).
- **The screens, in the order you suggest:**

  | # | Screen (legacy) | Kind | Opens · opened from | Plan | Backend it needs | Rests on | Status |
  |---|---|---|---|---|---|---|---|

  Kind: main window or menu · list · detail or edit · dialog or lookup · report or print.
  Plan: `flow plan`, `walk-through` or `—`. Backend it needs: how many pieces are built,
  planned or to build here, from a first pass of the split (§ 3b) over its handlers. The
  order, after the developer's instructions:
  1. the shell first: the main window, menu or layout the other screens plug into (its frame
     and navigation only);
  2. the dialogs and lookups that two or more screens open;
  3. the screens whose backend is built, fewest controls first;
  4. the rest, with the screens that rest on an OPEN H-risk question last.

  A screen with business logic in its handlers and neither a flow plan nor a walk-through:
  suggest the Guide's `/mod-deepdive <component> <screen>` first, so its rules are written
  down before they move.
- **The steps of the first screen** (§ 3c):

  | # | Step | What it builds | Backend pieces | Tests | Status |
  |---|---|---|---|---|---|

- **The questions on the path:** the OPEN ones its screens rest on, H first.

Then ask with `askQuestions` (header "Road map"):
- **★ Accept the road map,** and plan the first step (§ 3);
- **Change the road map** (the developer says what): another screen first, a screen left for
  later, a screen split into more steps, or new instructions;
- **Stop here.**

On a change, show the new road map and ask again. Without the tool, number the options and
stop until the developer replies. Once accepted, the road map is what this chat follows. Show
its record:

```text
ROAD MAP RECORD · <component> · screens · accepted YYYY-MM-DD
Screens:      "<screen>" → "<screen>" → …
Later:        <screens left for later, and why | —>
Instructions: <the developer's instructions | —>
```

### 2b. The next steps on the road map

When the road map is accepted. Show the progress line and the next 3–5 steps, with anything
§ 1 found in front of them. Then ask with `askQuestions` (header "Build"): **★ the next step**
(its screen, and why), the next two ready steps, and **Show or change the road map**.
"Other…" takes any screen of this component.

- **A screen that needs a backend piece another plan builds:** offer ★ **Build that first**
  (`/mod-implement-flow <component> "<flow>"` or `/mod-implement-port <component> <step>`),
  or **Go on with a fake** for it, listed under **Waits for**.
- **Another component's screen:** "That belongs to `<other>`: run `/mod-implement-ui
  <other>`", and ask again.

## 3. Plan the step (no changes yet)

### 3a. What the screen does

Take stock from the legacy files and the plans:
- **Controls:** each field, grid, button and menu item: its label, the data it shows or
  edits, its format and default, when it's read-only, hidden or disabled, its validation, and
  the tab order;
- **Events:** each handler, and what it does (load, save, calculate, open a screen, print);
- **Data:** what the screen loads and saves, and from where;
- **Navigation:** who opens it and with what; what it opens; what it returns;
- **Messages:** every message, confirmation and error the user can see, word for word.

Screen logic hides in more places than the handlers:

| Legacy UI | Look in |
|---|---|
| WinForms | the form's event handlers; the designer file's properties (formats, data sources, validation events); binding sources; timers; user controls |
| WPF | code-behind; bindings with converters and string formats; triggers; validation rules; commands and view-models |
| MVC views | Razor conditions and loops; helpers; ViewBag and ViewData values the controller computes; validation attributes; inline scripts; partial views |
| VBA and Access forms | event procedures (BeforeUpdate, AfterUpdate, Current, Load); RecordSource and RowSource queries; a control's Default Value and Validation Rule; conditional formatting; DLookup and DoCmd calls; macros |

### 3b. The split: UI or backend

Each piece of the screen's code goes to one place. The test: **would it still be needed if
this screen didn't exist** (for another screen, an API, a batch job)? Then it's backend. If it
exists only because of the screen, it's UI.

| Goes to | What |
|---|---|
| **UI** | layout; display formats; what's shown, hidden, enabled or focused; navigation and dialogs; the messages shown; UI-only state |
| **UI and backend** | a validation the user should see at once: the backend enforces it, the UI repeats it |
| **Backend: business** | the rules: validation, calculation, decision, workflow |
| **Backend: data** | queries, SQL, stored procedures, files |
| **Backend: integration** | external calls, email, printing and reports, other components |

The backend pieces go where `target.md` § 3–5 puts business logic and data access, and the
screen reaches them through the target's contract: an API for a web UI, a service interface
for a desktop one. The same logic in several screens is one backend piece, reused: say which
screens. Show the split:

| Legacy code (`path:line`) | What it does | Goes to | Where in `modern/` | State |
|---|---|---|---|---|

State: `built` (reuse it, as its § In the modern solution or its flow or port step says),
`planned` (a flow or port step builds it: build that first, or go on with a fake), or `build
here` (no plan covers it).

### 3c. The step's plan

A screen is built in up to two kinds of step: **backend** (the pieces to build here, and the
contract) and **screen** (the page, view or component). A big screen, with more than about 30
controls or with tabs, gets one screen step per tab or section; a small one does both kinds in
one step. Show:

- **Files:** the modern files, in the projects `skeleton.md` gives, named by `target.md § 4`.
- **Backend pieces** (`build here`), test first: the tests from the plan's TDD scenarios when
  it has them, otherwise from the legacy code, every expected value cited; then the code and
  the contract (data shapes, endpoints or interfaces).
- **The screen,** in the target UI technology, by the construct mapping in `target.md § 3`:
  every control in the inventory, with the same labels, data, formats, defaults, read-only and
  visibility rules, tab order and messages, except where the developer's instructions change
  the layout; keyboard access and a label for every input; the calls to the contract, or to
  its fake while the backend waits.
- **Tests:** backend pieces: unit tests, written first. The screen: with the UI test
  framework `skeleton.md` gives (a component test, a view-model test): each control with its
  label and data, the show, hide and enable rules, the defaults, the UI validation and
  messages, and where each action leads.
- **Packages and components:** only those `skeleton.md` records, or one the developer chooses
  now, such as a UI component library: 2–4 options, ★ first with its reason, and the licence.
- **Commands,** each starting with `Set-Location "<workspace>/modern/…";`: the build, this
  step's tests (the backend ones red, then green), the whole test projects, and the run
  command for the side-by-side check.
- **The questions it rests on:** OPEN ones, and new ones with their working assumptions.

Then ask with `askQuestions` (header "Plan"): **★ Run plan** · **Change something** (the
developer says what) · **Cancel**. On a change, update the plan, show only what changed, and
ask again. Without the tool, ask "Reply `run`, or say what to change, or `cancel`", and stop.

## 4. Build (only after Run plan)

1. **Backend pieces, test first:** write their tests and only the empty members they need to
   compile; run them and see each fail because the behaviour is missing. Then the code that
   makes them pass, with a short comment naming the rule where it's enforced; then tidy up
   with the tests green.
2. **The screen:** the layout, bindings and behaviour as planned, with its tests. Rebuild it
   in the target's own way; never translate UI code line by line, and never leave a business
   rule only in the UI. Where the code rests on a question, add `TODO(Q-###): <working
   assumption>` in the target language's comment syntax.
3. **Build and test:** the build, this step's tests, then the whole test projects, so nothing
   built earlier breaks. Quote the lines that show each result.
4. **A failing test:** check the code against the legacy screen and its rules, and fix the
   code, never the test. At most three focused attempts. Still failing → a question with the
   evidence (expected, actual, the legacy and modern lines). The test stays as it is, never
   weakened, skipped or deleted; the step is `partial`; go on to § 5.
5. Change only what this step builds, and reused code only as its plan says. A problem
   elsewhere in `modern/` is reported, not fixed.

## 5. Review: accept or change

Nothing is recorded yet. Show:
- the files written or changed (`git -C modern status`, read-only), and what each holds;
- the split as built: each legacy piece and where it went (UI, backend reused, built here,
  or faked);
- the tests: the backend ones red, then green; the screen's; passed and failed, quoting the
  lines;
- **the side-by-side check** for the developer: the run command, and what to compare with the
  legacy screen open next to the new one: the fields and labels, their order and tab order,
  defaults and formats, what's read-only, hidden or disabled and when, the messages, and where
  each button leads;
- the questions it rests on, the new ones with their working assumptions;
- for a `partial` step: what's left, and its question.

Then ask with `askQuestions`, two questions in one call:
- **Review:** **Accept the changes** (★ when every test passes) · **Change something** (the
  developer says what: make it, build and test again, and come back to this review) ·
  **Discard this step** (undo its changes: delete the files it created, restore the ones it
  changed, or VS Code's Undo on the chat's edits; nothing is recorded and the step stays to
  do);
- **Side by side:** **Checked, it matches** · **Not checked yet**. A difference the developer
  finds is a Change.

A change beyond the plan is listed in the record as `(asked by the developer)`. A test's
expected value changes only with evidence (a legacy run, an answered question), noted in the
record. Without the tool, ask "Reply `accept`, or say what to change, or `discard`; and say
whether you checked it side by side", and stop.

## 6. Record the accepted step, then the next

Only after **Accept**, show the **UI record**:

```text
UI RECORD · <component> · <screen> · <step> · accepted YYYY-MM-DD
Result:      done | partial: <what's left> (Q-###)
Screen:      <legacy file> → <modern file> · opened by <route, menu entry or call>
Split:       <u> UI · <b> backend: <r> reused, <h> built here, <f> faked
Backend:     <piece → modern path: reused | built here | faked, waits for <flow, step or component>; …>
Tests:       <n> pass, <f> fail · backend <k> (red seen: <yes | which not, and why>) · screen <s>
Checked:     side by side by the developer | not checked yet
Changes:     <instructions applied, and (asked by the developer) items | —>
Decisions:   <a business rule the developer changed or dropped, and why | —>
For callers: <how to open the screen; the backend pieces built here that others can use | —>
Waits for:   <piece or component: how it's reached until it's built | —>
Choices:     <implementation details chosen in this step, and why | —>
Questions:   <each new question as a row in questions.md's columns; an existing one: Q-### + this component | —>
Progress:    <k> of <n> steps of this screen · <j> of <m> screens built | component built: every screen built, every step and flow it has done, the whole test projects pass (<n> tests)
```

Number new questions after the highest `Q-###` in `docs/questions.md` and any used earlier in
this chat. You can't write `docs/`: the developer chooses the **Record in docs** button, and
the Guide records every accepted record in this chat not yet recorded (the road map and the
steps). Or they paste the records to the Guide.

Then show the progress line and the next steps on the road map, and ask with `askQuestions`
(header "Next step"):

| Option | What happens |
|---|---|
| **★ Build `<next step>`** (its screen, and why) | Here: its plan (§ 3) |
| **Build another step, or change the road map** | Here: say which, or what to change (§ 2a) |
| **Record in docs** | Choose the **Record in docs** button below. To carry on, select the Scaffolder in a new chat and type `/mod-implement-ui <component>`: it continues from the records |
| **Change something in this step** | Say what: the change is made and reviewed again (§ 5), and the record is shown again |

After about 5 steps in one chat, make **Record in docs** the ★ option: a fresh chat keeps the
work focused, and nothing is lost.

**The component is built** (every screen built, and every port step and flow it has done;
the whole test projects pass): say so; the record's Progress line says so. Then the options:
**★ Record in docs**; the components that use it (§ Used by), each with its next command,
first the ones whose **Waits for** names this component; **Review and commit:** look at
`git -C modern diff`, then commit it yourself.

## What the Guide records

Only records the developer accepted: their first line says `accepted YYYY-MM-DD`. Anything
else isn't recorded; say so. For each accepted record not yet recorded:
- **a road map record** (`screens`): § Screens in `docs/deepdive/<component>.md`, after § Port
  plan or § File map (below): its road map line, and a row per screen in the accepted order.
- **a UI record:**
  - the screen's row in § Screens: its modern file, the steps done, and its status;
  - `docs/questions.md`: the new questions, with their IDs. An ID already taken → the next
    free one, and tell the developer which `TODO(Q-###)` markers to rename;
  - the component file: § In the modern solution, in the format of
    [/mod-implement-port § What the Guide records](../mod-implement-port/SKILL.md#what-the-guide-records):
    its status, a row per screen built (the legacy screen, the modern one, how to open it),
    and a row per backend piece built here that other code can use;
  - `docs/modern.md § Progress`: the component's row. The project is its modern part; the
    status is building, or built when the record says so; the evidence is the screens built
    and the test result with its date;
  - `docs/modern.md § Target and decisions`: each Decisions line (Area: the component).

```markdown
## Screens

**Screen road map:** accepted YYYY-MM-DD · instructions: <… | —> · later: <screens, or —>

| # | Screen (legacy) | Modern | Steps | Status |
|---|---|---|---|---|
```

**Status:** `to do` · `done (YYYY-MM-DD), checked` or `done (YYYY-MM-DD), not checked` ·
`partial (YYYY-MM-DD): <what's left> (Q-###)`.

## Unknowns become questions

Whatever the plans, the code, the records and reasoning can't settle becomes a question with a
working assumption, and the build goes on with that assumption. Never ask the developer about
the legacy system, and never wait for an answer. A choice about the new screen isn't an
unknown (a component library, how an MDI window or a docked panel looks on the target, a
layout the instructions leave open): suggest 2–4 options, ★ first with its reason, and let the
developer choose; it goes in the record's Choices.

- **Three tries first,** automatically: a new search or line of reasoning each time (the
  designer file and the code-behind, the resources, the callers that open the screen, the data
  it binds to, the flow plans and walk-throughs, the answered questions). Never ask whether to
  try again.
- **Then a question** → the next step. A `TODO(Q-###)` marker goes where the code rests on
  it, each test that rests on it says so, and the question goes in the UI record, recorded
  when the step is accepted.
- **No duplicates.** If an OPEN question already covers it, use that one, and the record adds
  this component to it.

| Unknown | Kind | Ask | Working assumption, for example |
|---|---|---|---|
| A screen that can't be read: a binary form, an Access form not exported | Technical | Developer: "Export `<form>` as text under `legacy/`, then run `/mod-discover-comp <component>`" | "rebuilt from its callers, its data and its plan only (risk H)" |
| Code whose place isn't clear: it formats what's shown and also decides something | Technical | Developer | "backend, repeated in the UI where the user needs it at once (risk L)" |
| A rule whose intent is unclear, and no plan settles it | Functional | Business | "what the code does is the rule (risk M)" |
| Behaviour that depends on the user, role or machine: permissions that hide controls, screen size, a printer, local files | Operations | Ops · Business | "as the code shows for the usual user; access checks go to the backend (risk M)" |
| A text or message whose source can't be found: resources, the database, translations | Data | Developer · Business | "the text as the code shows it (risk L)" |
| How users move from the legacy screen to the new one, when `target.md § 5` doesn't say | Operations | Ops · Business | "the legacy screen stays live until the new one is accepted (risk M)" |
| An expected value the code can't settle: data, formats, rounding | Data | Business · DBA | "what the legacy code gives; marked run legacy (risk M)" |
| A call into another component that the plans don't settle | Technical | Developer | "behind an interface here, faked in tests; waits for that component (risk L)" |
| A test still failing after three focused attempts (§ 4) | Technical | Developer | "the legacy screen behaves as the test expects; the code differs at `path:line` (risk M)" |

Write each question so the person asked can answer it without the code: what we need to know,
and why it matters for the new screen.
