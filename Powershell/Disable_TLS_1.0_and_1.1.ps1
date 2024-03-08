### --- A Script that Disables TLS 1.0 and 1.1, on Windows Machines to Patch a Vulnerability --- ###

# Command to check if Regkey exists
# Get-ItemProperty -Path "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\SCHANNEL\\Protocols\\TLS 1.0\\Server"

# Define the registry path and key name for TLS 1.0 and 1.1
$registryPath = "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\SCHANNEL\\Protocols\"

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

        # Create new DWORDs 'Enabled' and 'DisabledByDefault'. Set the Enabled Value to 0 and the 'DisabledByDefault' value to 1
        New-ItemProperty -Path ($registryPath + $item + "\Server") -Name 'Enabled' -value '0' -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path ($registryPath + $item + "\Client") -Name 'Enabled' -value '0' -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path ($registryPath + $item + "\Server") -name 'DisabledByDefault' -value 1 -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path ($registryPath + $item + "\Client") -name 'DisabledByDefault' -value 1 -PropertyType DWORD -Force | Out-Null
        
    }

    # Restart the machine
    # Restart-Computer -Force

} else {

    # Return an error if the path doesn't exist
    Write-Host "This path doesn't exist! No changes were made."

}
