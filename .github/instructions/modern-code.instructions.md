---
applyTo: "modern/**"
description: "How code under modern/ is commented: informative, context-oriented comments that tie the code to the migration records, a searchable Legacy: reference (legacy path, lines, type and member) on everything that came from legacy, so any part can be traced back and compared, and searchable markers (TODO, RECHECK, BLOCKED, WAITS) wherever something is unresolved."
---

# Comments in `modern/`

Anyone who opens a file in `modern/` should see where it came from, down to the legacy method
and lines, which business rules it enforces, what was kept from legacy on purpose, and what's
still unresolved, without opening the records. Comments say **why** and **where from**, never
what the next line plainly does.

## Legacy references: trace every part back

Everything whose logic comes from legacy says where, in one searchable form, so a developer
can open the legacy side and compare it, today or years from now:

```text
Legacy: <path from the workspace root>:<line or start-end> · <Type.Member(parameters)>
```

- **The full path, from `legacy/`:** `legacy/Orders/Pricing/PriceCalculator.cs`, never a bare
  `Pricing.cs`.
- **The member, always with its lines:** the method, property, procedure, event handler, query
  or control. In each language's terms: `Class.Method(Type)` in C# and VB.NET,
  `Module.Procedure` in VBA and VB6, `Form.btnSave_Click` or `Form.txtCustomer` on a screen,
  `dbo.usp_GetOrders` in SQL, `function name` in script.
- **Several sources** (code merged from several legacy places): one `Legacy:` line each.
- **Renamed:** add `(was <legacy name>)`.
- **New code with no legacy origin** (a seam, a host, a mapping): `Legacy: none (new: <why>)`,
  on its file header.

Find everything that came from a legacy file with a search for
`Legacy: legacy/Orders/Pricing/PriceCalculator.cs`, from a legacy method with the regex
`Legacy: .*ApplyDiscount`, and everything traced with `Legacy: legacy/`.

## What to comment

