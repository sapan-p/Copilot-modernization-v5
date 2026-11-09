# The modern system

**Updated:** — · Kept by the Guide from what you decide and build. The legacy side is in
[system.md](system.md); `/mod-modern-report` explains both together.

`/mod-target` writes the target rows when you accept [target.md](target.md), and the
Scaffolder's **Record in docs** button records what it builds. For anything else, tell the
Guide in plain words and it records it here, for example: "use the suggested plan",
"orders-core is built, all tests pass".

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
