---
name: mod-modern-skeleton
description: "Scaffolder. Builds the modern solution skeleton under modern/ from the accepted architecture in docs/target.md, interactively. It settles every implementation detail with you (solution and project names, package manager, test frameworks, linters and formatters, build settings, template options): for each it suggests the best options for the accepted stack, recommended first, and you choose. Then it plans, acts after you choose Run plan (generators, projects, test projects, references, entry-point stubs, restore, build, test), and records the skeleton as built in docs/skeleton.md. It never changes the architecture. Ask for changes at any point; every edit and command is approved in VS Code."
argument-hint: "[nothing = the whole solution · your input: solution name, which projects, \"foundation only\", or a change]"
disable-model-invocation: true
---

# /mod-modern-skeleton — Build the solution skeleton

**Requires agent: `Scaffolder`.** Under another agent, stop and ask the developer to switch.

`/mod-target` decided the architecture: the stack per layer and the projects (`docs/target.md`
§ 2 and § 4). Everything below that level is decided here, with the developer: the
implementation details. You suggest, they choose. You never change the architecture, and you
never decide a detail silently. The developer can ask for a change at any point; apply it,
show what changed, and carry on from there.

**Gate:** `docs/target.md` has Status ACCEPTED and **Solution:** accepted. If not, say "Select
the Guide and run `/mod-target` first: the skeleton needs the accepted target and solution"
and stop.

Values in `<ANGLE BRACKETS>` come from the text after the command. Text that names a solution
name, projects or "foundation only" answers those questions (§ 3) in advance.

## 1. Read

- `docs/target.md`: § 2 (technologies and versions), § 4 (the solution: tree, projects,
  references, naming conventions) and § 5 (port decisions).
- `docs/skeleton.md`: the details already chosen, and the solution as built. Don't ask again
  what it records.
- What `modern/` holds now: list it. Never overwrite a file without listing it as a change.
- Already built (`skeleton.md` is BUILT, or `modern/` has the solution): compare it with § 4
  and offer only what's missing or different.

## 2. Check the tools

Read-only checks in `modern/`, one command each, VS Code asking for each: the SDKs and
runtimes § 2 needs (`dotnet --list-sdks`, `node --version`, `npm --version`…) and the
generator templates § 4 uses (`dotnet new list <template>`). Note what's installed; it
shapes the suggestions (§ 3). A missing SDK or template the architecture needs: say what to
install and stop; never swap in another version.

## 3. Settle the details with the developer

Ask with `askQuestions` (header "Skeleton", at most 4 questions per call), in rounds. Ask
only what the build needs and neither `target.md` nor `skeleton.md` nor the developer's text
already answers.

**Round 1, names and scope:** each with § 4's value as the first option and "Other…":
- the solution name;
- what to build now: everything in § 4 · the foundation only (the solution, the shared and
  cross-cutting projects, the test projects) · choose the projects;
- the project names and folders: keep § 4's, or change some.

**Round 2, implementation details:** the ones this stack needs, for example:

| Stack part | Details to settle |
|---|---|
| .NET projects | test framework (xUnit · NUnit · MSTest); template options (controllers or minimal APIs, authentication template); shared build settings (nullable, warnings as errors, analyzers); central package management |
| JavaScript or TypeScript front end | package manager (npm · pnpm · yarn); test runner (Vitest · Jest); linter and formatter (ESLint and Prettier · Biome); TypeScript strictness |
| Every solution | SDK pin (`global.json`, the § 2 version); editor config; local run (launch profiles, dev HTTPS certificate) |

For each detail, 2–4 options that work with § 2's versions:
- **the recommended one first (★),** with a one-line reason. Best means: current, stable and
  supported with the chosen versions; the stack's or template's default; already installed
  (§ 2); widely used and maintained; and, when the legacy code already uses an equivalent,
  the familiar one;
- each with its main trade-off, and a licence note when it isn't free for commercial use;
- "Other…" to type another.

**Round 3, extras** (multi-select): a README per project (purpose, which legacy components it
receives, allowed references), and the extras of round 2 the developer hasn't settled.

Without the tool, number the options and stop until the developer replies.

**Architecture stays put.** A choice that changes a layer's framework, adds a database, a
message broker or a UI framework, or moves a component to another project is an
architecture change: say "That changes the architecture: select the Guide and run
`/mod-target <change>`", and carry on without it.

## 4. Plan (no changes yet)

Show, grouped by project:
- **the decisions** from § 3, one line each;
- **the tree** after the run, each item marked `new`, `exists` or `change`;
- **the commands** in order, each starting with `Set-Location "<workspace>/modern/…";`:
  - the generators (preferred over hand-written project files): the solution, each project
    with its template options, adding them to the solution, the project references;
  - the packages the decisions need, with versions that fit § 2;
  - then restore, build and test;
- **the files** written by hand:
  - the settings and extras chosen in § 3;
  - entry-point stubs that build and do nothing yet (a host that starts, a page that says
    the app is running);
  - one smoke test per test project that references its project and passes;
  - the generators' sample code removed (`Class1.cs`, sample endpoints and pages), listed;
- **what you can't create, and why.**

Then ask with `askQuestions` (header "Plan"):
- **★ Run plan**
- **Change something** (the developer says what)
- **Cancel**

On a change, update the plan, show only what changed, and ask again. Without the tool, ask
"Reply `run`, or say what to change, or `cancel`", and stop.

## 5. Build (only after Run plan)

1. Run the generators and write the files in the planned order. VS Code asks the developer to
   approve each command and edit.
2. Run restore, build and test. Quote the lines of output that show the result.
3. A failure: fix it inside `modern/` and run again, at most three focused attempts. Still
   failing → stop and report it with the output; never weaken a test or skip a project.
4. Skeleton only: no business logic, no data access, no code copied from legacy.
5. `git -C modern status` (read-only) to show what changed.

## 6. Finish and record

Show the tree as built, each command with its result, and what wasn't created and why. Then
the **skeleton record**: the content of `docs/skeleton.md`, in its sections and columns, as
built:
- **Status:** BUILT, or PARTIAL with what's left; the date; the build and test result;
- **Implementation choices:** every detail settled in § 3: decision · choice · why · date;
- **Solution:** the tree, and the projects (path · kind · framework · test project · test
  framework);
- **Commands:** restore, build, test and run, from `modern/`;
- **Differs from target.md § 4:** the renames and other structure changes, or "nothing".

You can't write `docs/`. The Guide records it: the developer chooses the **Record in docs**
button under your answer, or selects the Guide and pastes the record.

Then ask with `askQuestions` (header "Next step"). Each option says what happens and exactly
what to do:

| Option | What to do |
|---|---|
| **★ Record in docs** | Choose the **Record in docs** button below. The Guide writes `docs/skeleton.md` from the record |
| **Change the skeleton** | Say what, here. The plan is updated, and you choose Run plan again |
| **Plan the first component** | After recording, select **Guide** and type `/mod-deepdive <component>` (the first component from `/mod-target`'s next step) |
| **Review and commit** | Look at `git -C modern diff`, then commit it yourself |

Run "Change the skeleton" here. For the others, show the instruction and stop: only the
developer can switch agents or commit.
