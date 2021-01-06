BeforeAll {
    # load the script
    . ./ConvertTo-MarkdownTable.ps1
}

Describe "ConvertTo-MarkdownTable" {

    Context "-InputObject provided Only" {
        It "returns string array" {
            $customObject = [PSCustomObject]@{a=1;c=3;b=2;d=4}
            $result = ConvertTo-MarkdownTable -InputObject $customObject
            $result.count | Should -BeGreaterOrEqual 1
        }
    }
    Context "-Jira provided" {
        It "uses '||' as header separator" {
            $customObject = [PSCustomObject]@{a=1;c=3;b=2;d=4}
            $result = ConvertTo-MarkdownTable -InputObject $customObject -Jira
            $result[0] | Should -BeLike "*||*"
        }
    }
    Context "-ReplaceNewline provided" {
        It 'replaces val CRLF with HTML line break' {
            $customObject = [PSCustomObject]@{
                a="multi`r`nline`r`ntext"
                c=3
                b=2
                d=4
            }
            $result = ConvertTo-MarkdownTable -InputObject $customObject -ReplaceNewline
            $result[2] | Should -BeLike "*<br>*"
        }
    }
}