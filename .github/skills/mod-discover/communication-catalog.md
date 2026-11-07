# Communication catalog

Every way one component can depend on or talk to another, and what to search for. These are
fingerprints, not assumptions: report only what a file shows. Used by `/mod-discover` Step 2.

The **key** is the mechanism name used in every table and graph label.

## 1. Mechanisms

### Build time: linked when the code is built

| Key | What | Search for |
|---|---|---|
| `project-ref` | Project reference | `<ProjectReference Include=` in `*.csproj` / `*.vbproj` / `*.fsproj` / `*.vcxproj`; `ProjectDependencies` in `.sln` |
| `dll-ref` | Reference to a compiled DLL of another component | `<Reference Include=…><HintPath>` to a non-framework DLL; DLLs checked into `lib/`, `libs/`, `ThirdParty/`, `References/`; GAC references with no HintPath |
| `package` | Internal package built by another component | `packages.config` `<package id=`, `<PackageReference Include=`, `package.json` dependencies, whose ID matches another component's `<PackageId>`, `.nuspec` or package name; internal feeds in `NuGet.config` |
| `shared-source` | The same source compiled into several components | `<Compile Include="..\…" ><Link>`; `.shproj` / `.projitems` imports; `<Import Project="..\…\*.targets">`; the same file or class name in several projects (count + examples) |
| `deploy` | Built or shipped together | `PostBuildEvent` / `PreBuildEvent` with `xcopy` / `copy` into another project's folder; MSBuild `<Copy>` targets; installer projects (`.wixproj`, `.vdproj`, `.iss`, `.nsi`) that bundle several components; ClickOnce manifests |

### Interop: one component loads or drives another in-process or via the OS

| Key | What | Search for |
|---|---|---|
| `com` | COM / ActiveX | `<COMReference>`, `Interop.*.dll`, `Type.GetTypeFromProgID`, `Marshal.GetActiveObject`; VBA/VB6 `CreateObject("`, `GetObject(`; exposing side: `[ComVisible(true)]`, `[ProgId(`, `<RegisterForComInterop>`, `regasm` / `regsvr32` in scripts; `.ocx` |
| `native` | Native DLL calls | `[DllImport("`, `LoadLibrary`; VBA/VB6 `Declare Function` / `Declare PtrSafe Function … Lib "` |
| `office` | Office automation | `Microsoft.Office.Interop.*`, `Excel.Application`, `Word.Application`, `Outlook.Application`, `Access.Application`, `DoCmd.TransferSpreadsheet`, `DoCmd.OutputTo`, `Workbooks.Open` |
| `vba-ref` | Access / Excel / VB6 project references | in text exports: `references.json`, `vbe-project.json`, `Reference=` lines; library databases (`.accda`, `.mda`); `Application.Run "<file>!<macro>"`; VB6 `.vbp` `Reference=` and `Object=` lines |

### Process: one component starts or controls another

| Key | What | Search for |
|---|---|---|
| `cli` | Launching an exe or script (CLI, shell) | `Process.Start(`, `ProcessStartInfo`, VBA/VB6 `Shell(`, `ShellExecute`, `WScript.Shell` `.Run` / `.Exec`, `cmd /c`, `Start-Process`, `& "….exe"`, `call ….bat`, `xp_cmdshell`, `msaccess.exe … /x <macro>`, `/cmd` arguments; SSIS Execute Process tasks. Return the exe or script name and the argument pattern (secrets as `<SECRET>`) |
| `scheduler` | Started on a schedule | Task Scheduler exports (`<Task` … `<Exec><Command>`), `schtasks /create`, SQL Agent (`sp_add_job`, `sp_add_jobstep`), cron files, Hangfire / Quartz registrations, timers inside a Windows service |
| `service-control` | Starting or stopping a Windows service | `ServiceController`, `sc start` / `sc stop`, `net start` / `net stop`; exposing side: `ServiceBase`, `ServiceInstaller` `ServiceName =` |

### Network: talking over a protocol

