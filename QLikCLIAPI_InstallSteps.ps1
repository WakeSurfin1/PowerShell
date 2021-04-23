Subject: How to install Qlik CLI and API modules on your laptop

## Step 1:  Submit Help desk ticket for admin access
## Step 2:  Help desk admin uses their admin user to open a Powershell ISE window on your local laptop
## Step 3:  Run the below commands as the admin user

## Set up powershell install local environment
PS C:\windows\system32>Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
PS C:\windows\system32>Get-PackageProvider -Name NuGet -ForceBootstrap

## Install and assert Qlik CLI env on your local laptop
## https://developer.qlik.com/garden/58b83eb68bc22ec70e8788f3

PS C:\windows\system32>Install-Module Qlik-Cli
PS C:\windows\system32>Import-Module Qlik-Cli
PS C:\windows\system32>Get-Help Qlik

## Install and assert Qlik API interface module on your local laptop
## https://github.com/ahaydon/Qlik-DSC/blob/master/README.md

PS C:\windows\system32>Install-Module QlikResources
PS C:\windows\system32>Get-DscResource -Module QlikResources

## Step 4: Open another Powershell ISE window as your user and run the below commands

PS C:\windows\system32>Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
PS C:\windows\system32>Get-Help Qlik
PS C:\windows\system32>Get-DscResource -Module QlikResources

## if the above list all resources without errors, you are done
