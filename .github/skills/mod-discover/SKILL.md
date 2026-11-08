---
name: mod-discover
description: "Copilot leads. Builds the understanding of a legacy system you don't know, in two steps: (1) every component (project) in legacy/ with its technology in detail - kind, language, framework and version, packages, platform, what it exposes; (2) every dependency between components - project and DLL references, services, CLI and shell launches, COM, shared databases, files and shares, queues and more - into a dependency graph, tree and layers. Writes docs/system.md, one file per component and the question bank. Never stops to ask: unknowns become questions with a working assumption."
argument-hint: "[<component>] — nothing continues where it stopped; a component name redoes that one"
disable-model-invocation: true
---

# /mod-discover — Components, technologies and dependencies

**Requires agent: `guide`.** Under another agent, stop and ask the developer to
switch.

**You lead.** Never ask the developer anything during this command. Write `docs/` as you go.

Values in `<ANGLE BRACKETS>` come from the text after the command.

- **Nothing:** continue from `docs/system.md § Discovery progress`. Do Step 1 while
  components are missing or lack Technology ✓, then Step 2 for the components without
  Dependencies ✓. If everything is ✓, give the chat summary (Step 2f) and stop.
- **`<component>`:** redo Steps 1c–1d and 2a–2e for that component only (for example, after
  the developer added a text export under `legacy/`). Update every file it touches.

If `legacy/` is missing or empty, stop: "Clone the legacy repository into `legacy/` (see
README)".

## Read

- `docs/system.md`, and the OPEN questions in `docs/questions.md` so you don't log duplicates.
- [technology-signals.md](technology-signals.md) for Step 1.
- [communication-catalog.md](communication-catalog.md) for Step 2.

## Step 1 — Components

**a. Census.** One scout brief over all of `legacy/`:
- LOOK FOR: every marker in technology-signals.md § 1 Markers;
- RETURN: `folder | marker files | count`.

For a very large repository, split it by top-level folder (at most 3 briefs in parallel).

**b. Decide the components** (your reasoning, no scout):
- each project is a component: a .NET project, an Access or Excel VBA file (or its text
  export), a VB6 project, a database project or SQL script set, an SSIS or report project,
  a web front-end package, or a folder of scripts or jobs that runs as one unit;
- a test project is not a component: attach it to the component it tests;
- a solution (`.sln`) is a grouping, not a component: note it on each member;
- a third-party DLL checked into the repo is not a component: it is a library in the
  Technology of whoever references it;
- name each component with a short lowercase slug from its project name, unique across the
  repo (`orders-winforms`). That name is its ID everywhere.

**c. Technology details.** Scout briefs of at most 5 components each (at most 3 in parallel):
- LOOK FOR: technology-signals.md § 2 Details for each component's kind;
- RETURN: `component | field | value | path:line`.

Check the cited versions (agent rule 3). A field the files don't show is "not declared". A
gap that matters for the migration (framework version, unknown runtime) gets the retries in
§ Never loop, never stop, then a question. A binary-only source needs no retry: it gets its
question straight away (below).

**Unreadable sources** (`.accdb`, `.mdb`, `.accde`, `.xlsm` with no text export, an exe or
DLL with no source): still a component, identified from the file. Its Readability is
`binary`. Log a question: Kind Technical, Ask Developer: "Export <what: VBA modules,
queries, forms, macros> as text anywhere under `legacy/`, then run `/mod-discover
<component>`". Working assumption: "internals unknown; its dependencies come only from
the other components' side (risk if wrong: H)".

**d. Write**, batch by batch, as soon as the batch is checked:
- `docs/components/<component>.md`: create it in the format below, with Identity,
  Technology and Modernization signals filled in;
- `docs/system.md`: a row in § Components, and Technology ✓ in § Discovery progress;
- `docs/questions.md`: the new questions.

## Step 2 — Dependencies

**a. Outgoing links.** Scout briefs of 1–3 components each (at most 3 in parallel):
- LOOK FOR: the mechanisms that communication-catalog.md § 2 lists for each component's
  kind, with the patterns in § 1;
- RETURN: `component | mechanism | target hint | direction | path:line`. The target hint is
  what the code names: a project, DLL, exe or script, URL or endpoint key, ProgID, queue,
  table or procedure, UNC path, registry key.

**b. Shared-resource sweep.** One brief over all of `legacy/`:
- LOOK FOR: connection strings and DSNs (server and database names only), UNC and DFS paths
  and mapped drives, queue names, base URLs and service endpoints, SMTP and FTP hosts,
  scheduled task definitions;
- RETURN: `resource | kind | used by (component) | read/write | path:line`.

