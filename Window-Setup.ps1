# The Hive rooot path range
$global:I_HIVEROOT = 6

# Regestry key to be modified and added
$global:H_HIVE=[ordered]@{
	"HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"=@(
		@{name="NoLockScreen"; type="DWord"; value=1}
	);
	"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"=@(
		@{name="DisallowShaking"; type="DWord"; value=1}
	);
	"HKCU:\SOFTWARE\Policies\Microsoft\Windows\Personalization"=@(
		@{name="AppsUseLightTheme"; type="DWord"; value=0},
		@{name="SystemUseLightTheme"; type="DWord"; value=0}
	);
	"HKCU:\Control Panel\Desktop\WindowMetrics" =@(
		@{name="MinAnimate"; type="DWord"; value=0}	
	);
	"HKCU:\Control Panel\Desktop"=@(
		@{name="MenuShowDelay"; type="String"; value=0},
		@{name="WallPaper"; type="String"; value=0},
		@{name="CursorBlinkRate"; type="DWord"; value="-1"}
	);
	"HKCU:\Software\Policies\Microsoft\Windows\Explorer"=@(
		@{name="DisableSearchBoxSuggestions"; type="DWord"; value=1}
	);
	"HKCR:\DesktopBackground\Shell\powershell\command"=@(
		@{name="(Default)"; type ="String"; value="C:\Windows\System32\WindowsPowerShell\v1.0"}
	);
	"HKCR:\DesktopBackground\Shell\Display\command"=@(
		@{name="DelegateExecute"; type ="String"; value="{556FF0D6-A1EE-49E5-9FA4-90AE116AD744}"}
	);	
}

# Services to be disable
$A_SERVICES = @("spooler")

function B_HiveRootExist{
	param(
		[Parameter(Mandatory=$true)]
		[String[]]$Path
	)
	return Test-Path $path.Substring(0, $I_HIVEROOT)
}

function Hive_AddKey{
	param(
		[Parameter(Mandatory=$true)]
		[string]$S_Path
	)
	if ( -Not (B_HiveRootExist $S_Path) ) {
		return
	}

	$A_Path = $S_Path.Split("\")
	
	for( $i = 1; $i -lt $A_Path.Length; $i++) {
		
		$S_PathExist = [system.String]::Join("\", $A_Path[0..$i])
		if (Test-Path $S_PathExist){
			continue
		}
		
		$S_CurrentPath = [system.String]::Join("\", $A_Path[0..($i - 1)])
		$S_NewKey = $A_Path[$i]
		New-Item -Path $S_CurrentPath -Name $S_NewKey
	}
	
}

function Hive_AddItem{
	param(
		[Parameter(Mandatory=$true)]
		[Object]$H_Items,
		[String]$S_Path
	)
	
	if ( -Not (B_HiveRootExist $S_Path) ) {
		return
	}
	foreach( $O_Item in $H_Items) {
		$S_Type = $O_Item["type"]
		$S_Name = $O_Item["name"] 
		$O_Value = $O_Item["value"]		
		
		Get-ItemProperty -Path $S_Path -Name $S_Name 2> $null
		if ( $? ) {
		
			Set-ItemProperty -Type $S_Type -Path $S_Path -Name $S_Name -Value $O_Value -Verbose
			continue
		}	
		New-ItemProperty -PropertyType $S_Type -Path $S_Path -Name $S_Name -Value $O_Value -Verbose
	}

}

function EditHive {
	param(
		[parameter(Mandatory=$true)]
		[Object]$H_Hives
	)
	foreach($O_Hive in $H_Hives.getEnumerator()) {
		$A_Keys = $O_Hive.Value
		$S_Path = $O_Hive.Name

		Hive_AddKey $S_Path
		Hive_AddItem $A_Keys $S_Path
	}
}

function DisableService{
	param(
		[parameter(Mandatory=$true)]
		[String[]]$S_Services
	)
	foreach( $S_Service in $S_Services) {
		Suspend-Service -Name $S_Service -Verbose 2> $null
		Stop-Service -Name $S_Service -Force -Verbose
		Set-Service -Name $S_Service -Startup Disabled -Status Stopped -Verbose
	}
}

function main {
	DisableService $global:A_SERVICES
	EditHive $global:H_HIVE
}

main
