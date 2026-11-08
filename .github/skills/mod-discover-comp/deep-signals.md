# Deep signals

What to look for when reading every file of one component. Used by `/mod-discover-comp`.
`/mod-discover` searched each component only for the mechanisms of its kind, by pattern.
Reading every file finds what that missed. Report only what a file shows.

## 1. Hidden links: what the first pass misses

**Every mechanism, whatever the kind.** Use all of
[communication-catalog.md § 1](../mod-discover/communication-catalog.md#1-mechanisms), not just
the row for the component's kind. A class library can launch a process, and a web app can
write to a share.

| Signal | What to look for |
|---|---|
| Wrappers | A helper that wraps a mechanism (`RunProcess`, `CopyToShare`, `SendToQueue`, `ExecSql`). Give each of its call sites in the component, with the target it passes |
| Values built at runtime | Paths, URLs, exe names, queue names or SQL built by concatenation, `String.Format`, `Path.Combine`, or from constants in another class. Give the parts and where each comes from |
| Values read from elsewhere | Targets read from config keys, a settings table, the registry, an `.ini` file, environment variables or command-line arguments. Give the key or table and where it's read |
| DFS and shares | DFS namespaces (`\\<domain>\<root>\…`), `NetDfs*` APIs, `dfsutil`, drive mapping (`net use`, `WNetAddConnection2`, `MapNetworkDrive`), folder-as-queue patterns (watched folders, `.done` or `.err` renames, `in` / `out` / `archive` folders) |
| Queues, including home-made ones | Everything in `messaging`, plus a table used as a queue (polled status columns, `TOP 1 … WITH (READPAST)`, `WAITFOR`) and a folder used as a queue |
| External executables | Everything in `cli`, plus tools called with arguments built in code: `robocopy`, `xcopy`, `sqlcmd`, `bcp`, `dtexec`, `psexec`, `7z`, `msaccess.exe`, `excel.exe`, PDF and print tools. Give the arguments' pattern and the exit codes checked |
| Its own command line | What the component accepts when others start it: `Main(string[] args)` switches, `Command$` in VB6/VBA, `/cmd` macros, exit codes it returns |
| Late binding | `CreateObject(<variable>)`, `GetObject`, `Activator.CreateInstance`, `Type.GetType("…")`, `Assembly.Load*`, reflection over type names, plug-in folders |
| Dynamic SQL | SQL built as strings, table or database names in variables, `EXEC(@sql)`, `sp_executesql`, SQL kept in resources or `.sql` files read at runtime. Give the tables touched |
| Platform and environment | Registry, event log, WMI, Active Directory (`DirectoryEntry`, LDAP), impersonation, certificates (store names only), printers and printer names, devices (serial ports, scanners), clipboard, DDE |
| Caches and in-memory state | Shared caches (`cache` in the catalog: Redis, AppFabric, a state server), whatever the kind, and in-process ones the new system must keep consistent: `MemoryCache`, `HttpRuntime.Cache`, `Application[…]`, static dictionaries. Give what's cached, its expiry and what refreshes it |
| Background work | Timers, threads, `BackgroundWorker`, loops with `Sleep`, Windows service `OnStart` work, retries |

## 2. Port blockers: what stops a .NET Framework port to .NET 10

| API or feature | What happens on .NET 10 | Usual replacement |
|---|---|---|
| `System.Web`: `HttpContext.Current`, `Session`, HTTP modules and handlers, `Global.asax` events | not available | ASP.NET Core middleware, `IHttpContextAccessor`, session middleware |
| ASP.NET MVC 5 / Web API 2 (`System.Web.Mvc`, `System.Web.Http`) | not available | ASP.NET Core MVC: controllers and views port with changes |
| Web Forms (`.aspx`, `.ascx`, `ViewState`, server controls) | not available | rewrite the pages (Razor Pages, Blazor, MVC) |
| WCF service host (`ServiceHost`, `.svc`) | no WCF server | CoreWCF, or REST or gRPC |
| WCF client (`ChannelFactory`, `Reference.cs`) | works with packages | `System.ServiceModel.*` packages; regenerate with `dotnet-svcutil` |
| ASMX (`.asmx`, `[WebMethod]`) | not available | REST or CoreWCF; regenerate the clients |
| .NET Remoting, `AppDomain.CreateDomain`, Code Access Security | not available | gRPC, REST or named pipes; `AssemblyLoadContext`; separate processes |
| `BinaryFormatter`, `SoapFormatter`, `NetDataContractSerializer` | removed or unsupported | `System.Text.Json`, `DataContractSerializer`; check data already stored in that format |
| `Thread.Abort`, `Delegate.BeginInvoke` | throw `PlatformNotSupportedException` | cancellation tokens, `Task.Run` |
| MSMQ (`System.Messaging`), COM+ (`System.EnterpriseServices`), Workflow Foundation | not available | another queue, or keep that part in a .NET Framework sidecar; rewrite COM+ parts; CoreWF |
| LINQ to SQL (`.dbml`, `DataContext`) | not available | EF Core or Dapper |
| Entity Framework 6 | runs on .NET | keep EF6, or move to EF Core |
| `app.config` / `web.config` settings | different model | `System.Configuration.ConfigurationManager` package; ASP.NET Core configuration |
| WinForms, WPF, `System.Drawing`, registry, event log, WMI, `System.DirectoryServices` | Windows only | fine on Windows; a Linux or container target needs replacements |
| COM, Office interop, `DllImport`, 32-bit native DLLs | Windows only, same bitness | an x86 build, or a wrapper process |
| Crystal Reports, ReportViewer | limited or no support | check the vendor; often the reports are rewritten |
| NuGet packages with no .NET or .NET Standard build | won't restore | upgrade, replace, or a sidecar |
| C++/CLI mixed-mode assemblies | needs a recompile | C++/CLI for .NET, Windows only |

For VBA, VB6, classic ASP and VBScript there's nothing to port: the logic is rewritten.

## 3. Logic: where the business rules live

| Signal | What to look for |
|---|---|
| Logic weight per file | `heavy`: calculations, validations, rules, status changes, many branches. `some`. `none`: plumbing, UI layout, generated code |
| Logic in the UI | rules, SQL or calculations inside event handlers (`Button_Click`, `Form_Load`, `AfterUpdate`, `Page_Load`) |
| Logic in the database | the stored procedures, triggers and views the component calls, by name |
| Rules in several places | the same calculation or check in more than one file (count and examples) |
| Fixed values | magic numbers, status codes, hard-coded dates, rates and limits |
| Behaviour that's easy to break | date, time-zone and culture handling, rounding, string formats, transactions (`TransactionScope`, MSDTC), static or global state, error handling that swallows exceptions |
| Tests | test classes in the attached test project, and the classes they exercise (by name) |

## 4. File roles

One per file: `form` · `view` · `controller` · `service` · `job` · `data` · `model` · `logic`
· `utility` · `config` · `script` · `report` · `test` · `generated` (`*.Designer.*`,
`Reference.*`, `AssemblyInfo.*`, `*.g.cs`, `TemporaryGeneratedFile_*`) · `resource`
(`.resx`, images).

Generated files and resources are listed, not read.
