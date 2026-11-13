---
name: mod-implement-manual
description: "Mentor. Builds a component with you, hands-on, so you learn it: the same accepted plan, order of work, tests and records as /mod-implement, but you do the work. Copilot leads: it picks the next step and says why, explains the plan, gives you the full code with where it goes and why, and the commands to build, run and test locally with what you should see. You apply and run them yourself, or choose Apply it for me / Run them for me at any stage. It checks what you applied and the output you send back, and records only what you accept. When it needs something, it says what, why, and exactly how to get it. discuss \"<topic>\" talks through any improvement to the new system with you (secrets to Key Vault or Azure App Configuration, EF Core, any refactoring): it weighs the options, recommends the best, and turns your decision into an improvement plan you build the same way."
argument-hint: "<component> [your instructions] · <component> <step | file | flow nn | screen nn> · <component> road map · discuss \"<topic>\" · improvement <nn> · improvements"
disable-model-invocation: true
---

# /mod-implement-manual — Build it yourself, with a mentor

**Requires agent: `Mentor`.** Under another agent, stop and ask the developer to switch.

This is [/mod-implement](../mod-implement/SKILL.md), hands-on. The plan, the order of work,
the recipes, the tests, the records and what gets recorded are the same; what changes is who
does the work, and how much is explained. **Copilot leads:** it picks the step, explains it,
writes the code and the commands, and checks the result. **The developer's hands do the
work:** they apply the code and run the commands, or hand either to Copilot at any stage.
**Nothing is recorded before the developer accepts it.** The Scaffolder and the Mentor can
take turns on one component: both read and write the same records.

Values in `<ANGLE BRACKETS>` come from the text after the command. Any other text is the
developer's instructions ("explain more about testing", "I know C#, keep it short"): they
shape this chat's steps.

| Argument | What you do |
|---|---|
| `<component>` | as `/mod-implement` § 1 and § 2, then the manual loop (below) for the next step |
| `<component> <step \| file \| flow nn \| screen nn>` | as `/mod-implement` § 1, then the manual loop for that step |
| `<component> road map` | as `/mod-implement` § 1 and § 2: the order of work, to review or change it |
| `discuss "<topic>"`, or an improvement in plain words | [discuss.md](discuss.md) § 1–4 |
| `improvement <nn>` | [discuss.md](discuss.md) § 5: the next step of that improvement |
| `improvements` | the rows of `docs/modern.md § Improvements`, with each one's next action |

## From `/mod-implement`, as it is

Follow [/mod-implement](../mod-implement/SKILL.md) (its "Requires agent: Scaffolder" doesn't
apply here: the Mentor runs this) for: the gate; § 1 Read, and the check of
the records against `modern/`; § 2 The next step and the road map; the step's plan (§ 3) and
its recipe ([port](../mod-implement/port-step.md), [flow](../mod-implement/flow-step.md),
[screen](../mod-implement/screen-step.md)); § 7 Changes and problems; § 8 When stuck; the
build record (§ 6) and § What gets recorded; § Unknowns become questions; and **every choice
is clickable**, with its labels.

Wherever `/mod-implement` says you build, run or write code, here you **give the developer
the code and the commands**; they apply and run them, or you do, when they choose **Apply it
for me** or **Run them for me** for that step.

## The manual loop

**Plan → Code → Apply → Build & test → Review → Accept and record.** The tracker, first line
of every reply about a step, says who does each stage:

```text
P3 · ✓ Plan ▸ ✓ Code ▸ ● Apply (you) ▸ ○ Build & test (you) ▸ ○ Review ▸ ○ Accept ▸ ○ Record
```

`(you)` or `(Copilot)`, as the developer chose. A flow step goes round Code → Apply → Build &
test twice: the tests (red), then the code (green).

### 1. Plan (no code yet)

The plan of `/mod-implement` § 3, as the recipe says, in plain words, and:
- **what you'll learn:** the one or two ideas this step practises (writing a test first,
  porting a class, a view model), in a line each;
- **the order you'll apply it in:** the files, tests first.

Ask (header "Plan"): ★ **Show me the code** · **Change something** · **Cancel**.

### 2. Code (always the full code)

For each file, in the order to apply it:
- **Where:** its full path under `modern/`, marked `new` or `change`; how to get there in VS
  Code (`Ctrl+P` and the file name; a new file: right-click the folder › New File).
- **The code:**
  - a new file: the whole file;
  - a change: the whole member or block to add or replace, with exactly where: "in
    `OrderPricing.cs`, replace the whole method `ApplyDiscount` with:", "add after the last
    `using` line:". Never a fragment that leaves the developer guessing, and never `...`
    inside code;
  - commented as [modern-code.instructions.md](../../instructions/modern-code.instructions.md)
    says: the header, the `Legacy:` references, the rules, the markers.
- **Why:** 2–6 short lines: what each part does, which legacy lines it keeps, what changed
  and why. A concept met for the first time gets one to three lines, once.
- **Packages:** the exact command (`dotnet add package <name> --version <version>`), for the
  developer to run.

Tests come first: the test code, and for a flow step the empty types its tests need, each
throwing "not implemented" (red); the implementation only after the developer has seen them
fail.

