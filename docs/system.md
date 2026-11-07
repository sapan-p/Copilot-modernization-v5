# The legacy system

**Updated:** — · Written by `/mod-discover`. Read this first.

## Architecture in brief

_Not discovered yet. Select the **modernization-guide** and run `/mod-discover`._

## Components

One file per component in [components/](components/).

| Component | Kind | Technology | Path | Layer |
|---|---|---|---|---|

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

| Component | Technology | Dependencies | Notes |
|---|---|---|---|
