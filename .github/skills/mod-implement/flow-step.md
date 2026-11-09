# Flow step

For a flow's build step (`F02-B1`) from its `tdd.md`. Code that can't move as it is (VBA to C#,
logic in screen handlers) moves by its behaviour: the plan states each rule, the tests pin
down what legacy does, and new code is written to pass them. Test first, always. The sections
below add to the same sections of [SKILL.md](SKILL.md).

## Picture (§ 2)

The flow's logic map from `logic.md`, each node labelled with the build step that builds it
and its status (`Apply volume discount - R4<br/>B3 · to do`): done `built`, partial
`building` ([status styles](../mod-modern-report/diagrams.md#status-styles)), the next step
`focus` ([diagram rules](../mod-legacy-report/diagrams.md#rules-for-every-diagram)). Once per
flow in a chat; after that, its build steps as a table.

## Plan (§ 3)

- **What it builds:** the step's "What to build", its modern files (from `sdd.md § On the
  target`), and the rules it implements, each in business words with its exact details,
  checked against the legacy lines it cites. A rule that moves by port (`port P3` in
  `logic.md`) isn't built here: the code calls the ported code.
- **The tests, written first:**
  - **planned:** the step's tests in `tdd.md` (`T4`, `T5`…). Given → arrange (with the fakes
    in `tdd.md`), When → act, Then → assert, with the expected value exactly as `tdd.md`
    works it out, or the legacy output recorded in its § Golden examples;
  - the pitfalls that touch them, pinned down in the test;
  - **added:** what the plan misses for these rules (a boundary, an error path), with its
    expected value from the legacy code, cited, and marked `added`.

  Each planned test carries the flow's ID in its name or a trait (`F02_T4_…`).
- **The design it follows:** the stories and criteria it covers (`S1`…), and the screen
  behaviour, data, integrations and behaviour parity in `sdd.md`; the construct mapping in
  `target.md § 3`. The rules live where `target.md` § 4–5 puts business logic, never only in
  the UI; data access and external calls sit behind the interfaces the fakes stand in for.
- **Reuse:** a rule or code another flow or a ported file already built: use it, never a
  second copy.
- **Kept from legacy:** messages, constants, formats, rounding and quirks, and code that looks
  like a defect (a question), unless an answered question, `target.md § 5` or a recorded
  decision says otherwise.

## Build (§ 4)

1. **Red:** write the tests, and only the empty types and members they need to compile, each
   throwing "not implemented". Run them: each must fail because the behaviour is missing. A
   test that already passes is suspect: find out why (the behaviour exists elsewhere, or the
   test asserts too little) and report it. Strengthen a test that asserts too little; never
   weaken one.
2. **Green:** write the code that makes them pass, following the design. Where a rule is
   enforced, a comment names it by its flow ID, in business words, with its legacy line
   (`// F02-R3: over the credit limit → ON HOLD (legacy OrderService.cs:88)`), as
   [modern-code.instructions.md](../../instructions/modern-code.instructions.md) says.
3. **Tidy up:** with the tests green, remove duplication and make the names say what the rules
   say. The behaviour doesn't change; run the tests again.

## Review (§ 5)

Each rule built, and where (`F02-R3 → modern/…:line`); the tests red, then green (or which
weren't red, and why).
