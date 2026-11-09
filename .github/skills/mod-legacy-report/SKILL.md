---
name: mod-legacy-report
description: "Any time after /mod-discover has started. Explains the legacy system in detail, with Mermaid diagrams, to a developer who doesn't know it: what it is for, the projects and their dependency tree, technologies and their support status, data, integrations and the boundary, features and flows, risks, and where to start - then what analysis is still pending. With no argument it writes the whole picture to docs/legacy-report.md; a topic, a component, a flow or a question is answered in chat. Reads docs/ only."
argument-hint: "nothing = full report · summary · projects · tech · data · integrations · features · risks · start · pending · <component> · flow \"<process>\" · \"<question>\""
disable-model-invocation: true
---

# /mod-legacy-report — Explain the legacy system

**Requires agent: `Guide`.** Under another agent, stop and ask the developer to switch.

Explain the system to a developer who doesn't know it, from what `docs/` records. Never ask
the developer anything, never read `legacy/` and never call a Scout: what the records don't
hold goes under Pending analysis. (Outside this command, the developer can ask you to look
in the code.)

If `docs/system.md § Components` is empty, say "Nothing is recorded yet: run `/mod-discover`
first" and stop.

## What to report

Values in `<ANGLE BRACKETS>` come from the text after the command. Plain words map to the
closest row ("explain the database" → `data`, "briefly" → `summary`). Text that is neither a
topic nor a component name is a question.

| Argument | What you give | Where |
|---|---|---|
| nothing or `all` | Sections 1–12 | `docs/legacy-report.md`, then the chat summary |
| `summary` | Sections 1–3 and the top 5 pending items, about one screen | chat |
| `projects` | Section 4 | chat |
| `tech` | Section 5 | chat |
| `data` | Section 6 | chat |
| `integrations` | Sections 3 and 7 | chat |
| `features` | Section 8 | chat |
| `risks` | Section 9 | chat |
| `start` | Section 10 | chat |
| `pending` | Section 11, every row | chat |
| `<component>` | The component profile (below) | chat |
| `flow "<process>"` | The flow (below) | chat |
| `"<question>"` | The answer with its evidence, a diagram if it helps, and the sections that hold more | chat |

A chat answer ends with the pending items that affect it (at most 3) and links to the
component files it used.

## Read

- `docs/system.md`, all of it, and the OPEN rows of `docs/questions.md`.
- The component files a section needs. For the full report with more than about 15
  components, search across `docs/components/` for the rows you need (`| Entry point |`,
  `| Framework + version |`, `| Tests |`, `| Readability |`, `## Modernization signals`)
  instead of opening every file.
- [diagrams.md](diagrams.md) before you draw.

## Rules

- **Records only.** Every fact comes from `docs/` and keeps its evidence: the recorded
  `path:line`, or a link to the component file that holds it. A fact the records don't hold
  is never guessed; it becomes a pending row.
- **Label what you reason.** Purpose, actors, features, flows, support status and risks are
  your reading of the records: mark each `(inferred: <from what>)`. Support status comes
  from the vendor's lifecycle as you know it, for example "out of support since 2022-04
  (inferred: Microsoft lifecycle; verify)".
- **Rests on a question:** a statement that depends on an OPEN question ends with
  `(rests on Q-###)`.
- **Explain, then show.** Each section opens with 2–4 plain sentences on what it means for
  the developer, then the table or diagram, then what to notice in it. For a technology the
  developer may not know (VB6, Access VBA, WCF, Web Forms, SSIS…), add one line on what it
  is and how to read its code.
- **Big systems:** no table over about 40 rows. Show counts, the top items and a link to
  `system.md`.

## The full report

`docs/legacy-report.md` is generated: write it whole in one edit at the end of the run,
replacing the previous one. It starts with:

```markdown
# <system name, or "The legacy system"> — legacy report

**Generated:** YYYY-MM-DD by `/mod-legacy-report` from `docs/` (<n> of <m> components fully discovered). Regenerate it any time; don't edit it by hand.
```

1. **At a glance:** 5–8 plain bullets: what kind of system it is, its size, its main
   technologies, and the 2–3 things that will matter most when modernizing it. Then one
   numbers line: components by kind · resources by kind · links by mechanism group · layers ·
   cycles · OPEN questions by risk (H/M/L).
