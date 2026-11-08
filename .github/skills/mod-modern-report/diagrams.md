# Diagrams for /mod-modern-report

The rules for every diagram (IDs, labels, shapes, arrows, size, the check before you write)
are in [../mod-legacy-report/diagrams.md](../mod-legacy-report/diagrams.md#rules-for-every-diagram).
These recipes add the migration status. The examples are only examples.

## Status styles

Put the status in the label as well, so a diagram reads without colour:
`orders_core["orders-core<br/>built"]:::built`. Not started has no class.

```text
classDef live stroke:#2ca02c,stroke-width:4px
classDef built stroke:#2ca02c,stroke-width:2px,stroke-dasharray:6 3
classDef building stroke:#ff7f0e,stroke-width:3px
classDef kept stroke:#7f7f7f,stroke-dasharray:2 2
classDef blocked stroke:#d62728,stroke-width:3px
```

`blocked` replaces the not-started look for a component that can't start yet.

## Migration map

The legacy components, one subgraph per wave with its progress in the title, coloured by
status. Arrows point to what a component depends on.

```mermaid
flowchart TB
    subgraph w2["Wave 2 · 0 of 2 done"]
        orders_mvc["orders-mvc<br/>not started"]
        orders_winforms["orders-winforms<br/>blocked"]:::blocked
    end
    subgraph w1["Wave 1 · 1 of 2 done"]
        orders_services["orders-services<br/>building"]:::building
        pricing["pricing<br/>built"]:::built
    end
    subgraph w0["Wave 0 · foundation"]
        orders_core["orders-core<br/>live"]:::live
    end
    orders_mvc -->|"project ref"| orders_services
    orders_winforms -->|"dll ref"| orders_services
    orders_services -->|"project ref"| orders_core
    orders_services -->|"project ref"| pricing
    classDef live stroke:#2ca02c,stroke-width:4px
    classDef built stroke:#2ca02c,stroke-width:2px,stroke-dasharray:6 3
    classDef building stroke:#ff7f0e,stroke-width:3px
    classDef blocked stroke:#d62728,stroke-width:3px
```

## Target architecture

The new system in `modern/`, the legacy parts it still relies on, and the bridges between
them. Arrows point from the one that calls or depends to what it reaches.

```mermaid
flowchart LR
    users(("Order clerks"))
    subgraph modern["New system"]
        orders_web["Orders.Web<br/>Blazor Server"]:::live
        orders_api["Orders.Api<br/>ASP.NET Core 9"]:::building
    end
    subgraph legacy["Still legacy"]
        import_job["import-job<br/>not started"]
    end
    orders_db[("Orders DB")]
    erp[/"ERP"/]:::outside
    users --> orders_web
    orders_web -->|"http"| orders_api
    orders_api -->|"db read/write - shared"| orders_db
    import_job -->|"db write - shared"| orders_db
    orders_api -->|"adapter: soap"| erp
    classDef live stroke:#2ca02c,stroke-width:4px
    classDef building stroke:#ff7f0e,stroke-width:3px
    classDef outside stroke-dasharray:5 5
```

## Coexistence

A sequence diagram for one flow, with a `box` for the new system and one for legacy, trigger
first. Steps the records don't show are notes starting with `?`.

```mermaid
sequenceDiagram
    autonumber
    box New system
    participant web as Orders.Web
    participant api as Orders.Api
    end
    box Legacy
    participant job as import-job
    end
    participant db as Orders DB
    web->>api: places an order
    api->>db: writes Orders
    job->>db: reads Orders nightly
    Note over job,db: both systems use the same tables until import-job moves
```

## Neighbourhood

One component (`focus`) with what uses it and what it depends on, one hop each way,
coloured by status.

```mermaid
flowchart LR
    orders_mvc["orders-mvc<br/>not started"] -->|"project ref"| orders_services["orders-services<br/>building"]:::building
    orders_services -->|"project ref"| orders_core["orders-core<br/>live"]:::live
    orders_services -->|"db read/write"| orders_db[("Orders DB")]
    class orders_services focus
    classDef live stroke:#2ca02c,stroke-width:4px
    classDef building stroke:#ff7f0e,stroke-width:3px
    classDef focus stroke-width:5px
```

## Status pie

Components by status, kept ones included as their own slice.

```mermaid
pie showData
    title Components by status
    "live" : 1
    "built" : 1
    "building" : 1
    "not started" : 3
    "kept" : 1
```

## Waves over time

Only when the waves have dates. `done` and `active` follow the waves' progress.

```mermaid
gantt
    title Plan of execution
    dateFormat YYYY-MM-DD
    axisFormat %Y-%m
    section Wave 0
    Foundation :done, w0, 2026-12-01, 2027-01-15
    section Wave 1
    orders-services, pricing :active, w1, 2027-01-15, 2027-03-01
    section Wave 2
    orders-mvc, orders-winforms :w2, after w1, 8w
```
