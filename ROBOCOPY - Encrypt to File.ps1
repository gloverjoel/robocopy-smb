# https://docs.microsoft.com/en-us/powershell/module/smbshare/new-smbmapping?view=windowsserver2019-ps
# https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
# Command to encrypt credential to file
# $Key = New-Object Byte[] 32 -> [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key) -> $Key | out-file .\example\config\aes.key
# (get-credential).Password | ConvertFrom-SecureString -key (get-content .\example\config\aes.key) | set-content ".\example\config\password.txt"

$unc= "\\example.com\example" # UNC path for smb share
$decrypt = Get-Content .\example\config\password.txt | ConvertTo-SecureString -Key (Get-Content .\example\config\aes.key) # Decrypts encrypted credential file
$cred = New-Object System.Management.Automation.PsCredential("domain\user",$decrypt) # Imports encrypted credential file
$source= "\\example.com\example\example" # Source of directory
$destination= ".\example\example" # Destination of directory

New-SmbMapping -RemotePath $unc -UserName $cred.UserName -Password $cred.GetNetworkCredential().Password -AsJob
ROBOCOPY $source $destination /z /mov /mon:1 /v