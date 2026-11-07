# Technology signals

How to tell what a component is built with, and which version, from its files. Name a
technology or a version only when a file shows it; otherwise write "not declared". Used by
`/mod-discover` Step 1.

## 1. Markers (census)

Skip build output and package folders: `bin`, `obj`, `packages`, `node_modules`, `.vs`,
`TestResults`, `dist`, `out`.

| Marker | Means |
|---|---|
| `*.sln` | Visual Studio solution (a grouping) |
| `*.csproj`, `*.vbproj`, `*.fsproj` | .NET project |
| `*.vcxproj`, `*.vcproj` | C++ project |
| `*.vbp`, `*.vbg` | VB6 project or project group |
| `*.accdb`, `*.mdb`, `*.accde`, `*.mde`, `*.accda`, `*.mda`, `*.adp` | Access database (binary) |
| a folder with `*.bas`, `*.cls`, `*.frm`, `*.form`, `*.report`, `*.qry`, or `vcs-options.json` | Access / VBA text export |
| `*.xlsm`, `*.xlam`, `*.xla`, `*.dotm` | Office file with VBA (binary) |
| `*.sqlproj`, folders of `*.sql` | Database project or SQL scripts |
| `*.dtproj`, `*.dtsx`, `*.ispac` | SSIS |
| `*.rptproj`, `*.rdl`, `*.rdlc`, `*.rpt` | SSRS or Crystal reports |
| `web.config` + `Global.asax` | ASP.NET web application |
| `*.svc`, `*.asmx` | WCF or ASMX service host |
| `package.json` | JavaScript / TypeScript package |
| `pom.xml`, `build.gradle` | Java |
| `pyproject.toml`, `requirements.txt`, `setup.py` | Python |
| `*.bat`, `*.cmd`, `*.ps1`, `*.vbs`, `*.sh` | Scripts |
| Task Scheduler `*.xml` with `<Task`, `*.job` | Scheduled tasks |
| `*.wixproj`, `*.vdproj`, `*.iss`, `*.nsi` | Installer |
| `*.dll`, `*.exe`, `*.ocx` outside build output | Binaries checked into the repo |

## 2. Details per kind

### .NET projects

| Field | Where |
|---|---|
| Language | `.csproj` C#, `.vbproj` VB.NET, `.fsproj` F#; `<LangVersion>` if declared |
| Kind | `<ProjectTypeGuids>` (below); `<OutputType>`: `WinExe` (desktop), `Exe` (console or service), `Library`; WinForms: `System.Windows.Forms` + `*.Designer.cs` forms, or `<UseWindowsForms>`; WPF: `App.xaml`, or `<UseWPF>`; Windows service: `ServiceBase`, `ServiceInstaller`; web: `web.config` + `Global.asax`, `.aspx` (Web Forms), controllers + views (MVC) |
| Framework + version | old format: `<TargetFrameworkVersion>v4.7.2</…>`; SDK format (`<Project Sdk="Microsoft.NET.Sdk…">`): `<TargetFramework>` / `<TargetFrameworks>` (`net48`, `net8.0-windows`); web: `<compilation targetFramework=` and `<httpRuntime targetFramework=` in `web.config` |
| MVC / Web API version | `Microsoft.AspNet.Mvc` / `Microsoft.AspNet.WebApi` package version, or `System.Web.Mvc, Version=…` in `web.config` assemblies or binding redirects |
| Project format / build | old format with `ToolsVersion=` (MSBuild version) or SDK format; `.sln` header `# Visual Studio Version 17` (VS 2022), `16` (2019), `15` (2017), `# Visual Studio 14` (2015) |
| Output | `<AssemblyName>` + `<OutputType>` |
| Platform target | `<PlatformTarget>` (`x86`, `x64`, `AnyCPU`), `<Prefer32Bit>` |
| Hosting / runtime | IIS (`web.config`, `.svc`), Windows service, desktop, console, Office add-in |
| Data access | `EntityFramework` package version, `.edmx` (database first), `DbContext`, LINQ to SQL `.dbml`, Dapper, NHibernate, Enterprise Library Data, plain ADO.NET (`SqlConnection`, `SqlCommand`) |
| Notable libraries | `packages.config` `<package id= version=`, `<PackageReference Include= Version=`, `Directory.Packages.props`; UI suites (DevExpress, Telerik, Infragistics, ComponentOne, Syncfusion), reporting (`CrystalDecisions.*`, `Microsoft.ReportViewer.*`), logging (log4net, NLog, Serilog), Office interop |
| Entry point | `Program.cs` `Main`, `App.xaml`, `Global.asax` `Application_Start`, `Startup.cs`, `ServiceBase.Run` |
| Exposes | routes (`RouteConfig.cs`, `[Route(`, controllers), `[ServiceContract]`, `.svc` / `.asmx`, `[ComVisible(true)]` + `[ProgId(`, a Windows service `ServiceName` |
| Config | `app.config`, `web.config` and their transforms: section and key names only |
| Size | counts of `*.cs` / `*.vb`, forms (`*.Designer.cs`), windows (`*.xaml`), controllers (`*Controller.cs`), views (`*.cshtml`, `*.vbhtml`, `*.aspx`) |
| Tests | test projects that reference it; MSTest, NUnit or xUnit packages |

