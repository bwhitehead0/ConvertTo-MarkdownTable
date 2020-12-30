function ConvertTo-MarkdownTable {
    <#
    .SYNOPSIS
    Converts an object into a markdown table. Similar to ConvertTo-Html or ConvertTo-Csv.

    .DESCRIPTION
    Converts an object into a markdown table. Similar to ConvertTo-Html or ConvertTo-Csv.

    .PARAMETER InputObject
    Object to convert to markdown table. Properties are column headers.

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
        ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [Object[]]$InputObject
    )

    $functionName = $MyInvocation.MyCommand
    $htmlPipe = "&#124;"
    [string[]]$separaterList = @()


    # build property list
    Write-Verbose "$functionName Parsing properties."
    $propertyList = @()

    foreach ( $i in $InputObject ) {
        $propertyList += $i.psobject.properties.name
    }

    Write-Verbose "$functionName Found $($propertyList.count) properties."

    $propertyList = $propertyList | Select-Object -Unique
    
    # build header
    $header = "| " + ($propertyList -join " `| ") + " |"

    # build header separater
    foreach ( $i in $propertyList ) {
        # add hyphens using padleft to an empty string, based on length of each property in the list
        $separaterList += $("").padleft($i.length,"-")
    }

    $separater = "| " + ($separaterList -join " `| ") + " |"

    <#
    function flow:
    
        1.  get inputobject. can't be null.
            a.  should be object w/ properties
        2.  get property names, these are our column headers
        3.  build header string from property names
        4.  foreach thru object, build a new string for table row with each property
            a.  parse each property value, substitute existing '|' characters with html code
        
    table format:
        | Syntax | Description |
        | --- | ----------- |
        | Header | Title |
        | Paragraph | Text |
    #>

}