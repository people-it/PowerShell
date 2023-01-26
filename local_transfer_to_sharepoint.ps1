#powershell script to access sftp server / share and upload files to sharepoint library
#
#
#start a transcript so we can see what happens when this tries to run
Start-Transcript C:\utils\sharepointtransferlog.txt -Append
#
#steps needed for PSVersion 5.1, fyi - these must be run as Administrator to work correctly
#
#change TLS Settings:
#[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
#
#Install NuGet
#Install-PackageProvider -Name NuGet -Force
#
#Install PowerShell-Get
#Install-Module PowerShellGet -AllowClobber -Force
#
#set PowerShell Gallery as trusted repo for packages:
#Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
#
#Install PowerShell SSH Module from PSGallery:
#Install-Module -Name Posh-SSH
#
#Install Sharepoint online module
#Install-Module Microsoft.Online.SharePoint.PowerShell
#Install-Module -Name "PnP.PowerShell"

#import modules for things we will need
Import-Module Posh-SSH
Import-Module -Name "PnP.PowerShell"

##update 365 credentials in encrypted file (uncomment or run selection to update)
#Read-Host -Prompt "Enter your password" -AsSecureString | ConvertFrom-SecureString | Out-File "c:\utils\365encryptedpw.txt"

#retrieve encrypted credentials so we can do stuff with 365 / sharepoint
$SharepointAdminName = "user@domain.com"
$SharepointPass = Get-Content "c:\utils\365encryptedpw.txt" | ConvertTo-SecureString 
$365cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $sharepointAdminName, $sharepointPass

#connect to sharepoint libary and upload the file  
Connect-PnPOnline -Url https://url.sharepoint.com/sites/libraryname -Credential $365cred  
$localpath = "C:\somefolder\subfolder"  
$splib = "Shared Documents/Subfolder/Subfolder2/Subfolder3"  
Add-PnPFile -Path $localPath -Folder $splib  
  
write-host "File has been uploaded!"

#stop transcript
Stop-Transcript
