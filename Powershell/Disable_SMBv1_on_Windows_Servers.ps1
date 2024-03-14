# Disable SMBv1 on Windows Servers 2016 and Newer #

# SMBv1 Object
$SMBv1 = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol

# Detect if SMBv1 exists
if($SMBv1.State -eq "Disabled") {
    Write-Output "SMBv1 is already Disabled"
} else {
    #SMBv2 Object Check
    $SMB2ProtocolEnabled = (Get-SmbServerConfiguration).EnableSMB2Protocol
    if ($SMB2ProtocolEnabled) {
        # Disable SMBv1
        Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
    }
}


# For Windows Server 2012 #

# SMBv1 Feature Name
$featureName = "FS-SMB1"

# Check if SMBv1 is installed
if ((Get-WindowsFeature -Name $featureName).InstallState -eq "Installed") {
    #SMBv2 Object Check
    $SMB2ProtocolEnabled = (Get-SmbServerConfiguration).EnableSMB2Protocol
    if ($SMB2ProtocolEnabled) {
        # Disable SMBv1
        Remove-WindowsFeature -Name $featureName
        Write-Output "SMBv1 has been disabled."
    }
} else {
    Write-Output "SMBv1 is already Disabled"
}
