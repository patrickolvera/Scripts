#!#> Script to replace the currently installed 7zip with the latest version <!#!#

# Grab the URL for the latest version of 7zip as of 7/5/2024
$downloadurl = 'https://7-zip.org/' + (
    Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' |
    Select-Object -ExpandProperty Links |
    Where-Object { ($_.outerHTML -match 'Download') -and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe") } |
    Select-Object -First 1 |
    Select-Object -ExpandProperty href
)

# Grab the latest version from $downloadurl and assign to $latestver
if ($downloadurl -match '7z(\d+)-x64\.exe') {
    $latestver = [int]$Matches[1]
}

# Get the installed version of 7zip
$installedver = ((Get-Package -Name '7-zip*').version -replace '\.', '')

# Check if the installed version is less than the latest version
if ([int]$installedver -lt $latestver) {
    # Get the GUID of the installed 7zip
    $7zip = $installedPrograms | Where-Object { $_.PSChildName -match "7-Zip" }
    $7zipGUID = $7zip.PSChildName

    # Uninstall the current version of 7zip
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/X $7zipGUID /quiet /norestart" -Wait -PassThru

    # Install the latest version
    $installerPath = Join-Path $env:TEMP (Split-Path $downloadurl -Leaf)
    Invoke-WebRequest $downloadurl -OutFile $installerPath
    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait -NoNewWindow
    Remove-Item $installerPath -Force

    Write-Output "7zip updated to version $latestver"
} else {
    Write-Output '7zip is on the latest version'
}
