# Discuss an improvement

For work beyond the accepted plans, on the new system: "move the secrets to Key Vault", "use
Azure App Configuration", "refactor data access to EF Core", "add OpenTelemetry", "split this
service", any refactoring. These are examples, not limits. **Copilot leads the analysis and
recommends the best option, with its reasons; the developer decides.** Nothing is written
until the developer accepts the improvement plan (§ 4). The sections below add to
[SKILL.md](SKILL.md).

## 1. Understand

- **The goal,** in one sentence, in the developer's words. When it's vague, ask up to 3
  clickable questions about the goal only: the scope (which components or projects), the
  environments (local, test, production), the constraints (cost, no cloud, a deadline). How
  to do it is yours to propose.
- **Read:**
  - `docs/target.md` § 2–5 and `docs/skeleton.md`: the stack, its versions, the port
    decisions, the implementation choices;
  - `docs/modern.md`: § Target and decisions, and § Improvements (one that already covers
    this → continue it: § 5);
  - the OPEN rows of `docs/questions.md` the topic touches (found by search; never the whole
    bank).
- **Where we are now:** search `modern/` for what the topic touches, and cite `path:line`:

  | Topic | Search for |
  |---|---|
  | secrets and configuration | `appsettings*.json`, `ConnectionStrings`, `IConfiguration`, `IOptions<`, `Environment.GetEnvironmentVariable`, `ConfigurationManager`, `.env` files, keys named `Password`, `Secret`, `Key`, `Token` |
  | data access | `SqlConnection`, `SqlCommand`, `DbContext`, Dapper's `Query<` and `Execute(`, repositories, `TransactionScope`, stored procedure names |
  | logging and telemetry | `ILogger`, `Console.Write`, `Trace.`, `Debug.`, `EventLog` |
  | anything else | the types, packages and calls the topic names |

  A sweep of more than about 5 files: a Scout brief (`WHERE: modern/`). The legacy side too,
  when the improvement touches behaviour that came from legacy: follow the code's `Legacy:`
  references. Never print a secret you find: `<SECRET>`.

## 2. Options

2–4 options, and **Leave it as it is** when that's a real choice. The recommended one first
(★), with its reason. For each:

| Option | What it is | Fits the stack | Effort | Risk | Cost · licence | Needs outside the code | Local development | How it's tested |
|---|---|---|---|---|---|---|---|---|

- **Fits the stack:** works with the versions in `target.md § 2` and the decisions already
  made.
- **Effort:** the files and projects it touches, from § 1's search.
- **Risk:** what could change behaviour or data, and what pins it down.
- **Needs outside the code:** cloud resources, roles and access, network, settings per
  environment.

