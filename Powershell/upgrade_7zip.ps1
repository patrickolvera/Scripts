#!#> Script to replace the currently installed 7zip with the latest version <!#!#

# Grab the url for the latest version of 7zip, as of 7/5/2024 $downloadurl is equivalent to 'https://7-zip.org/a/7z2407-x64.exe'
$downloadurl = 'https://7-zip.org/' + 
    (
        Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | 
        Select-Object -ExpandProperty Links | 
        Where-Object {($_.outerHTML -match 'Download')-and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} | 
        Select-Object -First 1 | 
        Select-Object -ExpandProperty href
    )

$latestver
# Grab the latest version from $downloadurl and assign to ^
if ($downloadurl -match '7z(\d+)-x64\.exe') {
    $latestver = $Matches[1]
}

$installedver = ((Get-Package -Name '7-zip*').version -replace '\.', '')

if ([int]$installedver -lt [int]$latestver ) {
    $7zip = $installedPrograms | Where-Object { $_.PSChildName -match "7-Zip" }
    $7zipGUID = $7zip.PSChildName
    # Uninstall the current version of 7zip
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/X $7zipGUID /quiet /norestart" -Wait -PassThru

    # Install the latest version
    $installerPath = Join-Path $env:TEMP (Split-Path $downloadurl -Leaf)
    Invoke-WebRequest $downloadurl -OutFile $installerPath
    Start-Process -FilePath $installerPath -Args "/S" -Verb RunAs -Wait
    Remove-Item $installerPath
} else {
    echo '7zip is on latest version'
}