2. **What it is for:** its purpose, who uses it and its main capabilities, inferred from
   component names, entry points, what the components expose and the resources they touch.
3. **The system in context:** the context diagram, then how work moves through the system
   in 3–6 sentences.
4. **Projects and the dependency tree:**
   - the components table: component · kind · technology and version · layer · entry point
     · tests · readability · suggested approach;
   - the layered dependency graph, and the text tree from `system.md`;
   - the most used components (fan-in) and the ones that depend on the most (fan-out);
   - each cycle in plain words: its members, and why it matters.
5. **Technologies and support status:**
   - one row per technology and version: used by · support status · what it means for the
     modernization; out of support first;
   - the support timeline when 3 or more technologies have a known end date;
   - the "how to read it" lines.
6. **Data:** each database and data store with its writers, readers and the tables or
   procedures recorded; the data diagram; shared writes (written by 2 or more components)
   as coexistence risks; what isn't recorded (schemas, volumes).
7. **Integrations and the boundary:** what lies outside the repository and how it's
   reached: external systems with direction; services and endpoints; queues; files and
   shares as producer → path → consumer; schedules and CLI launches; then the integration
   diagram.
8. **Features and flows:** capabilities per component (inferred from what it exposes, its
   entry points and its forms, views or controllers, and the file roles in § Files), as a mindmap when there are 3 or more
   components; then 1–3 key end-to-end flows as sequence diagrams, picked from chains that
   cross several components or resources (a scheduler starts an exe that reads a share and
   writes the database).
9. **Risks:**
   - the risk matrix: one row per component, a ✓ per signal: out of support · no tests ·
     binary source · shared writes · in a cycle · unresolved links · H-risk question;
   - the top 5 risks in plain words, each with why it matters and its evidence.
10. **Where a developer should start:**
    - a reading path of 4–6 steps, for example `system.md` → the main app's entry point
      (`path`) → the most used library → a hotspot;
    - what you need to build and run it (frameworks, tools, platform), and what isn't
      recorded;
    - the tricky areas, and why;
    - the first components to study, and why.
11. **Pending analysis:** below.
12. **Sources:** links to `system.md`, every component file and `questions.md`.

**Chat summary** after writing (at most 15 lines): the link to the file, the architecture in
3–5 sentences, the numbers line, the top 3 risks, the top 3 pending items, and "Open it in
Markdown preview (Ctrl+Shift+V) to see the diagrams".

## Component profile

For `<component>`, from its file and the rows of `system.md` that name it:
- what it is and what it's for, its kind, its technology and support status;
- its entry points and what it exposes;
- the neighbourhood diagram: what it depends on, what uses it, and its resources;
- the data and files it reads and writes;
- its layer, any cycle it's in, its modernization signals and its open questions;
- its suggested approach and why, and its logic-heavy files (§ Suggested approach, § Files);
- its flows and business rules, when it has deep-dives (§ Deep-dives);
- where to start reading its code.

## Flow

For `flow "<process>"`, a business or data flow in plain words ("order import", "month-end
export"):
- find what's involved: search the records for the process words in component names,
  resources, what the components expose and their entry points;
- draw a sequence diagram from the recorded links, trigger first. The whole flow is
  inferred: say so once above the diagram;
- a step the records don't show becomes a `? <step>` note in the diagram and a pending row;
- nothing matches → say so and list the 3 closest components or resources.

## Pending analysis

From the records only. One row per item: what · what it weakens · how to close it. H-risk
first.

| Check | Found in | Close with |
|---|---|---|
| Components without Technology ✓ or Dependencies ✓, or with retries left | `system.md § Discovery progress` | `/mod-discover` |
| Components without a deep pass (Deep not ✓) | `system.md § Discovery progress` | `/mod-discover-comp` |
| Binary sources (Readability `binary`) | component files | export the text under `legacy/`, then `/mod-discover <component>` |
| Unresolved links (target `? <hint>`) | `system.md § Dependencies` | the question that names it |
| OPEN questions | `questions.md` | answer them to the Guide in chat |
| What discovery doesn't record: business rules, data schemas, screens, runtime behaviour | — | `/mod-deepdive <component>` (business rules, flow by flow) · `/mod-discover-comp <component> "<what>"` |

The last row explains why features and flows are inferred. Always include it.
