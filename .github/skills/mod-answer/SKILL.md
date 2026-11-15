---
name: mod-answer
description: "Any time. Answer the question bank whenever you can; the work never waits for it. With nothing after the command it lists the open questions, grouped by who can answer them, ready to answer now or to send on. Give an answer by its ID or in plain words (a pasted e-mail or meeting notes work too): Copilot finds the question, reasons over the answer, and explains what it means, what it changes (the rules, plans, tests and built code that rested on the working assumption) and what it suggests. It records the answer only after you accept: in the question bank, in every file that rested on it, and the follow-up work for the Scaffolder. archive keeps the question bank small as the work goes on: it backs up docs/ first, then moves the answered and closed questions that nothing rests on any more, word for word, to docs/archive/questions.md, and checks that every ID is still found."
argument-hint: "nothing = the open questions · <component> · ask <Business | Ops | DBA | Vendor | Developer> · risk H · Q-### · Q-###: <answer> [(source, date)] · archive · or the answer in plain words"
disable-model-invocation: true
---

# /mod-answer — Answer questions, and see what they change

**Requires agent: `Guide`.** Under another agent, stop and ask the developer to switch.

Every question in `docs/questions.md` has a working assumption the work goes on with. An
answer replaces it, and what rested on that assumption may change: a rule, a test's expected
value, a design line, a plan step, code already built. So an answer is never just filed: you
work out what it means and what it changes, show it, and **record nothing until the developer
accepts**.

The answers come from the developer, or from the people they asked. You may ask the developer
to clarify their answer; you still never ask them about the legacy system itself.

Values in `<ANGLE BRACKETS>` come from the text after the command.

| Argument | What you do |
|---|---|
| nothing | § 1 The open questions |
| `<component>` · `ask <who>` · `risk H` · `kind <kind>` | § 1, only the questions that match |
| `Q-###` | That question in full: its context, its working assumption, and everything that rests on it (§ 2d), with no answer yet. Not in `questions.md`: look in `docs/archive/questions.md` |
| `Q-###: <answer> [(source, date)]`, one or more | § 2 for each |
| an answer in plain words, or a pasted e-mail or meeting notes | § 2: find the questions it answers first |
| `close Q-###: <why>` | § 2 for a question that's no longer relevant (CLOSED) |
| `archive` | § 5: back up `docs/`, then move the settled questions to the archive |

