# Screen step

For a screen's step (`S01-B1`, `S01-U1`) from its plan in `screens/`. The screen is rebuilt in
the target UI technology so the user sees and does the same things; the backend pieces go
where the plan's split says. The sections below add to the same sections of
[SKILL.md](SKILL.md).

## Picture (§ 2)

The screen map: the component's screens and how they open each other (each screen plan's
"Opens · opened from"), each with its steps and status: built `built`, building `building`
([status styles](../mod-modern-report/diagrams.md#status-styles)), the next screen `focus`,
another component's screens `outside`
([diagram rules](../mod-legacy-report/diagrams.md#rules-for-every-diagram)).

## Plan (§ 3)

- **A backend step (`B`):** the backend pieces the split says this screen builds itself, test
  first as in [flow-step.md](flow-step.md): the tests from the flow's `tdd.md` when there is
  one, otherwise from the legacy code, every expected value cited. Then the contract the
  screen calls (data shapes, endpoints or interfaces).
- **A screen step (`U`):** in the target UI technology, by the construct mapping in
  `target.md § 3`: every control in the inventory, with the same labels, data, formats,
  defaults, read-only and visibility rules, tab order and messages, except where the
  developer's instructions change the layout; keyboard access and a label for every input;
  the calls to the contract.
- **Backend pieces built elsewhere** (a port step, a flow's build step) aren't built here: use
  them, or a fake of their contract until they're built (under **Waits for**).
- **Tests,** with the UI test framework `skeleton.md` gives (a component test, a view-model
  test): each control with its label and data, the show, hide and enable rules, the defaults,
  the UI validation and messages, and where each action leads.
- **The developer's instructions:** one that changes the architecture goes to `/mod-target`;
  one that changes or drops a business rule is a decision ([SKILL.md § 7](SKILL.md#7-changes-and-problems-at-any-point)).

## Build (§ 4)

Rebuild the screen the target's own way: never translate UI code line by line, and never
leave a business rule only in the UI. Comment it in its markup's own syntax (`@* *@`,
`<!-- -->`), as [modern-code.instructions.md](../../instructions/modern-code.instructions.md)
says: which legacy screen it rebuilds, and which backend piece each action calls.

## Review (§ 5)

- the split as built: each legacy piece, and where it went;
- **the side-by-side check** from the screen plan, with the run command from `skeleton.md`.

Ask a second question in the same `askQuestions` call (header "Side by side"): **Checked, it
matches** · **Not checked yet**. A difference the developer finds is a fix (§ 7). The record's
Checked line says which.
