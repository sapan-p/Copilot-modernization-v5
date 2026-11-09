---
name: mod-track
description: "Any time, and at the start of every session. Tracks the whole migration from the records: which stage each component is in, what's in progress or paused, what needs attention, what's blocked and by what, and the next action for each, with who does it and exactly what to type. Ask for the board, one component, or just the next thing to do. Working on several components? Pause one and switch to another: Copilot shows where the work stopped, records it once you accept, and takes you to the next task; picking it up later starts exactly there."
argument-hint: "nothing = the board · <component> · next · pause [<component>] [\"note\"] · switch <component> · how"
disable-model-invocation: true
---

# /mod-track — Where every component stands, and what's next

**Requires agent: `Guide`.** Under another agent, stop and ask the developer to switch.

This is where the developer steers, day to day: a short board built from the records, never a
guess. (`/mod-modern-report` explains the whole migration in depth, for others.) Read `docs/`,
and check `modern/` with file searches only: never call a Scout, never read `legacy/`, never
run anything. The only thing you write is a pause (§ 5), after the developer accepts it.

Values in `<ANGLE BRACKETS>` come from the text after the command. Plain words map to the
closest row: "where are we" → the board; "what should I do now" → `next`; "stop here, I'll do
orders-web" → `switch orders-web`.

| Argument | What you do |
|---|---|
| nothing | § 2 The board |
| `<component>` | § 3 One component |
| `next` | § 4 The next action, only |
| `pause [<component>] ["<note>"]` | § 5 Pause |
| `switch <component>` (or "resume") | § 5 Pause what's in this chat, then § 3 for that component |
| `how` | § 6 How to keep track |

## Read

- `docs/system.md`: § Components, § Dependencies, § Discovery progress.
- `docs/target.md` (its status, its Solution, the verdicts in § 6) and `docs/skeleton.md`
  (its status).
- `docs/modern.md`: § Plan (the waves), § Progress, § Work in progress, and § Target and
  decisions.
- Each component's folder: `component.md` (§ Files, § Suggested approach, § In the modern
  solution), and `deepdive.md` (**Plan:**, § Order of work and its statuses, the state of its
  plan files).
- The OPEN rows of `docs/questions.md`, H risk by component.

With more than about 15 components, search across `docs/components/` for the lines you need
(`**Plan:**`, the § Order of work rows) rather than reading every file.

**Check against `modern/`** (file search only): a component's project in `modern/` the
records show as not started; the modern files of a step not marked done (unrecorded work);
and the markers in each component's code, counted by kind (search `\b(TODO|RECHECK|BLOCKED|WAITS)\(`).

## 1. Stages and next actions

`/mod-modern-report` uses these rules too. The migration first passes three gates: discovery
(every component found: `system.md § Discovery progress`), the target (`target.md`
ACCEPTED, and its Solution accepted) and the skeleton (`skeleton.md` BUILT). Each component
then moves through its stages:

| Stage | The records show | Next action |
|---|---|---|
| **found** | a row in `system.md`, and its `component.md` | Guide: `/mod-discover-comp <component>` |
| **analysed** | `component.md` § Files and § Suggested approach | Guide: `/mod-deepdive <component>` (after the target gate) |
| **planning** | `deepdive.md`, with the plan not accepted or plans still being written | Guide: `/mod-deepdive <component>`: accept the plan, or it carries on writing the plans |
| **ready to build** | the plan accepted, and nothing built yet | Scaffolder: `/mod-implement <component>` (after the skeleton gate) |
| **building** | some items of the order of work done | Scaffolder: `/mod-implement <component>`, naming its next step |
| **built** | every item done, the tests pass (`modern.md § Progress`: built) | tell the Guide when it's live, with the evidence: "orders-core is live since …" |
| **live** | used instead of the legacy component | — |
| **kept** | stays legacy (`target.md § 6`, or a decision in `modern.md`) | — |

A component can also be:
- **paused:** it has a row in `modern.md § Work in progress`. Its next action is where it
  stopped;
- **blocked:** its next action waits for something: a gate; a component it depends on
  (`system.md § Dependencies`) that isn't built, live or kept and isn't reached through an
  adapter in `modern.md § Plan`; an item's Needs; an OPEN H-risk question; a parked
  (`partial`) step. Say by what, and what unblocks it;
- **in need of attention:** steps marked `re-check` or `partial`, markers in its code
  (`BLOCKED` and `RECHECK` first), unrecorded work in `modern/`, or records that don't
  match `modern/`.

**Ready:** not yet building, and not blocked.

**The next action overall,** first match wins:
1. discovery isn't finished → Guide: `/mod-discover`;
2. no accepted target or solution → Guide: `/mod-target <your stack>`, or accept the draft;
3. the skeleton isn't built → Scaffolder: `/mod-modern-skeleton`;
4. no plan in waves (`modern.md § Plan`) → agree one: `/mod-modern-report plan` suggests it;
5. a building or paused component that needs attention → that first;
6. building or paused components → finish them, the most recently worked on first;
7. ready components of the current wave (the lowest wave not done), lowest layer first →
   their next action;
8. the next wave's foundation work, then its ready components.

## 2. The board

Show, in chat:
- **the gates:** `Discovery ✓ 14 components · Target ✓ accepted 2026-11-09 · Skeleton ✓ built 2026-11-09`;
- **the progress line:** `▓▓▓░░░░░░░ 3 of 12 components built · 2 building · 1 paused · 4 ready · 2 blocked · 2 kept`.
  Count components, not effort; kept ones are left out of the total;