**Best means:** supported with the stack's versions; the platform's own way (for ASP.NET Core
configuration, its configuration providers); the fewest new moving parts; testable;
reversible; consistent with the decisions already made. Say what comes from the files and what
is general knowledge (`general: …`). A current version, price or limit you can't check from
here: say so, and how the developer checks it (nuget.org, the Azure pricing calculator, the
service's limits page).

**Behaviour stays.** A refactor keeps what the code does: the existing tests must still pass,
and where a part has no test, the plan adds one that pins what it does now, first. A change
of behaviour is a decision ([/mod-implement § 7](../mod-implement/SKILL.md#7-changes-and-problems-at-any-point)).

**Bigger than an improvement:** a change to a layer's framework, the hosting model, the
database engine or the UI technology changes the target every later deep-dive and build
rests on. Recommend the Guide's `/mod-target <change>` for it; the improvement plan then
covers only the code. A port decision (`target.md § 5`, such as how data is accessed) changed
for the whole solution: the plan's first step is that `/mod-target <change>`, so the Guide
re-checks the components it affects.

## 3. Discuss

Back and forth, as long as the developer wants: questions, a challenge, a comparison, an
example in this code, what a small spike would show. Answer from the code, the records and the
options; change nothing. Then ask (header "Improvement"): ★ the recommended option (by name) ·
another option · **Keep discussing** · **Drop it**. Dropped: offer to record it as a
decision ("considered, not now", and why) in `docs/modern.md § Target and decisions`, after
the developer accepts; otherwise nothing is written.

## 4. The improvement plan (no code yet)

Show the plan, in the format below. Then ask (header "Plan"): ★ **Accept and record** ·
**Change something** · **Keep discussing**. On a change, update it, show what changed, and ask
again.

Accepted, write:
- `docs/improvements/<nn>-<topic>.md`: `nn` after the highest one there, `topic` in
  kebab-case;
- its row in `docs/modern.md § Improvements` (add the section after § Work in progress if an
  older workspace doesn't have it);
- its decision row in `docs/modern.md § Target and decisions`: the Area it touches (data,
  hosting, identity…), the decision, why, the date;
- its new questions in `docs/questions.md`, numbered after the highest of the IDs in its
  table and its **Highest archived ID:** line;
- a package or tool it adds: a row in `docs/skeleton.md § Implementation choices`, when its
  step is accepted.

Say in one line what was written where.

```markdown
# I<nn> · <title>

**Status:** planned · **Decided:** YYYY-MM-DD · **Updated:** YYYY-MM-DD · **Scope:** <projects and components it touches>

## Goal

<what, and why, in the developer's words>

## Where we are now

| What | Where | Note |
|---|---|---|

## Options weighed

| Option | Effort | Risk | Cost · licence | Needs outside the code | Verdict |
|---|---|---|---|---|---|

**Chosen:** <option>, because <reason>. **Not chosen:** <option>: <why>, one line each.

## What changes

- **The code:** <projects, types, configuration>
- **For callers:** <what changes for code that uses it, or "nothing">
- **Outside the code:** <resources, roles, settings per environment, who creates them>
- **Local development:** <how a developer runs it on their machine>

## What we need

| Need | Why | How to get it | Status |
|---|---|---|---|

## Steps

| Step | What | Files | Tests | Needs | Who | Status |
|---|---|---|---|---|---|---|

## Behaviour stays

<the tests that must keep passing; the tests added first to pin what the code does now>

## Rollback

<how to undo it, step by step>

## Questions

<Q-### with the working assumption, or —>
```

- **Steps** (`I01-S1`, `I01-S2`…): tests first, in an order that keeps the solution building
  and its tests passing after each one. **Who** is `developer` for work outside the code
  (create a Key Vault, give the app a role, add a secret): the exact portal path or `az`
  command, and what to check after it. Copilot never runs those, and no secret appears in chat
  or in the plan.
- **Statuses:** a step as [formats.md § Statuses](../mod-deepdive/formats.md#statuses) says;
  the improvement `planned` · `building (<k> of <n> steps)` · `done (YYYY-MM-DD)` ·
  `dropped (YYYY-MM-DD): <why>`.

The row in `docs/modern.md § Improvements`:

```markdown
| I01 | Secrets from Key Vault | orders-api, orders-core | building (2 of 5 steps) | [01-key-vault](improvements/01-key-vault.md) | YYYY-MM-DD |
```

## 5. Build it, step by step

`improvement <nn>`: read its plan, show its progress line and its next step, then the manual
loop of [SKILL.md](SKILL.md) for that step, with the tracker (`I01-S2 · ✓ Plan ▸ …`). And:
- **Comments:** at each change, `// Improvement I01: <what changed, and why> (docs/improvements/01-key-vault.md)`,
  as [modern-code.instructions.md](../../instructions/modern-code.instructions.md) says. The
  `Legacy:` references already there stay true: move them with the code they describe.
- **A developer step** (outside the code): the instructions, then ask (header "Done?"): ★
  **Done** · **Something went wrong** (they say what; you explain it and give the fix).
- **The record:** the build record with the improvement in place of the component:
  `BUILD RECORD · I01 key-vault · I01-S2 · build · manual · accepted YYYY-MM-DD`. Accepted,
  write the step's status in the plan, its **Status:** and **Updated:** lines, and its row in
  `docs/modern.md § Improvements`; and, when the use of a component changes for its callers,
  that component's `component.md § In the modern solution`.
- **Done** (every step done, the whole test projects pass): the status `done`, and the
  options: ★ **Review and commit** (look at `git -C modern diff`, then commit it yourself) ·
  another improvement · back to building a component.
