---
name: mod-discover-comp
description: "Copilot leads. Deep discovery of one component at a time: the Scout reads every file, and the Guide finds what /mod-discover missed (links hidden behind wrappers, paths and commands built at runtime, DFS and shares, queues including home-made ones, external executables and CLI calls, late binding, dynamic SQL, cache), maps each file's role and logic, and lists what blocks a port. It then suggests an approach for the component: Port (move the code with minimal change, e.g. a .NET Framework 4.8 library to .NET 10), Rewrite (re-implement from the legacy logic, e.g. VBA to C#), Split (part of each) or Keep. Or it does any focused analysis you ask for. Never stops to ask: every unknown or unresolved search becomes a question with a working assumption. Prepares for migration planning."
argument-hint: "nothing = next component · <component> = deep pass · <component> \"<what to analyse>\""
disable-model-invocation: true
---

# /mod-discover-comp — Deep discovery of a component, and its suggested approach

**Requires agent: `Guide`.** Under another agent, stop and ask the developer to switch.

**You lead.** Never ask the developer anything during this command. Write `docs/` as you go.
What this records is the input for migration planning (`/mod-deepdive`): it suggests an
approach, but it writes no specs and makes no decisions.

Values in `<ANGLE BRACKETS>` come from the text after the command.

- **Nothing:** continue. The component with Deep `partial` first, then the next one without
  Deep ✓ in `docs/system.md § Discovery progress`, lowest layer first. Keep going with the
  next one while the run has Scout calls left.
- **`<component>`:** the deep pass for that component; it redoes one that was done (for
  example after a text export was added under `legacy/`).
- **`<component> "<what>"`:** a focused analysis (below). It doesn't change Deep.

If `docs/system.md § Components` is empty, say "Run `/mod-discover` first" and stop. A name
that isn't a component: list the 3 closest names and stop.

## Read

- The component's file in `docs/components/`, and its rows in `docs/system.md`.
- The OPEN questions in `docs/questions.md`, so you don't log duplicates.
- `docs/modern.md § Target and decisions`: the approach depends on the target.
- [deep-signals.md](deep-signals.md), and the mechanisms in
  [communication-catalog.md](../mod-discover/communication-catalog.md).

## 1. List the files

Search the component's path for every file (skip `bin`, `obj`, `packages`, `node_modules`):
- mark each one `generated`, `resource` or `binary` by name (deep-signals.md § 4); those are
  listed, not read;
- a binary that holds the component's own code (`.accde`, a protected workbook, a DLL whose
  source isn't here) is an unknown (§ Unknowns become questions);
- add the attached test projects;
- group the rest into batches of about 15 files or 3,000 lines.

A `partial` component continues with the files that aren't in its § Files yet.

## 2. Read every file

One Scout brief per batch, at most 3 in parallel:

```text
GOAL:     deep read of <component>, batch <k> of <n>
WHERE:    <the batch's files>
LOOK FOR: deep-signals.md § 1–4, with every mechanism in communication-catalog.md § 1
READ:     every file whole
RETURN:   files: file | role | lines | logic | port blockers
          signals: signal | detail | target hint | path:line
LIMIT:    these files only
```

A Scout report with something under "Not covered" gets one follow-up brief. Each line under
"Unknowns" is an unknown (§ Unknowns become questions).

## 3. Check and resolve

- Check the citations (agent rule 3), above all for every new link and every port blocker.
  A citation that doesn't hold is dropped and becomes an unknown.
