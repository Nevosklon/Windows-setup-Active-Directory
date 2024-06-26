﻿# Domains
$global:COMPUTERNAME = "ADS-01"
$global:DOMAIN = "Barportestates.com"
$global:PASSWORD = "Password1!"

function NetBios{
	param(
		[Parameter(Mandatory=$true)]
		[String]$Domain
	)
	$index = $Domain.IndexOf(".")
	return $Domain.Substring(0, 5)
}

function RenameComputer{
	param(
		[Parameter(Mandatory=$true)]
		[String]$Name
	)
	Rename-Computer $Name -Verbose 2> $null
}

function StaticIP{
	# Setting the current ip address into static 
	$INT_IP = Get-NetAdapter | Get-NetIPAddress -AddressFamily Ipv4
	Set-NetIPAddress -InterfaceIndex $INT_IP.InterfaceIndex -IPAddress $INT_IP.IPAddress -AddressFamily Ipv4 -Verbose
}


# install acitve Directory and domain utils for powershell
function InstallUtils {
	param(
		[Parameter(Mandatory=$true)]
		[String]$Domain,
		[String]$Password
	)
	
	# install and add windows for active directory util tools
	Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 -Verbose

	Install-WindowsFeature -Name "RSAT-AD-PowerShell" -IncludeAllSubFeature -Verbose
	Import-Module -Name ActiveDirectory

	# install active domain utils
	Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -Verbose
	Import-Module -Name ADDSDeployment
	

	$netbios = NetBios $Domain
	# configure the domain
	Install-ADDSForest -DomainName $Domain -DomainNetbiosName $netbios -InstallDNS -SafeModeAdministratorPassword (ConvertTo-SecureString -String $Password -AsPlainText -Force) -NoRebootOnCompletion -Force -Verbose
}

# Completed install Restart and scheduling stage 2 users
function CreatingUsersStage2 {
	$RunScript=Get-Item .\Active_Direactory_Server_2.ps1
	if ( -Not $? ) {
		Write-Warning "Failed to find .\Active_Direactory_Server_2.ps1"
		Read-Host "Press any Key to Exit"
		Exit
	}
	$RunScriptPath=$RunScript.FullName
	$PRIVLIGAES=New-ScheduledJobOption -RunElevated
	Register-ScheduledJob -Name "Stage_2_Active_Directory_Users" -Trigger @{Frequency="AtStartup"} -ScheduledJobOption $PRIVLIGAES -FilePath $RunScriptPath -Verbose
}

function main {
	RenameComputer $global:COMPUTERNAME
	StaticIP
	InstallUtils $global:DOMAIN $global:PASSWORD
	CreatingUsersStage2	
	
	Read-Host "Press Enter to Restart Computer"
	Restart-Computer 
}

main