- **paused and in progress:** each with where it stopped and its next action;
- **needs attention:** re-checks, parked steps, unrecorded work, mismatches, and the OPEN
  H-risk questions that block something (→ `/mod-answer`);
- **the components:**

  | Component | Wave | Stage | Progress | Next action | Blocked by |
  |---|---|---|---|---|---|

  Progress: `▓▓▓░░ 6 of 10 items`, or the stage's own measure (`plans: 3 of 5 written`).
  Order: building and paused first, then ready (by wave and layer), planning, analysed,
  found, blocked, and last built, live and kept. Over about 25 components, the first 15 and
  a count per stage for the rest;
- **★ the next action** (§ 1): why, who does it, and exactly what to type.

Then ask with `askQuestions` (header "Next"): **★ the next action**, up to two others from the
board, and **Pause or switch**. A Guide action runs here. For the Scaffolder, show its
instruction and stop: only the developer can switch agents. Without the tool, number the
options and stop.

## 3. One component

- **its path,** with dates: `found 11-07 · analysed 11-08 · planned 11-09 · building 6 of 10 · built — · live —`;
- **what it becomes:** the project in `component.md § In the modern solution`, or in
  `target.md § 4`;
- **paused:** where it stopped, the files changed in `modern/` and not accepted, the note;
- **its order of work:** what's done, the next 3–5 steps, what the others wait for; the plans
  still being written;
- **needs attention:** re-checks, parked steps, and its OPEN questions (H first) with their
  working assumptions;
- **around it:** what it waits for, and what waits for it (§ Used by);
- **★ its next action:** who does it, and exactly what to type.

Then ask "Next" as in § 2.

## 4. Next

Only the ★ next action overall (§ 1), with its reason, and two alternatives. One screen at
most.

## 5. Pause and switch

Work in progress lives in two places: the records, and the chat doing the work. A pause makes
sure nothing is lost between them. It's recorded in `docs/modern.md § Work in progress`
(add the section after § Progress when an older workspace doesn't have it):

| Component | Stopped at | In `modern/`, not accepted | Next | Note | Since |
|---|---|---|---|---|---|

- **Stopped at:** the step and its state (`planned` · `built, not reviewed` · `under
  review`), or the plan file in progress (`flow 03, sdd.md`);
- **In `modern/`, not accepted:** the files a step changed that nobody accepted yet, or `—`;
- **Next:** who picks it up, and exactly what to type;
- **Note:** the developer's own words, or `—`.

**Where the work happens decides who pauses it:**
- **in the Scaffolder's chat** (`/mod-implement`): it pauses itself (its § 7). It finishes or
  leaves the current step, then shows its unrecorded records and a pause record. The
  developer records them all with **Record in docs**, and the Guide then shows the component
  switched to (§ 3);
- **in the Guide's chat** (`/mod-deepdive`, `/mod-answer`…): what's written is already in
  `docs/`, and the plan files say `in progress`; the pause adds the row;
- **with no chat to hand:** the row is built from the records and a file search of `modern/`,
  plus the developer's note.

Show the pause, then ask with `askQuestions` (header "Pause"): **★ Record the pause** ·
**Change the note** · **Don't pause**. Record it only after Accept.

The Scaffolder's pause record, recorded the same way:

```text
PAUSE RECORD · <component> · accepted YYYY-MM-DD
Stopped at:  <the step, and its state: planned · built, not reviewed · under review>
In modern/:  <the files changed and not accepted | —>
Next:        <who, and exactly what to type to pick it up>
Note:        <the developer's words | —>
Switch to:   <component | —>
```

**Switch:** after the pause, § 3 for the component switched to, with its next action.
Recommend a new chat for it ("Select the Scaffolder in a new chat and type `/mod-implement
<component>`"): one chat per component keeps the work apart.

**Resume:** the board and § 3 show the paused row first, and its Next starts exactly where it
stopped (`/mod-implement` finds the files not accepted and reviews them). The row goes when the
next build record of that component is recorded, or when the developer says the work is done
or dropped.

## 6. How to keep track

When the developer asks (`how`), or once, under the first board of a workspace:
1. Start each session with `/mod-track`: what's paused, what needs attention, what's next.
2. Build each component in its own chat. Choose **Record in docs** every few steps, and
   before you stop.
3. Switching? Say "pause" in the chat you're in, or `/mod-track switch <component>`, so where
   you stopped is recorded.
4. Answer questions as they come, with `/mod-answer`: an H-risk question can block a
   component.
5. Commit `modern/` after each recorded batch, so the code and the records match.
6. Tell the Guide when something goes live, with the evidence.
7. For others: `/mod-modern-report` writes the whole picture, with diagrams, to
   `docs/reports/modern-report.md`.

## Unknowns

`/mod-track` reads the records and finds nothing new about the legacy system, so it logs no
questions. When the records can't tell, say so, and name the action that fills the gap:

| Can't tell | What to say |
|---|---|
| a component's stage: records missing, or contradicting each other | the stage the records support, and the command or the words that correct them |
| whether a built component is live | "built; tell the Guide when it's live" |
| work in `modern/` the records don't name | "unrecorded: `/mod-implement <component>` reviews it" |
| where paused work stopped, with no chat and nothing in `modern/` | the last recorded step, and the developer's note |