**Read by search,** never the whole bank: the OPEN rows (`| OPEN |`), the rows of one
component, or one ID. An ID that isn't in `questions.md` is in `docs/archive/questions.md`.
A new answer to an archived question (it's reopened) moves its row back to `questions.md`
first, then § 2 as usual.

## 1. The open questions

Search the OPEN rows of `docs/questions.md`, then:
- **Duplicates:** questions that ask the same thing. Suggest closing all but one ("duplicate
  of Q-###"), with their components and links merged.
- **Settled since:** a question that later records now settle (a deep-dive found the caller,
  the accepted target decided it). Show the evidence, and offer it as an answer to accept.
- **What rests on each:** count the places that cite it (§ 2d): rules, tests, plan steps,
  built code.

Show, in chat:
- the counts: OPEN questions by risk, and by who can answer them; and, when `questions.md`
  holds 20 or more ANSWERED or CLOSED rows, "n answered or closed: `/mod-answer archive`
  checks which can move";
- the questions grouped by **Ask**: the developer's first (they can answer now), then
  Business, Ops, DBA and Vendor. Within a group, H risk first, then those the most work rests
  on. For each: the ID, the question in plain words, why it matters, the working assumption,
  what rests on it, and its components;
- for the other groups, the questions ready to send: plain words, no code, one block per
  group, so the developer can copy it into a message or a meeting.

Then ask with `askQuestions` (header "Answer now", multi-select): up to 8 questions (the
developer's first, then H risk), and **None now**. For the picked ones, the developer types
the answers. Without the tool, ask "Reply with `Q-###: <answer>` for the ones you can answer",
and stop.

## 2. Work out what an answer means (no changes yet)

**a. Match it.** An answer with an ID goes to that question. Plain words, an e-mail or meeting
notes: find each answer in them, and match it to its OPEN question by meaning. Show each match;
when one is unsure, ask the developer. An answer that matches no question: say so. If it
decides something about the new system, offer to record it as a decision in `docs/modern.md`.

**b. The source.** Who answered, and when: `Business: <name>, 2026-11-10`, or "developer" and
today when nothing is said.

**c. What it means.** In the question's own terms:
- **confirms** the working assumption, **refines** it, or **contradicts** it;
- **partly answers** it: what's settled now and what's still open;
- **differs from the code:** an answer that says what the business wants, when the code does
  something else (`Pricing.cs:41` gives 5%, the answer says 10%). That's not a wrong answer:
  either the new system will differ from legacy (a decision), or legacy has a defect. Say
  which it looks like, and let the developer confirm;
- **raises new questions:** each becomes a question, with its working assumption.

**d. What rests on it.** Search for `Q-###`, and for the working assumption's words where a
tag is missing, in:
- `docs/questions.md` (the row itself);
- each affected `component.md`: § Open questions, and Rests on in § Suggested approach;
- the plans in `docs/components/<component>/`: `deepdive.md`, `port.md`, each flow's
  `logic.md`, `sdd.md` and `tdd.md` (rules, tests and steps that end with `(rests on
  Q-###)`), and the screen plans;
- `docs/target.md`, `docs/system.md` and `docs/modern.md`;
- `modern/`, read-only: the markers in the code that name the question (`TODO(Q-###)`,
  `RECHECK(Q-###)`, `BLOCKED(Q-###)`).

**e. The impact:** for each place, what changes:
- **confirmed:** the `(rests on Q-###)` tag goes; nothing else changes;
- **refined or contradicted:** the statement changes; show old → new (a rule's exact details,
  a test's expected value, a design line, a step);
- **already built:** a step marked done, or a marker in the code, that rested on
  the old assumption: it needs a rework by the Scaffolder (`/mod-implement <component>`
  offers it as a follow-up);
- **the plan's shape changes** (a file moves another way, a flow or a screen is added):
  `/mod-deepdive <component> change "<what>"`;
- **the architecture changes:** `/mod-target <change>`.

Sum it up: "3 rules, 7 tests, 2 build steps (1 built), 1 screen plan".

**f. Suggestions,** the recommended one first (★), each with who does it and the command or
words: rework a step built on the old assumption; check another rule that uses the same
constant; close a duplicate; send a follow-up question to the right person.

Show it in chat, per answer (at most about 25 lines, the impact as a table):

```text
Q-031 · The discount for 10 or more items
Answer:      10%, not 5% (Business: J. Rao, 2026-11-10)
Means:       contradicts the working assumption (5%, as Pricing.cs:41 does): the new system
             will differ from legacy, a decision
Impact:      F02-R4 exact details · F02-T6, F02-T7 expected values · F02-B3 (built) · S02 message
Suggestions: ★ rework F02-B3 (Scaffolder: /mod-implement orders-core) · check F03-R2, which
             uses the same 5%
```

## 3. Accept or change

Ask with `askQuestions` (header "Answer", one question per answer, at most 4 per call):
- **★ Accept and record;**
- **Change something** (the developer says what: the match, the wording, the source, an
  impact): work it out again and show it;
- **Don't record.**

Without the tool, ask "Reply `accept`, or say what to change, or `skip`", and stop.

## 4. Record (only after Accept)

- **`docs/questions.md`:** Status ANSWERED, and the answer with its source and date. A partial
  answer stays OPEN: its working assumption becomes what's known now, with the source. A
  closed one: CLOSED, and why. New questions: new rows, after the highest of the IDs in the
  table and its **Highest archived ID:** line.
- **Each place in the impact:** the change as shown. Remove the `(rests on Q-###)` tags the
  answer settles.
- **A step already built** on the old assumption: add `· re-check (YYYY-MM-DD): Q-###
  answered` to its status (as [formats.md § Statuses](../mod-deepdive/formats.md#statuses)
  says), so `/mod-implement` offers its rework.
- **`component.md`:** remove the question from § Open questions, and add a line to § Notes:
  `- YYYY-MM-DD Q-### answered: <the answer> (source)`.
- **A decision** (the new system will differ from legacy): a row in `docs/modern.md § Target
  and decisions`, and a "May differ" row in the flow's `sdd.md § Behaviour parity` with the
  answer as its source.
- The reports aren't edited: they show the answer next time they're generated.

Then, in chat: what was recorded (files, counts), and the next steps, ★ first, each with the
agent to select and what to type: the Scaffolder's `/mod-implement <component>` for the
re-checks and `TODO` markers, the Guide's `/mod-deepdive <component> change "<what>"` or
`/mod-target <change>`, the questions still open for the same person, or nothing.

## 5. Archive settled questions (`archive`)

The question bank only grows: every command that logs a question adds rows, and answered ones
stay, while ten commands read it. Archiving moves the rows that nothing rests on any more,
word for word, to `docs/archive/questions.md`, so every command reads a smaller bank. It never
rewords, summarizes, deletes or renumbers anything, and **it changes nothing until a backup of
`docs/` is verified.**

**Only rows of `questions.md` move.** No other file in `docs/` is archived, ever:
- plan files and improvement plans are cited by path in code comments and in links;
- the decisions in `modern.md` are a live log: a later decision overrides `target.md`, and
  code comments point to it;
- `component.md § Notes` holds analysis that `/mod-implement` reads.

`/mod-compact` keeps those small another way: it condenses their settled detail in place,
never moving or deleting a file, and it runs this archive too, under the same backup.

### a. Check (changes nothing)

A row can move only when all three hold:
1. **Settled:** its Status is ANSWERED or CLOSED. A partly answered question is OPEN: it stays.
2. **Nothing rests on it any more:** search `docs/` and `modern/` (read-only) for the ID:
   - no `(rests on Q-###)` tag, and no Rests on line in a § Suggested approach;
   - no step status `re-check (…): Q-### answered` without a later `reworked` or `fixed`;
   - no `partial` step that names it;
   - no `TODO(Q-###)`, `RECHECK(Q-###)` or `BLOCKED(Q-###)` marker in `modern/`;
   - no improvement plan that isn't done or dropped listing it.
3. **No plan still to write needs it:** every component in its Component column has an
   accepted deep-dive plan (`deepdive.md` **Plan:** accepted), or is Keep or retired. A
   question that names no component stays.

Mentions that only refer to it don't stop it: a "Q-### answered" line in § Notes, a "May
differ" row in `sdd.md` whose source is the answer, a decision row, a code comment that names
it. They find it in the archive.

Show:
- `questions.md` now: its rows by status, and its lines;
- the rows that can move, by component, and the lines after;
- the answered and closed rows that stay, grouped by reason (rests on, re-check, marker, a
  plan still to write), each with what clears it;
- the backups already in `.backup/` (file search), oldest first.

Nothing can move: say so, and stop. Otherwise ask with `askQuestions` (header "Archive"):
★ **Back up, then archive** · **Not now**.

### b. Back up `docs/` (before anything changes)

You never run commands, so the developer makes the backup: a full copy of `docs/`, in one
command. Name it `docs-YYYY-MM-DD` (today), with `-2`, `-3`… when that folder already exists
(file search in `.backup/`). Show it in a copy-ready block:

```powershell
Set-Location "<workspace>"; New-Item -ItemType Directory -Force .backup | Out-Null; Copy-Item -Path docs -Destination ".backup/docs-YYYY-MM-DD" -Recurse
```

Then ask (header "Backup"): ★ **Done, check it** · **Copilot: back up only the files this
changes** · **Cancel**.
- **Done, check it:** verify before going on: the folder exists, it holds as many files as
  `docs/` (file search on both), and its `questions.md` has as many `| Q-` rows as the live
  one. Anything off: say what, and ask again. **Never archive without a verified backup.**
- **Copilot: back up only the files this changes:** write
  `.backup/docs-YYYY-MM-DD/questions.md`, and `.backup/docs-YYYY-MM-DD/archive/questions.md`
  when it exists, word for word, and verify their row counts the same way.

`.backup/` is outside `docs/` and out of git (`.gitignore`), and shared with `/mod-compact`:
no command reads or searches it, except to verify a backup and to restore.

### c. Archive

1. **Note the IDs before:** every `Q-###` in `questions.md` and in `archive/questions.md`.
2. **Append** the rows to `docs/archive/questions.md`, word for word, in ID order, under
   `## Archived YYYY-MM-DD` with the table's header row.
3. **Remove** the same rows from `questions.md`.
4. **Update** its **Highest archived ID:** line to the highest ID now in the archive.

### d. Verify, and restore if anything's off

- the IDs across `questions.md` and the archive are exactly the IDs before: none lost, none
  twice;
- every `Q-###` cited in `docs/` and `modern/` is found in exactly one of the two files;
- the moved rows match the rows in the backup, character for character.

Anything off: restore `questions.md` and `archive/questions.md` from the backup, say what
failed, and stop.

### e. Report

In chat: the rows moved (by component), `questions.md` lines before → after, the backup's
path, and how to restore it, should it ever be needed:

```powershell
Set-Location "<workspace>"; Copy-Item -Path ".backup/docs-YYYY-MM-DD/*" -Destination docs -Recurse -Force
```

Old backups are the developer's to delete: suggest keeping the last 3.

## Unknowns become questions

The developer is here and answering, so an unclear answer is a question to them, not to the
question bank. What the records can't settle while working out the impact follows the
standard rule: three tries, automatically (search by the ID, by the working assumption's
words, through the component's plans), then the case below, and on to the next step.

| Unknown | What happens |
|---|---|
| An answer that only settles part of the question | the question stays OPEN; its working assumption becomes what's known now, with the source |
| An answer that raises something new | a new question in `docs/questions.md`, with its working assumption (Kind and Ask by topic) |
| A place that rests on the question, whose new wording the answer doesn't settle | mark it `re-check: Q-### answered`, and say what's unclear |
| An answer that differs from what the code does | not an unknown: a decision, or a legacy defect; ask the developer which (§ 2c) |
| An answer whose question can't be found | ask the developer; if it's new knowledge about the new system, offer to record it as a decision |
