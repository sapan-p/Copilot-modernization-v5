# Copilot Modernization Kit (v5)

A VS Code + GitHub Copilot workspace for understanding a legacy system you may not know, then
modernizing it piece by piece.

## Agents

| Agent | Role |
|---|---|
| **modernization-guide** | Leads. Decides what to look at, reasons over what's found, explains it, and keeps `docs/` |
| **code-scout** | Reads the legacy code fast and cheaply for the Guide, and reports facts with citations |
| **structure-scaffolder** | Builds the new system, only inside `modern/` |

## Commands

| Command | Agent | What it does |
|---|---|---|
| `/mod-discover` | modernization-guide | Finds every component and its technology, then every dependency between them, and writes `docs/`. Run it again to continue a large repo; `/mod-discover <component>` redoes one component |

## Start

```powershell
git clone <kit url> <project>-workspace
cd <project>-workspace
git clone <legacy repo url> legacy
git clone <new-code repo url> modern     # or: mkdir modern
code .
```

In Copilot Chat, select **modernization-guide** and type `/mod-discover`. It doesn't ask you
anything: approve its edits to `docs/` as they come.

## What you get

- `docs/system.md`: the solution on one page. The architecture in plain words, the
  components and their technologies, shared resources (databases, shares, queues), every
  dependency, a dependency graph and tree, and layers for slicing the modernization.
- `docs/components/<component>.md`: one self-contained file per component, so you can pick
  any one and work on it alone.
- `docs/questions.md`: everything the code couldn't tell, each with a working assumption.
  Answer them whenever you can; the work never waits.

## Sources Copilot can't read

Copilot can't read Access binaries (`.accdb`, `.mdb`) or DLLs without source. Discovery still
lists them as components and logs a question explaining what to export. Export the text (for
example VBA modules and queries) anywhere under `legacy/`, then run `/mod-discover
<component>`.

## Layout

```text
<project>-workspace/
├── .github/      3 agents · skills (/mod-… commands) · instructions
├── docs/         system.md · components/ · questions.md
├── legacy/       the legacy repo (separate Git repo; read-only for agents)
└── modern/       the new code (separate Git repo)
```