Ask (header "Apply"): ★ **I'll apply it** · **Apply it for me** · **Explain a part** (the
developer says which) · **Change something**.
- **I'll apply it:** numbered instructions, one action each ("1. Create
  `modern/tests/Orders.Core.Tests/Pricing/OrderPricingTests.cs`. 2. Paste the code above. 3.
  Save."). Then ask (header "Applied?"): ★ **Done, check it** · **Something's unclear** ·
  **Apply it for me after all**.
- **Apply it for me:** write exactly the code shown, nothing more (VS Code asks for each
  edit), and say what was written where.

### 3. Build & test (the developer runs it)

The commands from `docs/skeleton.md § Commands`, each in its own copy-ready block starting
with `Set-Location "<workspace>/modern/…";`, in order:
1. the build;
2. this step's tests, filtered to them (`dotnet test --filter "FullyQualifiedName~P3_"`);
3. the whole test projects, so nothing built earlier breaks;
4. **run it locally,** when the step has something to see (a screen, an endpoint, a job): the
   run command, the URL or what to start, what to do, and what they should see.

For each: **what you should see** (`Build succeeded.` · `0 Error(s)`; `Passed!  - Failed: 0,
Passed: 12`; for red, the new tests failing with "not implemented", which is right at this
point), and **what to send back:** the summary lines, or for a failure the whole error. Long
output: add `2>&1 | Select-Object -Last 40` to the command, or copy it from the terminal.

Ask (header "Run"): ★ **I'll run them** · **Run them for me**. Then wait for the output, or run
them and quote the lines that show each result.

**A failure:** explain it in plain words (what the message means, and where:
`path:line`), the cause, and the fix as full code (back to § 2). Fix the code, never the
test. At most three focused attempts; then `/mod-implement` § 8.

### 4. Review

- **What was applied:** read each file of the step in `modern/` (read-only) and compare it
  with the code given. A typo or a missing part: point to the line and give the fix. A
  deliberate change by the developer: ask (header "Your change"): ★ **Keep mine** (it goes in
  the record under Changes, asked by the developer) · **Use the given code**.
- **The results:** only the output the developer sent or you ran. Missing output: ask for it,
  with the command.
- Then everything `/mod-implement` § 5 shows: files, tests by kind, the recipe's additions,
  questions, markers, and the trace back to legacy.

Ask (header "Review"): ★ **Accept and record** (★ when every test passes) · **Change
something** · **Discard this step**. Discard: list the files to delete and the changes to
undo, for the developer to do (VS Code: Source Control › the file › Discard Changes), or ★
**Undo it for me** (delete the files the step created, restore the ones it changed; never
with a git command). Nothing is recorded, and the step stays to do.

### 5. Record, then the next step

Only after **Accept and record**: the build record of `/mod-implement` § 6, with `manual`
after its kind on the first line and one more line:

```text
BUILD RECORD · <component> · <step> · <build | rework | fix | revert | order> · manual · accepted YYYY-MM-DD
…
Hands:        applied by <the developer | Copilot> · run by <the developer, output sent | Copilot>
```

Write it at once, as [/mod-implement § What gets recorded](../mod-implement/SKILL.md#what-gets-recorded)
says, and say in one line what was written where. Then ask (header "Next step"): ★ **Build
`<next step>`** (what, and why) · **Another step, or change the road map** · **Hand the rest to
the Scaffolder** ("Select the Scaffolder and type `/mod-implement <component>`: it continues
from the records") · **Continue in a fresh chat** (★ after about 5 steps).

## When Copilot needs something

Say **what** you need, **why** (what it changes), **how to get it** (the exact command, file or
portal path), and **what to send back**. A choice the developer makes (a name, an environment)
→ `askQuestions`, ★ first. Information only the developer has → a "What I need" block, and
wait for it.

| It needs | How the developer gets it |
|---|---|
| a command's result: build, test, run | the command, and the lines to send back |
| what's installed: SDKs, runtimes, tools | `dotnet --list-sdks`, `node --version`, `az version`, and the line that matters |
| what an error says | the whole error, from the terminal or the Problems panel (`Ctrl+Shift+M`) |
| a setting in their environment: a config key, an environment variable's name, a server or database name | the file and key (`appsettings.Development.json` › `ConnectionStrings`), or `Get-ChildItem Env:` for names; never the values of secrets |
| a cloud resource's name or address: subscription, resource group, Key Vault or App Configuration URI | the portal path (Key vaults › the vault › Overview › Vault URI), or `az account show --query name`, `az keyvault list --query "[].{name:name, uri:properties.vaultUri}"` |
| what legacy does: a rule, a value, data | the question bank, as `/mod-implement` § Unknowns says: a question with a working assumption, and the work goes on. Also say who can answer and how (a read-only query on a legacy copy, the person to ask), and that the Guide's `/mod-answer Q-###: <answer>` records the answer |

**Never a secret:** ask for names and addresses only, and show where the secret goes (`dotnet
user-secrets set "<key>" "<value>"` run by the developer, or Key Vault), so it never appears in
chat or in code. One pasted by mistake: don't repeat it or write it anywhere, and suggest
rotating it.

## Discuss an improvement

[discuss.md](discuss.md): for work beyond the accepted plans, on the new system (move secrets
to Key Vault or Azure App Configuration, refactor data access to EF Core, add telemetry, split
a service, any refactoring). Copilot weighs the options and recommends one; the developer
decides; the decision becomes an improvement plan in `docs/improvements/`, built with the
manual loop above.
