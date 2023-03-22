#.\FindLike.ps1 -InputFilePath .\input\logs.txt -FilterString "E341"

Param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$InputFilePath,
    [Parameter(Mandatory=$true, Position=1)]
    [string]$FilterString
)

$DirectoryPath = "output"

# Read the input file and filter down to the lines containing the filter string
$matchingLines = Get-Content $InputFilePath | Where-Object { $_ -like "*$FilterString*" }

# Generate a new GUID to use as the name of the output file
$outputFileName = [guid]::NewGuid().ToString() + ".txt"

if (-not (Test-Path -Path $DirectoryPath -PathType Container)) {
    New-Item -ItemType Directory -Path $DirectoryPath | Out-Null
    Write-Host "Directory created: $DirectoryPath"
} else {
    Write-Host "Directory already exists: $DirectoryPath"
}

# Write the matching lines to the output file
$matchingLines | Out-File "${DirectoryPath}/${outputFileName}"