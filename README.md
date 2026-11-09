# Copilot Modernization Kit (v5)

A VS Code + GitHub Copilot workspace for understanding a legacy system you may not know, then
modernizing it piece by piece.

## Agents

| Agent | Role |
|---|---|
| **Guide** | Leads. Decides what to look at, reasons over what's found, explains it, and keeps `docs/` |
| **Scout** | Reads the legacy code fast and cheaply for the Guide, and reports facts with citations |
| **Scaffolder** | Builds the new system, only inside `modern/` |

## Commands

| Command | Agent | What it does |
|---|---|---|
| `/mod-discover` | Guide | Finds every component and its technology, then every dependency between them, and writes `docs/`. Run it again to continue a large repo; `/mod-discover <component>` redoes one component |
| `/mod-discover-comp` | Guide | Deep discovery, one component at a time: reads every file, finds what `/mod-discover` missed (wrapped or runtime-built links, DFS and shares, queues, external executables and CLI calls, dynamic SQL), maps where the logic lives and what blocks a port, and suggests an approach: Port, Rewrite, Split or Keep. Nothing continues with the next component; `/mod-discover-comp <component> "<what>"` runs any focused analysis you ask for |
| `/mod-target` | Guide | You give the target stack; it asks only the stack questions it needs (clickable, never picks for you) and writes a feasibility plan of at most 150 lines in `docs/target.md`: goals and constraints, legacy to target per layer, construct mapping, the target structure for the Scaffolder, port decisions, a verdict and complexity per component, and capability gaps. Then it asks you to accept or change it. Once accepted, it shows the proposed modern solution (projects, references, where each legacy component goes) to accept or change, and gives clear next-step options. Needed before `/mod-deepdive`. `/mod-target <change request>` revises it |
| `/mod-modern-skeleton` | Scaffolder | Builds the solution skeleton in `modern/` from the accepted architecture, with you: names and scope, then every implementation detail (package manager, test frameworks, linters, build settings), each suggested with a recommendation for you to choose. Plans first, acts after you choose Run plan (generators, projects, test projects, references, entry-point stubs, then restore, build and test), and records the skeleton as built in `docs/skeleton.md`. Never changes the architecture; ask for changes at any point |
| `/mod-deepdive` | Guide | Plans a component's migration: maps its files and numbered flows, then decides how each file moves (port the code, rebuild its logic through a flow, rebuild the screen, or keep it) and the order of work, for you to accept or change. Then it writes the plans that apply, with intense care for the legacy behaviour: `port.md` (port steps, unit tests, the runtime differences that could change behaviour), a numbered folder per rebuilt flow (`logic.md` with every method on its path read whole, `sdd.md`, `tdd.md` with the build steps), and a plan per screen (its inventory and UI/backend split). `/mod-deepdive <component> change "<what>"` re-plans |
| `/mod-implement` | Scaffolder | Builds a component in `modern/`, step by step, from its accepted plan. It picks the next step from the order of work, whatever its kind (port a file, build a flow test first, rebuild a screen), says why, plans it, builds it after you choose Run plan, and asks you to accept the changes or ask for more; only what you accept is recorded. At any point, ask in plain words: change this step, rework or revert an accepted one, change a behaviour, fix what's wrong, or re-plan. When it's stuck, it shows what it tried and lets you choose the way out |
| `/mod-legacy-report` | Guide | Explains the system in detail, with diagrams: what it's for, projects and the dependency tree, technologies and support status, data, integrations, features and flows, risks, where to start, and what's still pending. With no argument it writes `docs/reports/legacy-report.md`; a topic (`summary`, `tech`, `data`…), a component, `flow "<process>"` or a question is answered in chat |
| `/mod-modern-report` | Guide | Explains the migration in detail, with diagrams: what the new system is for, its target, the plan of execution, progress per component and wave, how old and new run side by side, risks, what's pending and the next steps. Before anything is planned it suggests a plan from the legacy layers. With no argument it writes `docs/reports/modern-report.md`; a topic (`target`, `plan`, `progress`…), a component, `wave <n>`, `flow "<process>"` or a question is answered in chat |

## Start

