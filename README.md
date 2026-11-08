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
| `/mod-legacy-report` | Guide | Explains the system in detail, with diagrams: what it's for, projects and the dependency tree, technologies and support status, data, integrations, features and flows, risks, where to start, and what's still pending. With no argument it writes `docs/legacy-report.md`; a topic (`summary`, `tech`, `data`…), a component, `flow "<process>"` or a question is answered in chat |
| `/mod-modern-report` | Guide | Explains the migration in detail, with diagrams: what the new system is for, its target, the plan of execution, progress per component and wave, how old and new run side by side, risks, what's pending and the next steps. Before anything is planned it suggests a plan from the legacy layers. With no argument it writes `docs/modern-report.md`; a topic (`target`, `plan`, `progress`…), a component, `wave <n>`, `flow "<process>"` or a question is answered in chat |

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

Then run `/mod-legacy-report` and open `docs/legacy-report.md` in Markdown preview
(Ctrl+Shift+V) to see the whole system with its diagrams. It works any time, even while
discovery is still going.

When you're ready to modernize, run `/mod-modern-report`: with nothing planned yet, it
suggests a plan and lists the decisions to make. Tell the Guide your decisions in plain
words ("the UI will be Blazor Server", "use the suggested plan", "orders-core is built,
all tests pass") and it records them in `docs/modern.md`. Run the report again whenever
you want to see the progress.

## What you get

- `docs/system.md`: the solution on one page. The architecture in plain words, the
  components and their technologies, shared resources (databases, shares, queues), every
  dependency, a dependency graph and tree, and layers for slicing the modernization.
- `docs/components/<component>.md`: one self-contained file per component, so you can pick
  any one and work on it alone.
- `docs/questions.md`: everything the code couldn't tell, each with a working assumption.
  Answer them whenever you can; the work never waits.
- `docs/legacy-report.md`: the system explained for a newcomer, with Mermaid diagrams,
  from `/mod-legacy-report`.
- `docs/modern.md`: the new system: target and decisions, the plan in waves, and the
  progress of each component.
- `docs/modern-report.md`: the migration explained, with progress, a migration map and
  the next steps, from `/mod-modern-report`.

## Sources Copilot can't read

Copilot can't read Access binaries (`.accdb`, `.mdb`) or DLLs without source. Discovery still
lists them as components and logs a question explaining what to export. Export the text (for
example VBA modules and queries) anywhere under `legacy/`, then run `/mod-discover
<component>`.

## Layout

```text
<project>-workspace/
├── .github/      3 agents · skills (/mod-… commands) · instructions
├── docs/         system.md · components/ · questions.md · modern.md · 2 reports
├── legacy/       the legacy repo (separate Git repo; read-only for agents)
└── modern/       the new code (separate Git repo)
```
