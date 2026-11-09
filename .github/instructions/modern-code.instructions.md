---
applyTo: "modern/**"
description: "How code under modern/ is commented: informative, context-oriented comments that tie the code to the migration records, and searchable markers (TODO, RECHECK, BLOCKED, WAITS) wherever something is unresolved."
---

# Comments in `modern/`

Anyone who opens a file in `modern/` should see where it came from, which business rules it
enforces, what was kept from legacy on purpose, and what's still unresolved, without opening
the records. Comments say **why** and **where from**, never what the next line plainly does.

## What to comment

| Where | What it says | Example (C#) |
|---|---|---|
| The top of each file you create | what it is, in business words; what it replaces; the step that built it | `// Order pricing: list price, volume discount and credit-limit hold.` `// Ported from legacy/Orders/Pricing/PriceCalculator.cs (step P3).` |
| Public types and members | their purpose in business words, in the language's doc comments, with the rules they enforce | `/// <summary>Applies the volume discount (F02-R4).</summary>` |
| Where a business rule is enforced | the rule's ID, the rule in a few words, and the legacy line | `// F02-R3: over the credit limit → ON HOLD (legacy OrderService.cs:88).` |
| Code kept as legacy does it, though it looks odd | that it's deliberate, and why | `// Kept from legacy: rounds each line before summing (Pricing.cs:38), so the totals match.` |
| Where the port changed something | what changed, and its source | `// Port change (P4): BinaryFormatter → System.Text.Json (target.md § 5).` |
| Where a decision changed the behaviour | the decision, and what legacy did | `// Decision 2026-11-10: 10% discount (legacy: 5%). See docs/modern.md.` |
| Each test | what it pins down, and where its expected value comes from | `// F02-T6: 15.00 = 100 × 0.15, Math.Round to even (Pricing.cs:41).` |

## Markers: what's unresolved

A marker is uppercase, then an ID in brackets that exists in the records, a colon, and what's
assumed or missing. Find them all in `modern/` with the regex search
`\b(TODO|RECHECK|BLOCKED|WAITS)\(`.

| Marker | Means | Example | Goes away when |
|---|---|---|---|
| `TODO(Q-###)` | the code rests on an OPEN question, and follows its working assumption | `// TODO(Q-031): assumes the discount applies per line (risk M).` | the question is answered (`/mod-answer`), and `/mod-implement`'s follow-up applies the answer |
| `RECHECK(<id>)` | built, but not confirmed yet: an expected value worked out from the code (`run legacy`), a runtime difference, or an answer that may change it | `// RECHECK(F02-T6): confirm 15.00 on a legacy run (tdd.md § Golden examples).` | the legacy output is recorded, or the rework is done |
| `BLOCKED(<id>)` | can't proceed: the step is parked (`partial`), and this code is incomplete | `// BLOCKED(Q-044): no replacement for the COM printer API yet; throws NotSupportedException (P7).` | the way out chosen in `/mod-implement § 8` is built |
| `WAITS(<component or step>)` | reached through a fake or an interface until another part is built | `// WAITS(orders-core): IPriceService is faked until orders-core is built (F02-B2).` | that part is built, and the follow-up switches to it |

A legacy behaviour that looks like a defect, kept on purpose, is a `TODO(Q-###)` that says so:
`// TODO(Q-052): legacy cuts names over 30 characters (Customer.cs:17); kept until Business decides.`

## Rules

- **Markers match the records:** a `TODO` names an OPEN question, a `BLOCKED` step is
  `partial`, a `WAITS` is under the step's Waits for. Add and remove markers in the same step
  that records them; the build record lists them.
- **Never a bare `TODO` or `FIXME`,** and never a marker without its ID.
- **Keep comments true:** a rework updates them, and a resolved marker is removed, not left
  behind.
- **Short, plain English, present tense.** Cite legacy as `path:line`; never paste legacy code,
  and never leave commented-out code.
- **Each language's own comment syntax:** `//` and `///` in C#, `//` and `/** */` in
  TypeScript, `@* *@` in Razor, `<!-- -->` in XAML and HTML, `--` in SQL. A file that can't
  hold comments (JSON) gets its note in the build record instead.
- **Not in generated files,** and not where the code already says it plainly.
- **No secrets,** credentials or personal data.