- Resolve each new target hint as in
  [mod-discover Step 2c](../mod-discover/SKILL.md#step-2--dependencies), with
  communication-catalog.md § 3.
- A wrapper's call sites in other components: one search over `legacy/`; record those links
  on those components too.
- Every unknown, and every search or target hint that resolves to nothing: § Unknowns
  become questions.

## 4. Suggest the approach

Use the target in `docs/modern.md`. With no target decided, assume the closest supported
stack for the same kind (.NET Framework → .NET 10, desktop stays desktop, web → ASP.NET
Core, VBA / VB6 / Access → C# on .NET 10), say so, and log it as a question once for the
whole bank (§ Unknowns become questions).

| Approach | When |
|---|---|
| **Port** | Every file can move as code, with only project, package and API changes that have a replacement (deep-signals.md § 2). The logic stays as it is, so behaviour doesn't change. Example: a .NET Framework 4.8 class library becomes a .NET 10 library |
| **Rewrite** | The language or UI has no counterpart on the target, or most files hit a blocker with no replacement. The logic is analysed, specified and re-implemented. Example: VBA modules become C# |
| **Split** | Some files port and others are rewritten. List both. Example: an MVC 5 app whose services and models port, and whose `System.Web` parts are rewritten; a WinForms app moving to the web, whose business classes port and whose forms are rewritten |
| **Keep** | It stays as it is and the new system uses it: the target keeps it (`modern.md` says so), or it runs outside the code being modernized (database objects when the data stays, reports kept on their server) |

Binary sources: Rewrite, confidence low, until the text is exported (its question).

**Confidence:**
- `high`: every file was read, the target is decided, and no H-risk question bears on it;
- `medium`: the target is assumed, or a few unknowns remain;
- `low`: a binary source, a partial read, or an H-risk question that decides the approach.

**Safety net:** the tests found, and the classes they cover. A port keeps the logic only if
behaviour is checked: with no tests, say that tests come first.

## 5. Write

As soon as a component is checked:
- **Its component file:** § Files and § Suggested approach (formats below), the new rows in
  § Depends on, § Used by and § Resources used, and new Modernization signals and Open
  questions.
- **Other component files:** § Used by for each new link.
- **`docs/system.md`:**
  - the new links in § Dependencies and § Resources;
  - if a component-to-component link or a resource is new, recompute the graph, tree, layers,
    cycles and hotspots as in [mod-discover Step 2d](../mod-discover/SKILL.md#step-2--dependencies);
  - the Approach column in § Components (`Port · high`);
  - Deep in § Discovery progress: ✓, or `partial (<n> of <m> files)`.
- **`docs/questions.md`:** the new questions, and the component added to the OPEN ones it
  shares.

**Chat summary** per component (not saved; at most 20 lines):
- what the component is, and the files read (`n of m`);
- what the first pass missed: the count by mechanism, and the top 5 with evidence;
- the suggested approach, its confidence, the 2–3 reasons, and the blocker count;
- the logic-heavy files (top 3), and the new questions, H first;
- next: "`/mod-discover-comp` continues with `<component>`", or "Every component has a suggested
  approach".

## Focused analysis

For `<component> "<what>"`, anything the developer wants to know about the component ("every
SQL statement", "how discounts are calculated", "what happens on Save", "who calls the
export"):
- send Scout briefs aimed at it, within the component's files, or across `legacy/` when it
  follows a link out;
- answer in chat with evidence: plain words first, then the path through the code;
- what the code can't answer becomes a question (§ Unknowns become questions), and the
  answer names it;
- record what lasts: a dated entry in the component's § Notes (the request and the answer
  in 3–8 lines, with evidence), and any new link, resource or question in its table;
- if it changes the suggested approach, update § Suggested approach and say so.

## Unknowns become questions

As in `/mod-discover`: whatever the files can't tell becomes a question in
`docs/questions.md`, with a working assumption, and the work goes on with that assumption.
Never ask the developer, never wait for an answer, and never leave an unknown only in chat.

- **Retries first.** Each unknown gets up to **three** retries, automatically. Never ask
  whether to retry. Each retry is a new Scout brief that changes the approach: other files,
  other patterns, the other side of the link, the call sites of a wrapper, the config or
  script that sets the value. Unknowns that share a folder can share one retry brief.
- **Then a question.** Still unknown after the third retry → a question → the next item.
  Link it in the component's § Open questions, and in § Suggested approach under Rests on
  when the approach depends on it.
- **No duplicates.** If an OPEN question already covers it, add the component to that
  question instead.
- **Budget.** Retries count toward the run's Scout calls (about 15). If the calls run out
  while an unknown still has retries left, note it and its retries left in the component's
  row of `system.md § Discovery progress`; the next run picks it up.
- **Not a question:** files not read yet because the calls ran out. They make Deep
  `partial`, and the next run reads them.

| Unknown | Kind | Ask | Working assumption, for example |
|---|---|---|---|
| A search or target hint that resolves to nothing; the link stays in the tables as `? <hint>` | Integration | Developer | "a system outside the repository (risk M)" |
| A value set outside the repository: a config key with no value, a settings table, the registry, an environment variable, a command-line argument | Operations, or Data for a table | Ops · DBA | "the same share as `<x>` (risk M)" |
| A wrapper whose target comes from callers that can't be found or resolved | Integration | Developer | "only the call sites found use it (risk M)" |
| A binary that holds the component's own code | Technical | Developer: "Export `<what>` as text anywhere under `legacy/`, then run `/mod-discover-comp <component>`" | "its internals are unknown; its links come only from the other side (risk H)" |
| A Scout "Unknowns" line, or a "Not covered" part still open after the follow-up | by topic | by topic | the narrowest reading |
| A citation that doesn't hold after its retries | Technical | Developer | "the fact isn't used (risk L)" |
| A port blocker with no known replacement | Technical | Developer | "that part is rewritten (risk M)" |
| Logic whose intent the code doesn't show: rules that disagree across files, magic numbers, errors swallowed | Functional | Business | "what the code does is the rule (risk M)" |
| The target isn't decided, so the approaches rest on an assumed stack | Technical | Developer | "the closest supported stack: `<stack>` (risk H)" |
| In a focused analysis, what the code can't answer | by topic | by topic | the narrowest reading |

## Formats

**Questions:** add rows to `docs/questions.md` in the format at the top of that file. The
next ID follows the highest `Q-###` there. Write each so the person asked can answer it
without the code: what we need to know, and why it matters for the migration.

Add these sections to the component file, after § Modernization signals:

```markdown
## Files

**Read:** <n> of <m> files (<g> generated, <r> resources, <b> binary: listed, not read) · **Updated:** YYYY-MM-DD

| File or group | Role | Lines | Logic | Port blockers | Approach |
|---|---|---|---|---|---|

## Suggested approach

**<Port | Rewrite | Split | Keep>** · confidence <high | medium | low> · target: <from modern.md, or "assumed: <stack>"> · **Updated:** YYYY-MM-DD

- **Why:** <2–4 reasons, with evidence>
- **Ports as it is:** <files or groups>
- **Rewritten:** <files or groups, and why>
- **Safety net:** <tests found and what they cover, or "none: tests first">
- **For migration planning:** <logic-heavy files, rules in several places, questions to settle first>
- **Rests on:** <Q-###, or "—">

| Blocker | Where | Replacement |
|---|---|---|

## Notes

- YYYY-MM-DD "<what was asked>": <the answer, with evidence>
```

- **§ Files:** one row per file up to about 40 files. Beyond that, one row per folder and
  role (with the file count), plus a row for each `heavy` logic file.
- **Approach per row:** `port` · `rewrite` · `regenerate` (generated code made again on the
  target, such as a service reference) · `—` (not code).
