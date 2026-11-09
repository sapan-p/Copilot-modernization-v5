# The legacy system

**Updated:** — · Written by `/mod-discover`. Read this first.

## Architecture in brief

_Not discovered yet. Select the **Guide** and run `/mod-discover`._

## Components

One folder per component in [components/](components/): `component.md` (what discovery
found), then its plans (`deepdive.md`, `port.md`, `flows/`, `screens/`) once it's planned.

| Component | Kind | Technology | Path | Layer | Approach |
|---|---|---|---|---|---|

Approach: suggested by `/mod-discover-comp` (Port · Rewrite · Split · Keep, with its
confidence); decided in [modern.md](modern.md).

## Resources

Shared things that aren't projects: databases, file shares, queues, shared config,
schedulers, caches, report servers and external systems.

| Resource | Kind | Written by | Read by | Evidence |
|---|---|---|---|---|

## Dependencies

Mechanisms: see `.github/skills/mod-discover/communication-catalog.md`.

| From | To | Mechanism | Detail | Evidence |
|---|---|---|---|---|

## Dependency graph

An arrow goes from the one that depends to the one it depends on.

```mermaid
flowchart LR
    %% filled by /mod-discover
```

## Dependency tree

```text
(filled by /mod-discover)
```

## Layers

Layer 0 depends on no other component. Layer n depends only on layers below n. Links
through shared resources don't count here; they are hotspots.

| Layer | Components |
|---|---|

**Cycles:** —

**Hotspots:** —

## Discovery progress

| Component | Technology | Dependencies | Deep | Notes |
|---|---|---|---|---|
