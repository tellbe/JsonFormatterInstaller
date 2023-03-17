<#
.Synopsis
    A simple Cmdlet for removing certain values from json string
.DESCRIPTION
    A simple Cmdlet for removing certain values from json string
.EXAMPLE
    Start-JsonFormatter -Input JsonString -Remove [{value1 -TrailingChars "(", ")" }, value 2, value 3]
#>
function Start-JsonFormatter{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$input,
        [Parameter(Mandatory=$true,Position=1)]
        [string[]]$remove,
        [Parameter(Position=2)]
        [hashtable]$trailingChars
    )

    Process
    {
        $pattern = '\b' + ($remove | ForEach-Object {[regex]::Escape($_)}) -join '|' + '\b'

        # Loop through each value to remove
        foreach ($value in $remove) {
            # Check if the value has trailing characters defined
            if ($trailingChars.ContainsKey($value)) {
                # If trailing characters are defined, add them to the regex pattern
                $pattern = $pattern -replace $value, ($value + [regex]::Escape($trailingChars[$value]))
            }
        }
        # Use regex to remove specified values from input string
        $output = $input -replace $pattern, ''

        # Get current date
        $dateTime = Get-Date -format o
        # Add file name to outPath
        $outPath = Join-String [$outPath, "FormattedInput_", $dateTime, ".json"] ToString

        # Output result to specified file path
        $output | Out-File -FilePath $outPath -Encoding UTF8

        # Output success message
        Write-Output "Output written to: " .\

    }
}
function Start-JsonFormatterInitiator {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$fileName,
        [Parameter(Mandatory=$true,Position=1)]
        [string[]]$remove,
        [Parameter(Position=2)]
        [hashtable]$trailingChars
    )

    Process
    {
        $inputJson = Get-Content -Path .\$fileName

        $inputJson = $inputJson -replace ('"', '`"')

        Write-Output "Json data handled. Quote characters replaced"

        Start-JsonFormatter -input $inputJson.ToString() -remove $remove -trailingChars $trailingChars
    }
}