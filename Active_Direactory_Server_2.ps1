﻿Import-Module ActiveDirectory

$global:DOMAIN = "Barportestates.com"
$global:USERS = @(
	@{User="Dennis"; Surname="Surname"; Password="P@ssw0ds"; Groups=@("Administrator"); OU="Group_Policy_OU/IT/Users"},
	@{User="Anthony"; Surname="Hoang"; Password="P@ssw0ds"; Groups=@("Administrator"); OU="Group_Policy_OU/IT/Users"}
)

function DontRunMeAgain{
	# Unregster job dont want to contously run the script
	Unregister-ScheduledJob -Name "Stage_2_Active_Directory_Users" -Force -Verbose
}
function CreateGroups{
	param(
		[Parameter(Mandatory=$true)]
		[String]$UserName,
		[String[]]$Groups
	)
	
	foreach( $Group in $Group){ 
		try { 
			Add-ADGroup -Identity $Group
			Add-ADGroupMember -Identity $Group -Members $UserName
		} catch {
			Write-Warning "Failed to create Group Unknown Error"
		}
	}
}
function AddOU {
	param(
		[Parameter(Mandatory=$true)]
		[String]$Name,
		[ref]$Path
	)
	try {
		New-ADOrganizationalUnit -Name $Name -Path $Path.Value -ProtectedFromAccidentalDeletion $false -Verbose
	} catch {
		Write-Warning "Organisation unit already exist"
	}
	$Name = $Name.Insert(0, "OU=")
	$Name = ",".Insert(0, $Name)
	$Path.Value = $Path.Value.Insert(0, $Name)
}
function CreateOU {
	param(
		[Parameter(Mandatory=$true)]
		[String]$OrganisationUnit,
		[String]$Domain,
		[ref]$S_Path
	)

	$A_DC = $Domain.split(".")
	$A_OUS = $OrganisationUnit.split("/")
	# [array]::Reverse($A_OUS)
	
	for ( $i=0; $i -lt $A_DC.Length; $i++) {
		$A_DC[$i] = $A_DC[$i].Insert(0, "DC=")
	}
	
	$S_Path.Value = [system.String]::Join(",", $A_DC)

	foreach ( $OU in $A_OUS) {
		AddOU $OU $S_Path
	}
}

function CreateUser {
	param(
		[Parameter(Mandatory=$true)]
		[String]$User,
		[String]$Surname,
		[String]$Password,
		[String]$Path
	)
		$name = $user
		$surname = $user
		$samaccountname = $user
		$principalname = $user
		try {
			New-ADUser `
	 			-Name $name `
	 			-GivenName $firstname `
	 			-Surname $lastname `
	 			-SamAccountName $samaccountname `
	 			-UserPrincipalName $principalname@$Global:Domain `
	 			-Path $Path `
	 			-AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
	 			-ChangePasswordAtLogon $false `
	 			-Enabled $true -Verbose
		} catch {
			Write-Warning "User Already Exist $User"
		}
}

function main {
	DontRunMeAgain
	foreach($user in $global:USERS){
		$name = $user["User"]
		$surname = $user["Surname"]
		$password = $user["Password"]
		$ou = $user["OU"]
		$S_PATH = ""
		$ref_Path = [ref]$S_PATH
		CreateOU $OU $global:DOMAIN $ref_Path
		CreateUser $name $surname $password $S_PATH
		CreateGroups $name $password 
	}
}

main