**c. Resolve** (your reasoning), with communication-catalog.md § 3:
- match each target hint to a component (project path, assembly or exe name, the component
  that exposes the endpoint, contract or ProgID) or to a **resource** (database, file share,
  queue, shared config, scheduler, cache, report server, external system);
- a database or share used by several components links them: record every writer and
  every reader;
- a hint that clearly points outside the repository (vendor URL, licensed DLL) is an
  external system;
- anything else unresolved gets the retries in § Never loop, never stop. Still unresolved →
  a question (Kind Integration), and the link stays in the tables with the target
  `? <hint>`.

**d. Compute** from the resolved links:
- **Graph:** components and resources as nodes. An arrow always goes from the one that
  depends to the one it depends on, labelled with the mechanism (`db write`, `cli`, …).
- **Tree:** for each top-level component (one that no other component depends on), what it
  pulls in, level by level.
- **Layers:** only component-to-component links count. Layer 0 depends on no other
  component. Layer n depends only on layers below n.
- **Cycles:** components that depend on each other, directly or through others. List each
  one; its members share one layer, the highest any of them would get.
- **Hotspots:** resources written by one component and read by another, and components
  used by 3 or more others.

**e. Write:**
- each component file: § Depends on, § Used by, § Resources used, the Layer, and any new
  Modernization signals and Open questions;
- `docs/system.md`: every section, including § Architecture in brief, and Dependencies ✓ in
  § Discovery progress;
- `docs/questions.md`: the new questions.

**f. Chat summary** (not saved; at most 25 lines):
- the architecture in 4–6 plain sentences;
- counts: components by kind, links by mechanism group, resources, layers, cycles;
- the H-risk questions (at most 5) and the total open;
- what's next: "`/mod-discover` continues with <what>", or "Discovery complete:
  `/mod-legacy-report` explains the whole system".

## Never loop, never stop

- Each unknown gets up to **three** retries, automatically. Never ask the developer whether
  to retry. Each retry is a new scout brief that changes the approach: narrower folders,
  other patterns, the other side of the link. Unknowns that share a folder can share one
  retry brief. Still unknown after the third retry → a question with a working assumption →
  the next item.
- Retries count toward the run's scout calls. If the run's calls run out while an unknown
  still has retries left, note it and its retries left in § Discovery progress; the next
  run picks it up.
- A scout report with something under "Not covered" gets one follow-up brief. What still
  doesn't fit waits for the next run.
- About 15 scout calls per run at most. When you reach that, write what you have, update
  § Discovery progress, and end with the chat summary.
- Never ask the developer, and never wait for an answer.

## Formats

**Questions:** add rows to `docs/questions.md` in the format at the top of that file. The
next ID follows the highest `Q-###` there.

**System:** keep the sections and table columns of `docs/system.md`. Mermaid conventions:
`orders_mvc[orders-mvc]` for a component, `orders_db[(Orders DB)]` for a database,
`exports_share{{\\srv\exports}}` for any other resource, and `a -->|mechanism| b` for a link.

**Component file** `docs/components/<component>.md`. Every value cites its evidence; leave
out a row that has nothing to say:

```markdown
# <component>

**Kind:** <WinForms app | WPF app | ASP.NET MVC app | class library | Access VBA app | …> · **Layer:** <n | — > · **Updated:** YYYY-MM-DD

## Identity

| Field | Value | Evidence |
|---|---|---|
| Path | `legacy/…` | |
| Solution | <name.sln or —> | |
| Output | <assembly, exe or file name> | |
| Entry point | <Program.Main, App.xaml, Global.asax, AutoExec macro, …> | |
| Exposes | <routes, service contracts, COM ProgIDs, Windows service name, callable macros> | |
| Size | <files · forms / windows / controllers / views · approx. lines> | |
| Tests | <test project(s) or "none found"> | |

## Technology

| Field | Value | Evidence |
|---|---|---|
| Language | | |
| Framework + version | | |
| Project format / build | | |
| Output type | | |
| Platform target | | |
| Hosting / runtime | | |
| Data access | | |
| Notable libraries | <name version, …> | |
| Config | <files; keys only, never values> | |
| Readability | full · partial · binary | |

## Depends on

| To | Mechanism | Detail | Evidence |
|---|---|---|---|

## Used by

| From | Mechanism | Detail | Evidence |
|---|---|---|---|

## Resources used

| Resource | Kind | Read / write | Detail | Evidence |
|---|---|---|---|---|

## Modernization signals

- <a fact with evidence: out-of-support framework, COM or Office interop, 32-bit only,
  binary source, no tests, hard-coded paths, …>

## Open questions

- Q-### <the question in a few words>
```
