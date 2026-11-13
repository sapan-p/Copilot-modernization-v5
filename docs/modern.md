# The modern system

**Updated:** — · Kept by the Guide from what you decide, and by the Scaffolder and the Mentor
from what you accept as built. The legacy side is in [system.md](system.md);
`/mod-modern-report` explains both together.

`/mod-target` writes the target rows when you accept [target.md](target.md), and the
Scaffolder and the Mentor record what's built each time you choose **Accept and record**. A
decision here dated after `target.md` was accepted wins over it. For anything
else, tell the Guide in plain words and it records it here, for example: "use the suggested
plan", "orders-core is live since 2026-12-01".

## Target and decisions

| Area | Decision | Why | Date |
|---|---|---|---|

Area is one of UI · API / services · data · hosting · identity · integration · testing ·
build and deploy, or a component name for a decision about one component.

## Plan

The waves of work, in order. Wave 0 is the foundation: the new solution, its pipeline and
the shared concerns (configuration, logging, identity, adapters to legacy resources).

| Wave | Legacy components | Why now | How old and new run side by side | Done when | When |
|---|---|---|---|---|---|

## Progress

One row per legacy component in the plan.

| Legacy component | Modern part (path) | Wave | Status | Evidence | Updated |
|---|---|---|---|---|---|

**Status:**
- not started;
- building;
- built: its code and tests pass in `modern/`;
- live: used instead of the legacy component;
- kept: stays legacy (say why in Evidence).

Evidence for built and live is a test run (date, result), a commit or a pull request.

## Work in progress

Paused work, so it can be picked up exactly where it stopped. `/mod-track` records a row
when you pause, and it goes when the work carries on.

| Component | Stopped at | In `modern/`, not accepted | Next | Note | Since |
|---|---|---|---|---|---|

## Improvements

Changes to the new system beyond the plans (secrets to Key Vault, EF Core, a refactoring), one
plan each in [improvements/](improvements/). Select the **Mentor** and type
`/mod-implement-manual discuss "<what>"` to talk one through; it adds the row once you accept
its plan.

| # | Improvement | Scope | Status | Plan | Updated |
|---|---|---|---|---|---|
