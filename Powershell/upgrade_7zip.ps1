#!#> Script to replace the currently installed 7zip with the latest version or install if 7zip is missing <!#!#

# Grab the URL for the latest version of 7zip as of 7/5/2024 is equivalent to 'https://7-zip.org/a/7z2407-x64.exe'
$downloadurl = 'https://7-zip.org/' + (
    Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' |
    Select-Object -ExpandProperty Links |
    Where-Object { ($_.outerHTML -match 'Download') -and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe") } |
    Select-Object -First 1 |
    Select-Object -ExpandProperty href
)

# Grab the latest version from $downloadurl and assign to $latestver
if ($downloadurl -match '7z(\d+)-x64\.exe') {
    $latestver = $Matches[1]
}

# Function to install 7zip
function Install-7zip {
    param (
        [string]$downloadurl,
        [string]$installerPath
    )

    Invoke-WebRequest $downloadurl -OutFile $installerPath
    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait -NoNewWindow
    Remove-Item $installerPath -Force
    Write-Output "7zip installed to version $latestver"
}

# Check if 7zip is installed by querying the registry
$installed7zip = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | 
    Where-Object { $_.DisplayName -like "7-Zip*" } |
    Select-Object -First 1

if ($installed7zip) {
    # Get the installed version of 7zip
    $installedver = ($installed7zip.DisplayVersion -replace '\.', '')

    # Check if the installed version is less than the latest version
    if ([int]$installedver -lt [int]$latestver) {
        # Uninstall the current version of 7zip
        $uninstallString = $installed7zip.QuietUninstallString
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c $uninstallString" -Wait -NoNewWindow
        
        # Install the latest version
        $installerPath = Join-Path $env:TEMP (Split-Path $downloadurl -Leaf)
        Install-7zip -downloadurl $downloadurl -installerPath $installerPath
    } else {
        Write-Output '7zip is on the latest version'
    }
} else {
    # Install 7zip if not installed
    $installerPath = Join-Path $env:TEMP (Split-Path $downloadurl -Leaf)
    Install-7zip -downloadurl $downloadurl -installerPath $installerPath
}