Common `<ProjectTypeGuids>`:

| GUID | Means |
|---|---|
| `FAE04EC0-301F-11D3-BF4B-00C04F79EFBC` | C# |
| `F184B08F-C81C-45F6-A57F-5ABD9991F28F` | VB.NET |
| `349C5851-65DF-11DA-9384-00065B846F21` | ASP.NET Web Application (also MVC 5) |
| `E3E379DF-F4C6-4180-9B81-6769533ABE47` | ASP.NET MVC 4 |
| `E53F8FEA-EAE0-44A6-8774-FFD645390401` | ASP.NET MVC 3 |
| `60DC8134-EBA5-43B8-BCC9-BB4BC16C2548` | WPF |
| `3D9AD99F-2412-4246-B90B-4EAA41C64699` | WCF Service Library |
| `3AC096D0-A1C2-E12C-1390-A8335801FDAB` | Test project |
| `BAA0C2D2-18E2-41B9-852F-F413020CAA33` | Office / VSTO add-in |

### Access and Office VBA

| Field | Where |
|---|---|
| Kind | `.accdb` / `.mdb` application; `.accde` / `.mde` compiled (no source inside); a file named like `*_be`, `*Data*`, `*Backend*` is probably the back end of a split database (inferred from the name) |
| Version | file format: `.mdb` = Access 2003 or earlier format, `.accdb` = Access 2007 or later (inferred from the extension); in a text export, `AccessVersion` in `dbs-properties.json` if present |
| Readability | binary unless a text export exists (`.bas`, `.cls`, `.form`, `.report`, `.qry` / `.sql`, `.mac`, `vcs-options.json`) |
| Entry point | `AutoExec` macro, startup form in the database properties |
| Data access | DAO (`CurrentDb`, `DAO.Recordset`), ADO (`ADODB.`), linked tables |
| References | `references.json`, `vbe-project.json` |
| Size | number of forms, reports, queries, modules, macros |

### VB6

`.vbp`: `Type=Exe | OleDll | OleExe | Control`, `ExeName32=`, `Startup=`, `Reference=` (COM
references), `Object=` (ActiveX controls). Forms are `.frm`; `.frx` files are binary.

### Databases and ETL

- `.sqlproj` `<DSP>`: `Sql100` = SQL Server 2008, `Sql110` = 2012, `Sql120` = 2014, `Sql130` =
  2016, `Sql140` = 2017, `Sql150` = 2019, `Sql160` = 2022.
- SQL scripts: counts of `CREATE TABLE`, `CREATE PROCEDURE`, `CREATE VIEW`,
  `CREATE TRIGGER`; `COMPATIBILITY_LEVEL`.
- SSIS: `.dtproj` `<DeploymentModel>`, `PackageFormatVersion` in `.dtsx` (cite it as is).
- Reports: the namespace year in `.rdl` (`…/reporting/2016/01/reportdefinition`); `.rpt` is
  Crystal and binary.

### Web front ends, Java, Python, scripts

- JavaScript: `package.json` dependencies with versions (Angular, React, jQuery, Knockout,
  Bootstrap); in ASP.NET projects, library files in `Scripts/` (e.g. `jquery-1.10.2.js`).
- Java: `<java.version>` or `<maven.compiler.source>` in `pom.xml`; framework versions from
  the dependencies.
- Python: `requires-python` or the interpreter named in the files.
- Scripts: the interpreter from the extension; `#Requires -Version` in PowerShell.

## 3. Modernization signals worth noting

Facts, with evidence, for the component's § Modernization signals:
- out-of-support platform (inferred from the vendor's lifecycle): .NET Framework 4.6.1 or
  older, .NET Core and .NET 5–7, VB6, Access / Office 2016 or older;
- 32-bit only (`x86`, `Prefer32Bit`), often because of COM, Office or Access drivers;
- COM, ActiveX or Office automation;
- binary-only source (Access binaries, `.accde`, `.frx`, checked-in DLLs without source);
- old web stacks: Web Forms, ASMX, WCF, .NET Remoting;
- hard-coded paths, server names or drive letters;
- no tests found.
