#----- Disable SMBv1 on Windows Servers 2016 and Newer -----#
# Detect: Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol #

# SMBv1 Object
$SMBv1 = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol

# Detect if SMBv1 exists
if($SMBv1.State -eq "Disabled") {
    Write-Output "SMBv1 is already Disabled"
} else { 
    # Disable SMBv1
    Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
}

# Disable SMB Null Sessions

New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Name RestrictAnonymous -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Name RestrictAnonymousSAM -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Name EveryoneIncludesAnonymous -Value 0 -PropertyType DWORD -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -Name "NullSessionPipes" -Value @()


##############################################################################################


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