```powershell
git clone <kit url> <project>-workspace
cd <project>-workspace
git clone <legacy repo url> legacy
git clone <new-code repo url> modern     # or: mkdir modern
code .
```

In Copilot Chat, select **Guide** and type `/mod-discover`. It doesn't ask you
anything: approve its edits to `docs/` as they come.

Then run `/mod-discover-comp` until every component has a suggested approach. Each run
reads the next components file by file.

Run `/mod-legacy-report` and open `docs/reports/legacy-report.md` in Markdown preview
(Ctrl+Shift+V) to see the whole system with its diagrams. It works any time, even while
discovery is still going.

When you're ready to modernize, run `/mod-target <your target stack>`. It asks only the
stack questions it needs, writes the feasibility plan in `docs/target.md`, and asks you
to accept it or change it. Then it shows the modern solution it proposes, for you to
accept or change, and the options for the next step.

Then select **Scaffolder** and run `/mod-modern-skeleton`. It settles the names and the
implementation details with you (it suggests, you choose), shows its plan, and builds the
skeleton in `modern/` once you choose Run plan. VS Code asks you to approve every command
and edit. The **Record in docs** button then has the Guide write `docs/skeleton.md`.

Then plan each component with `/mod-deepdive <component>`. It maps the component, decides how
each file moves (ported, rebuilt through a flow, or a rebuilt screen) and the order of work,
and asks you to accept the plan or change it. Then it writes the plans that apply, reading
every method on each flow's path so the new system keeps the legacy behaviour exactly.

Then select **Scaffolder** and run `/mod-implement <component>`. It picks the next step
from the order of work and says why; you approve its plan, it builds the step with its
tests, and you accept the changes or ask for more. Ask for a change, a fix or a re-plan in
plain words at any point. **Record in docs** has the Guide record only what you accepted.

`/mod-modern-report` shows the migration and its progress at any time. Tell the Guide
what's done in plain words ("orders-core is built, all tests pass") and it records it in
`docs/modern.md`.

## What you get

- `docs/system.md`: the solution on one page. The architecture in plain words, the
  components and their technologies, shared resources (databases, shares, queues), every
  dependency, a dependency graph and tree, and layers for slicing the modernization.
- `docs/components/<component>/`: everything about one component, so you can pick any one
  and work on it alone. `component.md` is what discovery found. After `/mod-discover-comp` it also holds its files, where
  the logic lives, and a suggested approach (Port, Rewrite, Split or Keep) with its
  reasons. Once ported, it says how other components use its modern part.
- `docs/questions.md`: everything the code couldn't tell, each with a working assumption.
  Answer them whenever you can; the work never waits.
- `docs/reports/legacy-report.md`: the system explained for a newcomer, with Mermaid diagrams,
  from `/mod-legacy-report`.
- `docs/target.md`: the target stack and feasibility plan you accepted, from `/mod-target`.
- `docs/skeleton.md`: the modern solution as built, with its implementation choices and the
  commands to build, test and run it.
- `docs/modern.md`: the new system: target and decisions, the plan in waves, and the
  progress of each component.
- `docs/reports/modern-report.md`: the migration explained, with progress, a migration map and
  the next steps, from `/mod-modern-report`.
- `docs/components/<component>/`: the migration plans, from `/mod-deepdive`: `deepdive.md`
  (the map, how each file moves, the order of work), `port.md` (port steps and unit tests),
  `flows/01-<flow>/` (`logic.md`, `sdd.md`, `tdd.md`) and `screens/01-<screen>.md`, only
  the ones the component needs.

## Sources Copilot can't read

Copilot can't read Access binaries (`.accdb`, `.mdb`) or DLLs without source. Discovery still
lists them as components and logs a question explaining what to export. Export the text (for
example VBA modules and queries) anywhere under `legacy/`, then run `/mod-discover
<component>`.

## Layout

```text
<project>-workspace/
├── .github/      3 agents · skills (/mod-… commands) · instructions
├── docs/         system.md · questions.md · target.md · skeleton.md · modern.md · reports/ ·
│                 components/<component>/ (component.md · deepdive.md · port.md · flows/ · screens/)
├── legacy/       the legacy repo (separate Git repo; read-only for agents)
└── modern/       the new code (separate Git repo)
```