| Where | What it says | Example (C#) |
|---|---|---|
| The top of each file you create (or give the developer to create) | what it is, in business words; each legacy file it replaces, with the types or members it covers; the step that built it and its plan | `// Order pricing: list price, volume discount and credit-limit hold.` `// Legacy: legacy/Orders/Pricing/PriceCalculator.cs · PriceCalculator (all members)` `// Step: P3 · docs/components/orders-core/port.md` |
| Each type and member whose logic comes from legacy, public or private | a `Legacy:` line right above it (after its doc comment); public ones also get their purpose in business words, in the language's doc comments, with the rules they enforce | `/// <summary>Applies the volume discount (F02-R4).</summary>` `// Legacy: legacy/Orders/Pricing/PriceCalculator.cs:41-58 · PriceCalculator.ApplyDiscount(Order)` |
| A block that maps to its own legacy lines: a legacy method split, merged or reordered, or a long member | the legacy lines of this block | `// Legacy: legacy/Orders/Pricing/PriceCalculator.cs:47-52 · PriceCalculator.ApplyDiscount: the tier lookup` |
| Where a business rule is enforced | the rule's ID, the rule in a few words, and the legacy member and line | `// F02-R3: over the credit limit → ON HOLD · Legacy: legacy/Orders/Services/OrderService.cs:88 · OrderService.Submit(Order)` |
| Code kept as legacy does it, though it looks odd | that it's deliberate, why, and where | `// Kept from legacy: rounds each line before summing, so the totals match · Legacy: legacy/Orders/Pricing/PriceCalculator.cs:38 · PriceCalculator.Total()` |
| Where the port changed something | what changed, its source, and the legacy line it replaces | `// Port change (P4): BinaryFormatter → System.Text.Json (target.md § 5) · Legacy: legacy/Orders/Cache/OrderCache.cs:61 · OrderCache.Save()` |
| Where a decision changed the behaviour | the decision, what legacy did, and where | `// Decision 2026-11-10: 10% discount (legacy: 5%), see docs/modern.md · Legacy: legacy/Orders/Pricing/PriceCalculator.cs:41 · PriceCalculator.ApplyDiscount(Order)` |
| Where an improvement changed something (`/mod-implement-manual discuss`) | the improvement's ID, what changed and why, and its plan; the `Legacy:` references already there move with the code they describe | `// Improvement I01: the connection string comes from Key Vault, not appsettings.json (docs/improvements/01-key-vault.md).` |
| Each test | what it pins down, and where its expected value comes from; a ported test, the legacy test it ports | `// F02-T6: 15.00 = 100 × 0.15, Math.Round to even · Legacy: legacy/Orders/Pricing/PriceCalculator.cs:41 · PriceCalculator.ApplyDiscount(Order)` `// Ported from legacy/Orders.Tests/PricingTests.cs:22 · PricingTests.Discount_AppliesOverTen()` |
| A screen: its markup, each control or group, each action | the legacy form; the control it replaces, with its designer line; the event handler each action replaces, and the backend piece it calls | `@* Legacy: legacy/Orders/UI/OrderForm.Designer.cs:120 · txtCustomer *@` `@* Legacy: legacy/Orders/UI/OrderForm.cs:210-245 · OrderForm.btnSave_Click → IOrderService.Save *@` |

## Markers: what's unresolved

A marker is uppercase, then an ID in brackets that exists in the records, a colon, and what's
assumed or missing. Find them all in `modern/` with the regex search
`\b(TODO|RECHECK|BLOCKED|WAITS)\(`.

| Marker | Means | Example | Goes away when |
|---|---|---|---|
| `TODO(Q-###)` | the code rests on an OPEN question, and follows its working assumption | `// TODO(Q-031): assumes the discount applies per line (risk M).` | the question is answered (`/mod-answer`), and `/mod-implement`'s follow-up applies the answer |
| `RECHECK(<id>)` | built, but not confirmed yet: an expected value worked out from the code (`run legacy`), a runtime difference, or an answer that may change it | `// RECHECK(F02-T6): confirm 15.00 on a legacy run (tdd.md § Golden examples).` | the legacy output is recorded, or the rework is done |
| `BLOCKED(<id>)` | can't proceed: the step is parked (`partial`), and this code is incomplete | `// BLOCKED(Q-044): no replacement for the COM printer API yet; throws NotSupportedException (P7) · Legacy: legacy/Orders/Print/LabelPrinter.cs:30-74 · LabelPrinter.Print()` | the way out chosen in `/mod-implement § 8` is built |
| `WAITS(<component or step>)` | reached through a fake or an interface until another part is built | `// WAITS(orders-core): IPriceService is faked until orders-core is built (F02-B2).` | that part is built, and the follow-up switches to it |

A legacy behaviour that looks like a defect, kept on purpose, is a `TODO(Q-###)` that says so:
`// TODO(Q-052): legacy cuts names over 30 characters; kept until Business decides · Legacy: legacy/Orders/Model/Customer.cs:17 · Customer.Name`.

## Rules

- **Cite only what you read.** A `Legacy:` reference names lines you read in this step, and the
  member that holds them. Never guess a line; a range covers the whole member or block.
- **One reference per member or block,** not per line. A trivial member (a property copied
  from a legacy DTO) is covered by its type's reference.
- **Markers match the records:** a `TODO` names an OPEN question, a `BLOCKED` step is
  `partial`, a `WAITS` is under the step's Waits for. Add and remove markers in the same step
  that records them; the build record lists them.
- **Never a bare `TODO` or `FIXME`,** and never a marker without its ID.
- **Keep comments true:** a rework updates them and their `Legacy:` references, and a resolved
  marker is removed, not left behind.
- **Short, plain English, present tense.** Cite legacy as `path:line · member`; never paste
  legacy code, and never leave commented-out code.
- **Each language's own comment syntax:** `//` and `///` in C#, `//` and `/** */` in
  TypeScript, `@* *@` in Razor, `<!-- -->` in XAML and HTML, `--` in SQL. A file that can't
  hold comments (JSON) gets its note in the build record instead.
- **Not in generated files,** and not where the code already says it plainly.
- **No secrets,** credentials or personal data.
