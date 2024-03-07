# Disable SMBv1 on Windows Servers #

# SMBv1 Object
$SMBv1 = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol

# Detect if SMBv1 exists
if($SMBv1.State -eq "Disabled") {
    Write-Output "SMBv1 is already Disabled"
} else { 
    # Disable SMBv1
    Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
}
