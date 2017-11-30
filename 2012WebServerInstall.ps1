<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.93
	 Created on:   	9/4/2015 2:37 PM
	 Created by:   	 
	 Organization: 	 
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
param
(
	[parameter(Mandatory = $true)]
	[String]
	$Source
)
Write-Host "Installing AmTote 2012 Web Server"
Import-Module ServerManager
add-WindowsFeature -Name Web-Server -Source $Source
add-WindowsFeature -Name Web-WebServer -Source $Source
add-WindowsFeature -Name Web-Common-Http -Source $Source
add-WindowsFeature -Name Web-Default-Doc -Source $Source
add-WindowsFeature -Name Web-Dir-Browsing -Source $Source
add-WindowsFeature -Name Web-Http-Errors -Source $Source
add-WindowsFeature -Name Web-Static-Content -Source $Source
add-WindowsFeature -Name Web-Health -Source $Source
add-WindowsFeature -Name Web-Http-Logging -Source $Source
add-WindowsFeature -Name Web-Performance -Source $Source
add-WindowsFeature -Name Web-Stat-Compression -Source $Source
add-WindowsFeature -Name Web-Security -Source $Source
add-WindowsFeature -Name Web-Filtering -Source $Source
add-WindowsFeature -Name Web-App-Dev -Source $Source
add-WindowsFeature -Name Web-Net-Ext -Source $Source
add-WindowsFeature -Name Web-Net-Ext45 -Source $Source
add-WindowsFeature -Name Web-ASP -Source $Source
add-WindowsFeature -Name Web-Asp-Net -Source $Source
add-WindowsFeature -Name Web-Asp-Net45 -Source $Source
add-WindowsFeature -Name Web-ISAPI-Ext -Source $Source
add-WindowsFeature -Name Web-ISAPI-Filter -Source $Source
add-WindowsFeature -Name Web-Mgmt-Tools -Source $Source
add-WindowsFeature -Name Web-Mgmt-Console -Source $Source
add-WindowsFeature -Name NET-Framework-Features -Source $Source
add-WindowsFeature -Name NET-Framework-Core -Source $Source
add-WindowsFeature -Name NET-Framework-45-Features -Source $Source
add-WindowsFeature -Name NET-Framework-45-Core -Source $Source
add-WindowsFeature -Name NET-Framework-45-ASPNET -Source $Source


mkdir c:\GwsFolders
mkdir c:\GwsFolders\Itpdata
New-SmbShare -Name "Itpdata" -Path "c:\GwsFolders\Itpdata" -FullAccess everyone
Copy-Item -Path C:\ServerInstall\AmTote\GatewayAPI\bin c:\"Program Files (x86)"\AmTote\GatewayAPI\bin -Recurse -Force
Copy-Item -Path C:\ServerInstall\AmTote\AmtLogManager c:\"Program Files (x86)"\AmTote\AmtLogManager -Recurse -Force

$acl = get-acl -path "C:\Program Files (x86)\AmTote\GatewayAPI\Bin"
$new = "IIS_IUSRS", ”Read, ExecuteFile”, ”ContainerInherit, ObjectInherit”, ”None”, ”Allow”
$accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $new
$acl.SetAccessRule($accessRule)
$acl | Set-Acl "C:\Program Files (x86)\AmTote\GatewayAPI\Bin"



$acl = get-acl -path c:\gwsfolders
$new = "IIS_IUSRS", ”FullControl”, ”ContainerInherit, ObjectInherit”, ”None”, ”Allow”
$accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $new
$acl.SetAccessRule($accessRule)
$acl | Set-Acl c:\gwsfolders

Copy-Item -Path C:\ServerInstall\Hi-Perf\Aspnet.config -Destination C:\Windows\Microsoft.NET\Framework\v2.0.50727\Aspnet.config -Force
Copy-Item -Path C:\ServerInstall\Hi-Perf\machine.config -Destination C:\Windows\Microsoft.NET\Framework\v2.0.50727\CONFIG\machine.config -Force

Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value "0"

Invoke-Item -Path C:\ServerInstall\2012.bat

$timeBeforeStart = 3
$waitSeconds = 120

Start-Sleep -Seconds $timeBeforeStart

$waitSeconds..0 | Foreach-Object {
	Write-Host "Time Remaining: $_"
	Start-Sleep -Seconds 1
}

Write-Host "Restart-Computer"
