function ConvertTo-MarkdownTable {
   <#
   .SYNOPSIS
   Converts an object into a markdown table. Similar to ConvertTo-Html or ConvertTo-Csv.
   
   .DESCRIPTION
   Converts an object into a markdown table. Similar to ConvertTo-Html or ConvertTo-Csv.
   
   .PARAMETER InputObject
   Object to convert to markdown table. Object properties are column headers.
   
   .PARAMETER Jira
   If specified, uses Jira-style table column headers.
   
   .PARAMETER ReplaceNewline
   If specified, replaces carriage return/line feed with HTML <br> tag.
   
   .EXAMPLE
   ConvertTo-MarkdownTable -InputObject ( Get-ChildItem )

   .EXAMPLE
   $result = Invoke-Sqlcmd -ServerInstance "databaseServer" -Database "testDB" -Query "select * from table"
   ConvertTo-MarkdownTable -InputObject $result -Jira -Verbose
   
   .NOTES
   Converts a PowerShell object to a Markdown table. Better than Atlassian's Format-Jira.

   Will optionally convert CRLF to HTML <br> tags (for example, for use with GitHub), or use double pipes ("||") as the header column separator for use with Atlassian Jira or similar systems.
   #>

    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
        ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [Object[]]$InputObject,

        [Parameter(Mandatory = $false)]
        [Switch]$Jira,

        [Parameter(Mandatory = $false)]
        [Switch]$ReplaceNewline
    )

    $functionName = $MyInvocation.MyCommand
    $htmlPipe = "&#124;"
    [string[]]$separatorList = @()
    [string[]]$rowData = @()
    [string[]]$markdownTable = @()

    if ( $Jira ) {
        Write-Verbose "$functionName Using Jira-style column headers."
    }
    if ( $ReplaceNewline ) {
        Write-Verbose "$functionName Replacing newlines with HTML <br>."
    }

    # figure out how many pipes need to separate column headers based on user input
    if ( $Jira ) {
        $headerSeparator = "||"
    } else {
        $headerSeparator = "|"
    }


    # build property list
    Write-Verbose "$functionName Parsing properties."
    $propertyList = @()

    foreach ( $i in $InputObject ) {
        $property = $i.psobject.properties.name
        $propertyList += $property
        Write-Verbose "$functionName Adding property name $property"
    }

    $propertyList = $propertyList | Select-Object -Unique

    Write-Verbose "$functionName Found $($propertyList.count) properties."
    
    # build header
    Write-Verbose "$functionName Building header row."
    $header = "$headerSeparator " + ($propertyList -join " $headerSeparator ") + " $headerSeparator"

    # build header separator
    if ( !($Jira) ) {
        Write-Verbose "$functionName Building separator row."
        foreach ( $i in $propertyList ) {
            # add hyphens using padleft to an empty string, based on length of each property in the list
            # needs to be minimum of 3 length
            if ( $i.length -lt 3 ) {
                $separatorLength = 3
            } else {
                $separatorLength = $i.length
            }
            $separatorList += $("").padleft($separatorLength,"-")
        }
        $separator = "| " + ($separatorList -join " `| ") + " |"
    } else {
        Write-Verbose "$functionName User specified -Jira parameter, not building separator row."
    }

    # build each row of data
        Write-Verbose "$functionName Building table rows."
        foreach ( $object in $InputObject ) {
            $tempDataList = @()
            foreach ( $p in $propertyList ) {
                [string]$tempData = $object."$p"
                if ( $tempData -match '\|' ) {
                    # replace '|' in property values with html code
                    Write-Verbose "$functionName replacing '|' with $htmlPipe in value [$tempData]."
                    $tempData = $tempData -replace "\|",$htmlPipe
                }

                # remove any trailing CRLF in each property value
                $tempData = [string]$tempData.trim()

                # replace CRLF with html <br>
                if ( $ReplaceNewline ) {
                    $tempData = $tempData -replace "`r`n","<br>"
                }
                
                $tempDataList += $tempData
            }
            $rowData += "| " + ($tempDataList -join " `| ") + " |"
        }

        # build final markdown table
        Write-Verbose "$functionName Building final table."
        $markdownTable += $header
        if ( !($Jira) ) {
            $markdownTable += $separator
        }
        $markdownTable += $rowData

        # return markdown table
        Write-Verbose "$functionName Returning markdown table."
        $markdownTable
}