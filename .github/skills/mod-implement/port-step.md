# Port step

For a port step (`P3`) from `port.md`. The logic moves as code: the same structure, names,
messages, constants and quirks, changed only where the target needs it, with tests that show
the behaviour stayed the same. The sections below add to the same sections of
[SKILL.md](SKILL.md).

## Picture (§ 2)

The step's neighbourhood from `deepdive.md § File map`: the files it uses and the files that
wait on it, each with its status, one subgraph per level, following the
[diagram rules](../mod-legacy-report/diagrams.md#rules-for-every-diagram) and the
[status styles](../mod-modern-report/diagrams.md#status-styles).

## Plan (§ 3)

- **Files:** each legacy file → its modern file, as the step's Modern files say.
- **The changes,** each with its reason and legacy `path:line`, and only these:
  - the step's Changes in `port.md`;
  - project, namespace and `using` changes, by the naming conventions in `target.md § 4`;
  - the file's port blockers, replaced as § Suggested approach or `target.md § 3` says;
  - the port decisions in `target.md § 5` that touch it (configuration, data access,
    logging);
  - what the target compiler or runtime requires (an API removed or changed), nothing more;
  - names written in strings that change with the namespace: reflection, type names in
    config, serialized type names, resource names;
  - a seam (an interface around a database, file, clock or external call) only where a test
    needs a fake and the step's Needs lists it;
  - calls into another component: built → its modern project, as its § In the modern
    solution says; not built → as the step's Needs says (its legacy build output where
    `target.md § 5` allows it, or an interface here with a fake, under **Waits for**).

  Mark a change that isn't in the plan `(not in the plan)`.
- **Kept as it is:** everything else. The logic and control flow, the names, the public
  members other components use (§ Used by), messages, constants, formats, rounding, error
  handling, and code that looks like a defect (a question). No refactoring, renaming,
  restyling or improvement beyond the changes listed.
- **Behaviour risks:** the step's risks in `port.md`, and any other runtime difference in
  [runtime-differences.md](../mod-deepdive/runtime-differences.md) its files show, each with
  its test.
- **Tests,** in the test project and framework `skeleton.md` gives:
  - **ported:** the legacy tests of these files, with the same assertions; the ones that
    can't be ported, and why;
  - **planned:** the step's unit tests in `port.md` (`P3.1`, `P3.2`…), except those a ported
    test already covers;
  - **added:** what the plan misses: a branch, boundary or error path no test reaches, or a
    behaviour risk without a test.

  Planned tests carry their ID in the name or a trait (`P3_2_…`); ported ones keep their
  legacy name; added ones are marked `added`.

## Build (§ 4)

1. **Tests first:** write the ported, planned and added tests.
2. **Port the files** with exactly the planned changes.
3. **A failing test:** compare the modern lines with the legacy lines they came from, and fix
   the port.

## Review (§ 5)

For each file, what changed from the legacy file and why; and each behaviour risk with its
test result.
