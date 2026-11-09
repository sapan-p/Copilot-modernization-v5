# Runtime differences: .NET Framework to .NET

Code that ports without a single change can still behave differently, because the runtime
under it changed. `/mod-deepdive` lists the ones that touch each port step's files as its
behaviour risks, each with a test that pins the legacy behaviour; `/mod-implement` keeps them
in mind while porting. Mark a test `run legacy` when the expected value depends on the old
runtime rather than on the code.

Search the step's files for the signals; report only what a file shows.

| Area | What changed | Signals in the code | Test it with |
|---|---|---|---|
| Culture data | .NET 5 and later use ICU instead of Windows NLS: culture-aware comparison, sorting, `IndexOf`, casing, and date, number and currency formats can differ | `string.Compare`, `CompareTo`, `OrderBy` on strings, `ToUpper`/`ToLower`, `IndexOf(string)`, `ToString("…")` or `ToString(CultureInfo)` on dates and numbers | the strings, sort orders and formatted values the code produces, under the culture legacy runs with |
| Floating-point text | since .NET Core 3.0, `double` and `float` format as the shortest round-trippable text, and parsing follows IEEE | `double` or `float` turned into text: `ToString()`, interpolation, concatenation, `Convert.ToString` | the exact text of values such as 0.1 + 0.2, large and tiny values |
| Default encoding | `Encoding.Default` is UTF-8, not the Windows code page; code pages such as 1252 need `CodePagesEncodingProvider` | `Encoding.Default`, `GetEncoding(1252)`, `StreamReader` or `File.ReadAllText` without an encoding, byte-level text handling | reading and writing text with non-ASCII characters |
| Hash codes | `string.GetHashCode()` differs on every run | hash codes stored, sent, or used for ordering or partitioning | that nothing depends on a hash value; a stored hash is a question |
| Binary serialization | `BinaryFormatter` is obsolete, and fails from .NET 9 | `BinaryFormatter`, `[Serializable]` payloads, `ISerializable` | the bytes or objects a caller relies on; usually a blocker with a replacement |
| JSON at the boundary | ASP.NET Core uses `System.Text.Json` with camelCase names by default; Web API 2 used Newtonsoft with the names as written | API controllers returning objects, `JsonConvert`, JSON attributes | the exact JSON a client receives: names, casing, dates, numbers, nulls |
| Starting processes | `Process.Start` uses `UseShellExecute = false` by default, so opening a document or URL fails | `Process.Start("<file or URL>")` | that the document or URL still opens |
| SQL Server client | `Microsoft.Data.SqlClient` encrypts by default from version 4; the old `System.Data.SqlClient` didn't | connection strings, `SqlConnection` | that the connection opens with the same settings (a configuration question, not code) |
| Entity Framework | EF Core translates queries differently from EF6: null comparisons, ordering, what runs in memory, lazy loading off by default | `DbContext`, LINQ to Entities, `Include`, navigation properties | the rows and order each query returns for the same data |
| Configuration | `ConfigurationManager` reads `app.config` or `web.config`; ASP.NET Core reads `appsettings.json` and the environment, with other precedence and type conversion | `ConfigurationManager.AppSettings`, `ConnectionStrings`, `WebConfigurationManager` | the value each key resolves to, and what happens when it's missing |
| Regular expressions | from .NET 7, `RegexOptions.IgnoreCase` uses its own casing table | `Regex` with `IgnoreCase`, culture-specific letters | matches on non-ASCII text |
| Hosting on Linux | when the target runs on Linux: paths are case-sensitive, `/` separates folders, time-zone IDs are IANA | path building, `TimeZoneInfo.FindSystemTimeZoneById` | files found and time zones resolved on the target host |