| Key | What | Search for |
|---|---|---|
| `http` | HTTP / REST calls | `HttpClient`, `WebClient`, `HttpWebRequest`, `RestSharp`, `Flurl`; JavaScript `$.ajax`, `$.get`, `$.post`, `fetch(`, `axios`, `XMLHttpRequest`; VBA `MSXML2.ServerXMLHTTP`, `WinHttp.WinHttpRequest`; config keys holding URLs (`Url`, `Endpoint`, `BaseAddress`, `ApiRoot`). Exposing side: controllers, `[Route(`, `RouteConfig`, `WebApiConfig`, `MapRoute` |
| `soap-wcf` | SOAP, WCF, ASMX | `Service References/`, `Connected Services/`, `.svcmap`, `.wsdl`, generated `Reference.cs` / `Reference.vb`, `<system.serviceModel>` `<client><endpoint address= contract=`, `ChannelFactory<`, `SoapHttpClientProtocol`, VBA `MSSOAP.SoapClient`. Exposing side: `.svc`, `.asmx`, `[ServiceContract]`, `<services><service` |
| `pipe-socket` | Remoting, named pipes, sockets, gRPC, SignalR | `RemotingConfiguration`, `MarshalByRefObject`, `tcp://`, `ipc://`, `NamedPipeClientStream` / `NamedPipeServerStream`, `TcpClient`, `TcpListener`, `Socket`, `UdpClient`, `.proto`, `Grpc.`, SignalR `Hub`, `HubConnection` |
| `messaging` | Queues and topics | `System.Messaging`, `MessageQueue`, `FormatName:`, `.\private$\`; RabbitMQ (`BasicPublish`, `BasicConsume`); Azure Service Bus; Kafka; MassTransit, NServiceBus; SQL Service Broker (`SEND ON CONVERSATION`, `RECEIVE`) |
| `email-ftp` | E-mail, FTP, SFTP as an integration | `SmtpClient`, `MailMessage`, `<mailSettings>`, `CDO.Message`, `Outlook.MailItem`, `DoCmd.SendObject`, `sp_send_dbmail`; `FtpWebRequest`, WinSCP, SSH.NET, `ftp -s:` |

### Data: coupling through shared state (often hidden)

| Key | What | Search for |
|---|---|---|
| `db` | Shared database | `<connectionStrings>`, connection keys in `appSettings`, `SqlConnection(`, `OleDbConnection(`, `OdbcConnection(`, `ADODB.Connection`, `.ConnectionString =`, `Data Source=`, `Initial Catalog=`, `Database=`; `DbContext` classes, `.edmx`, `.dbml`, ORM mappings; SQL in code (`SELECT … FROM`, `INSERT INTO`, `UPDATE`, `DELETE FROM`, `MERGE`, `EXEC`, `CommandType.StoredProcedure`). Return server and database names (never credentials), and the tables and procedures each component reads or writes |
| `linked-table` | Access linked tables and ODBC | linked-table connect strings in exports (`ODBC;DRIVER=…;DATABASE=…`, `;DATABASE=<path>.accdb` for a split front end / back end), `DoCmd.TransferDatabase acLink`, `TableDefs`, `.Connect =`, DSN names, pass-through queries |
| `cross-db` | One database reaching another | four-part names `[server].[db].[schema].[object]`, three-part `db.dbo.object`, `OPENQUERY`, `OPENROWSET`, `OPENDATASOURCE`, `sp_addlinkedserver`, synonyms |
| `file` | Files, folders and shares | UNC paths `\\server\share\…`, DFS namespaces, mapped drives (`X:\`), absolute paths, config keys that hold folders; `File.Write*`, `StreamWriter`, `File.Read*`, `StreamReader`, `Directory.GetFiles`, `FileSystemWatcher`; VBA `Open … For Output` / `For Input`, `FileSystemObject`, `DoCmd.TransferText`, `TransferSpreadsheet`; `bcp`, `BULK INSERT`, SSIS flat-file connections. Return the path pattern, the format (CSV, XML, fixed width, Excel, PDF) and read or write |
| `config` | Shared configuration, registry or environment | `configSource=`, `file=` on `appSettings`, a shared `.ini` (`GetPrivateProfileString`), `Registry.` / `RegistryKey`, VBA `GetSetting` / `SaveSetting`, `RegRead` / `RegWrite`, `Environment.GetEnvironmentVariable`, `Environ(` |
| `cache` | Shared session or cache | `<sessionState mode="StateServer"` or `"SQLServer"`, Redis, memcached, AppFabric, `machineKey` shared between web apps |

### UI and reports

| Key | What | Search for |
|---|---|---|
| `ui-link` | One UI opens or embeds another | links and redirects to another app (`href="http…"`, `Response.Redirect(`, `RedirectToAction` across apps, `Process.Start("http…")`, VBA `FollowHyperlink`), `WebBrowser` / `WebView2` controls, iframes, custom URL protocols, shared forms-auth cookie (`<forms domain=`, same `machineKey`) |
| `report` | Reports run by another engine or component | SSRS (`ReportViewer`, `.rdl` / `.rdlc`, `ReportServerUrl`, `/ReportServer?`), Crystal (`ReportDocument`, `.rpt`), Access `DoCmd.OpenReport`, Excel or Word templates filled by code |

### Outside the boundary

| Key | What | Search for |
|---|---|---|
| `external` | A system with no source here | the target of any mechanism above that resolves outside the repo: vendor or partner APIs, ERP / CRM, payment, partner FTP, licensed DLLs and SDKs |

## 2. What to search per component kind

Keep briefs small: send only the mechanisms that fit the kind. Every kind also gets the
shared-resource sweep (Step 2b).

| Component kind | Mechanisms |
|---|---|
| .NET desktop (WinForms, WPF, console) | project-ref, dll-ref, package, shared-source, deploy, com, native, office, cli, service-control, http, soap-wcf, pipe-socket, messaging, email-ftp, db, file, config, ui-link, report |
| .NET web (MVC, Web Forms, Web API, WCF or ASMX host) | the desktop list + cache, plus the exposing side of http and soap-wcf; search the views and scripts for http and ui-link |
| .NET class library | project-ref, dll-ref, package, shared-source, com (exposing too), native, office, http, soap-wcf, messaging, db, file, config |
| Windows service, scheduled console job | the desktop list + scheduler |
| Access or Excel VBA (text export) | vba-ref, linked-table, db, com, native, office, cli, file, email-ftp, config, http, report |
| Access or Excel binary only | none inside. Search the **other** components for references to it: its file name, macro names, its back-end file, its DSN |
| VB6 | vba-ref, com (exposing too), native, office, cli, db, file, config, email-ftp |
| Database project or SQL scripts | cross-db, scheduler (Agent jobs), messaging (Service Broker), email-ftp (Database Mail), cli (`xp_cmdshell`), file (`BULK INSERT`, `bcp`) |
| SSIS / ETL | db, cross-db, file, email-ftp, cli, scheduler |
| Scripts (`.bat`, `.cmd`, `.ps1`, `.vbs`, `.sh`) | cli, file, db (`sqlcmd`, `osql`, `Invoke-Sqlcmd`), scheduler, service-control, email-ftp |
| Web front end (JavaScript / TypeScript package) | package, http, ui-link |

## 3. Resolving a target hint

| The code names… | It points to… |
|---|---|
| a project path | that project's component |
| an assembly or DLL name | the component whose `<AssemblyName>` matches; otherwise a third-party library (Technology, not a link) |
| an exe or script name | the component whose output or script it is; `msaccess.exe … <file>` → that Access component |
| a URL, route or endpoint key | the web component that hosts that route or virtual directory; a host outside the repo → `external` |
| a service contract | the component that defines `[ServiceContract]` for it, or hosts the `.svc` / `.asmx` |
| a ProgID | the component with the matching `[ProgId]` or VB6 project name; otherwise `external` |
| a Windows service name | the component with that `ServiceName` |
| a database name | one **database** resource per server + database; each user is a writer, a reader or both |
| a file path or config key holding one | one **file share** resource per path pattern (resolve config keys to the same path). A path with writers but no reader, or the other way round, gets a question (Kind Operations) |
| a queue or topic name | one **queue** resource; publishers write, consumers read |
| a scheduled task | a **scheduler** resource → the component it starts (`scheduler` link, from the component to the scheduler) |

Nothing matches → a question (Kind Integration), and the link stays with the target
`? <hint>`.
