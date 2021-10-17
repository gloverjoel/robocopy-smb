# https://docs.microsoft.com/en-us/powershell/module/smbshare/new-smbmapping?view=windowsserver2019-ps
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-credential?view=powershell-7.1
# https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
# Command to encrypt password to user
# Get-Credential | Export-CliXml -Path .\example\config.ps1xml

$unc= "\\example.com\example" # UNC path for smb share
$config = ".\example\config.ps1xml" # Path to encrypted credential file
$cred = Import-CliXml -Path $mfconfig # Imports encrypted credential file
$source= "\\example.com\example\example" # Source of directory
$destination= ".\example\example" # Destination of directory

New-SmbMapping -RemotePath $unc -UserName $cred.UserName -Password $cred.GetNetworkCredential().Password -AsJob
ROBOCOPY $source $destination /z /mov /mon:1 /v