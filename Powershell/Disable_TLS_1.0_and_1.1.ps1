### --- A Script that Disables TLS 1.0 and 1.1, on Windows Machines to Patch a Vulnerability --- ###

# Define the registry path and key name for TLS 1.0 and 1.1
#$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS1.0\Client"

# Start-Process -FilePath "regedit"

# Command to check if Regkey exists
# Get-ItemProperty -Path "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\SCHANNEL\\Protocols\\TLS 1.0\\Server"

$registryPath = "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\SCHANNEL\\Protocols\"
$keyName = "Enabled"
$value = 0

# If the registry path exists, then create the nested keys and DWORDs
if(Test-Path $registryPath) {

    # Keys to be created
    $pathArray = @("TLS 1.0", "TLS 1.1")

    foreach ($item in $pathArray) {

        # Create registry key 
        New-Item -Path ($registryPath + $item) -Force | Out-Null

        # Create new keys with the names Server and Client
        New-Item -Path ($registryPath + $item + "\Server") -Force | Out-Null
        New-Item -Path ($registryPath + $item + "\Client") -Force | Out-Null

        # Create new DWORD Values and set the Enabled property to 0
        New-ItemProperty -Path ($registryPath + $item + "\Server") -Name $keyName -Value $value -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path ($registryPath + $item + "\Client") -Name $keyName -Value $value -PropertyType DWORD -Force | Out-Null
    }

    # Restart the machine
    # Restart-Computer -Force

} else {

    # Return an error if the path doesn't exist
    Write-Host "This path doesn't exist! No changes were made."

}
