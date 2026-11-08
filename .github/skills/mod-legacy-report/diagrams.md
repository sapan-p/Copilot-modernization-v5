# Diagrams for /mod-legacy-report

Mermaid, rendered by the Markdown preview (`bierner.markdown-mermaid`). One recipe per
picture. Use the recorded names; the examples are only examples.

## Rules for every diagram

- **A caption line above it:** what the arrows mean and what the styles mark.
- **Node IDs:** the component slug with `-` changed to `_` (`orders_mvc`), letters, digits
  and `_` only. Never use `end`, `graph`, `subgraph`, `class`, `style`, `click` or `default`
  as an ID: add `_n`.
- **Flowchart labels:** always in double quotes, with no `"` or `;` inside. Use `<br/>` for a second
  line, such as the technology: `orders_mvc["orders-mvc<br/>ASP.NET MVC 5"]`.
- **Shapes,** as in `system.md`:

  | Thing | Shape |
  |---|---|
  | component | `id["name"]` |
  | database | `id[("name")]` |
  | other resource (share, queue, config, scheduler…) | `id{{"name"}}` |
  | external system | `id[/"name"/]`, with class `outside` |
  | people (actors) | `id(("name"))` |

- **Arrows:** `a -->|"mechanism"| b`, from the one that depends or acts to what it depends
  on or acts on. Only the data diagram follows the data instead.
- **Styles:** strokes only, so they read in light and dark themes. Add the `classDef` lines
  a diagram uses:

  ```text
  classDef risk stroke:#d62728,stroke-width:3px
  classDef outside stroke-dasharray:5 5
  classDef focus stroke-width:4px
  ```

  `risk`: out of support, in a cycle, or a shared write. `outside`: outside the repository.
  `focus`: the subject of a profile.
- **Size:** at most about 25 nodes. For more, draw one overview with a node per solution or
  layer (`"billing: 7 components"`), then one diagram per group.
- **Check before you write:** the first line names the diagram type; every arrow joins
  declared IDs; no ID is declared twice.

## Context

The repository as a boundary: the apps and services in it, and the people, external
systems, databases and shares around it. Collapse libraries into one node per solution.

```mermaid
flowchart LR
    clerks(("Order clerks"))
    subgraph repo["In this repository"]
        orders_winforms["orders-winforms<br/>WinForms · .NET 4.5.2"]:::risk
        orders_mvc["orders-mvc<br/>ASP.NET MVC 5"]
        orders_libs["orders: 3 libraries"]
    end
    orders_db[("Orders DB")]
    exports_share{{"\\srv\exports"}}
    erp[/"ERP"/]:::outside
    clerks --> orders_winforms
    clerks --> orders_mvc
    orders_winforms -->|"project ref"| orders_libs
    orders_mvc -->|"project ref"| orders_libs
    orders_libs -->|"db read/write"| orders_db
    orders_winforms -->|"file write"| exports_share
    orders_mvc -->|"soap"| erp
    classDef risk stroke:#d62728,stroke-width:3px
    classDef outside stroke-dasharray:5 5
```

## Layers

Components only, one subgraph per layer, highest layer on top. Arrows point down to what a
component depends on. Mark cycle members `risk`.

```mermaid
flowchart TB
    subgraph l2["Layer 2"]
        orders_mvc["orders-mvc"]
        orders_winforms["orders-winforms"]
    end
    subgraph l1["Layer 1"]
        orders_services["orders-services"]
    end
    subgraph l0["Layer 0"]
        orders_core["orders-core"]
    end
    orders_mvc -->|"project ref"| orders_services
    orders_winforms -->|"dll ref"| orders_services
    orders_services -->|"project ref"| orders_core
    classDef risk stroke:#d62728,stroke-width:3px
```

## Data

Writers on the left, stores in the middle, readers on the right. Arrows follow the data, and
labels name the tables when they're recorded. Mark a store written by 2 or more components
`risk`.

```mermaid
flowchart LR
    orders_mvc["orders-mvc"] -->|"writes Orders, OrderLines"| orders_db[("Orders DB")]:::risk
    import_job["import-job"] -->|"writes Orders"| orders_db
    orders_db -->|"reads Orders"| orders_reports["orders-reports"]
    classDef risk stroke:#d62728,stroke-width:3px
```

## Integrations

Like the context diagram, but every mechanism that crosses the boundary or a resource:
services, queues, shares, schedules and CLI launches. Label each arrow with its detail
(endpoint key, queue name, path, schedule).

```mermaid
flowchart LR
    subgraph repo["In this repository"]
        import_job["import-job"]
        orders_mvc["orders-mvc"]
    end
    scheduler{{"Task Scheduler"}}
    imports_share{{"\\srv\imports"}}
    erp[/"ERP"/]:::outside
    scheduler -->|"runs nightly 02:00"| import_job
    import_job -->|"reads *.csv"| imports_share
    orders_mvc -->|"soap: ErpOrderService"| erp
    classDef outside stroke-dasharray:5 5
```

## Flow

A sequence diagram, trigger first, one participant per component or resource. Steps the
records don't show are notes starting with `?`.

```mermaid
sequenceDiagram
    autonumber
    participant sched as Task Scheduler
    participant job as import-job
    participant share as \\srv\imports
    participant db as Orders DB
    sched->>job: starts it nightly
    job->>share: reads the order files
    Note over job: ? validation rules not recorded
    job->>db: writes Orders
```

## Neighbourhood

One component (`focus`), what uses it on the left, what it depends on and its resources on
the right. One hop each way.

```mermaid
flowchart LR
    orders_mvc["orders-mvc"] -->|"project ref"| orders_services["orders-services"]:::focus
    orders_winforms["orders-winforms"] -->|"dll ref"| orders_services
    orders_services -->|"project ref"| orders_core["orders-core"]
    orders_services -->|"db read/write"| orders_db[("Orders DB")]
    classDef focus stroke-width:4px
```

## Features

A mindmap of capabilities per component. Plain words only: no brackets or parentheses in
the text, because a mindmap reads them as shapes.

```mermaid
mindmap
  root((Orders system))
    orders-mvc
      Place an order
      Track an order
    orders-winforms
      Back-office order entry
      Month-end export
```

## Support timeline

The end-of-support dates you know, oldest first, with the components affected. No `:`
inside the text.

```mermaid
timeline
    title End of vendor support - inferred, verify
    2016-01 : .NET Framework 4.5.1 - orders-core
    2022-04 : .NET Framework 4.5.2 - orders-winforms, orders-mvc
    2030-01 : SQL Server 2019 - Orders DB
```
