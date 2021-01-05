<H1>ConvertTo-MarkdownTable</H1>

Converts an object into a markdown table. Similar to `ConvertTo-Html` or `ConvertTo-Csv`.

<H2>PARAMETERS</H2>

`-InputObject`
Object to convert to markdown table. Object properties are column headers.

`-Jira`
If specified, uses Jira-style table column headers.

`-ReplaceNewline`
If specified, replaces carriage return/line feed with HTML `<br>` tag.

<H2>EXAMPLES</H2>
<H3>Example 1</H3>

```powershell
ConvertTo-MarkdownTable -InputObject ( Get-ChildItem )
```

<H3>Example 2</H3>

```powershell
$result = Invoke-Sqlcmd -ServerInstance "databaseServer" -Database "testDB" -Query "select * from table"

ConvertTo-MarkdownTable -InputObject $result -Jira -Verbose
```

<H2>Other Notes</H@>
Converts a PowerShell object to a Markdown table. Better than Atlassian's Format-Jira.

Will optionally convert `CRLF` to HTML `<br>` tags (for example, for use with GitHub), or use double pipes ("||") as the header column separator for use with Atlassian Jira or similar systems.