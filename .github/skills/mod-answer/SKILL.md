---
name: mod-answer
description: "Any time. Answer the question bank whenever you can; the work never waits for it. With nothing after the command it lists the open questions, grouped by who can answer them, ready to answer now or to send on. Give an answer by its ID or in plain words (a pasted e-mail or meeting notes work too): Copilot finds the question, reasons over the answer, and explains what it means, what it changes (the rules, plans, tests and built code that rested on the working assumption) and what it suggests. It records the answer only after you accept: in the question bank, in every file that rested on it, and the follow-up work for the Scaffolder."
argument-hint: "nothing = the open questions · <component> · ask <Business | Ops | DBA | Vendor | Developer> · risk H · Q-### · Q-###: <answer> [(source, date)] · or the answer in plain words"
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
| `Q-###` | That question in full: its context, its working assumption, and everything that rests on it (§ 2d), with no answer yet |
| `Q-###: <answer> [(source, date)]`, one or more | § 2 for each |
| an answer in plain words, or a pasted e-mail or meeting notes | § 2: find the questions it answers first |
| `close Q-###: <why>` | § 2 for a question that's no longer relevant (CLOSED) |

## 1. The open questions

Read the OPEN rows of `docs/questions.md`, then:
- **Duplicates:** questions that ask the same thing. Suggest closing all but one ("duplicate
  of Q-###"), with their components and links merged.
- **Settled since:** a question that later records now settle (a deep-dive found the caller,
  the accepted target decided it). Show the evidence, and offer it as an answer to accept.
- **What rests on each:** count the places that cite it (§ 2d): rules, tests, plan steps,
  built code.

Show, in chat:
- the counts: OPEN questions by risk, and by who can answer them;
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
  closed one: CLOSED, and why. New questions: new rows, after the highest `Q-###`.
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
