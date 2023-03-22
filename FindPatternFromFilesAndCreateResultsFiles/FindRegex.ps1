#.\FindRegex.ps1 -InputFilePath .\input\logs.txt -RegexPattern "[A-Z][0-9]{3}"  -MatchFileNames -PrintResults

Param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$InputFilePath,
    [Parameter(Mandatory=$true, Position=1)]
    [string]$RegexPattern,
    [Parameter(Mandatory=$false, Position=2)]
    [switch]$MatchFileNames=$false,
    [Parameter(Mandatory=$false, Position=3)]
    [switch]$PrintResults=$false
)

$DirectoryPath = "output"

# Read the input file and group the matching lines by the first letter of the match
$Matches = Get-Content $InputFilePath | Select-String -Pattern $RegexPattern | ForEach-Object { $_.Matches.Value } | Select-Object -Unique

if (-not (Test-Path -Path $DirectoryPath -PathType Container)) {
    New-Item -ItemType Directory -Path $DirectoryPath | Out-Null
    Write-Host "Directory created: $DirectoryPath"
} else {
    Write-Host "Directory already exists: $DirectoryPath"
}

# Iterate over each group of matches and write them to a separate output file
foreach ($Match in $Matches) {
    $MatchLines = Select-String -Path $InputFilePath -Pattern $Match | ForEach-Object { $_.Line }
    
    if($PrintResults)
    {
        Write-Output "Match: $Match"
        Write-Output "Lines:"
        $MatchLines | ForEach-Object { Write-Output "  $_" }
    }

    $OutputFileName = [Guid]::NewGuid().ToString()

    if($MatchFileNames)
    {
        $MatchLines | Out-File "${DirectoryPath}\${Match}.txt"
    } else {
        $MatchLines | Out-File "${DirectoryPath}\${OutputFileName}.txt"
    }
}
