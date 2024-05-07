Import-Module ActiveDirectory

$global:DOMAIN = Barportestates.com
$global:USERS = @(
	@{user="Dennis"; Surname="Surname";, Password="P@ssw0ds"; Groups=@("Administrator"); OrganisationUnit=@("")},
	@{user="Anthony"; Surname="Hoang"; Password="P@ssw0ds"; Groups=@("Administrator")}
)

function DontRunMeAgain{
	# Unregster job dont want to contously run the script\tUnregister-ScheduleJob -Name "Stage_2_Active_Directory_Users" -Force
}
function CreateGroups{
	param(
		Parameter([Mandatory=$true])
		[String]$UserName
		[String[]]$Groups
	)
	foreach( $Group in $Group){ 
		try { Get-ADGroup -Identity "$group"
			Add-ADGroup -Identity $Group
			Add-ADGroupMember -Identity $Group -Members $UserName
		} catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            Write-Warning "User $UserName NOT added to group $Group because it does not exist"
		}
	}
}
function CreateUser() {
	param(
		paramter([Mandatory=$true])
		[Object[]]$Users,
	)
	foreach( $User in $Users ) {
		
	}
}
# Create User 
New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount

 
