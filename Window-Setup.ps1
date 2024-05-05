
$RegAdd=[ordered]@{
	"HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"=@(
		@{name="NoLockScreen"; type="DWORD"; value=1}
	);
	"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"=@(
		@{name="DisallowShaking"; type="DWORD"; value=1}
	);
	"HKCU:\SOFTWARE\Policies\Microsoft\Windows\Personalization"=@(
		@{name="AppsUseLightTheme"; type="DWORD"; value=0},
		@{name="SystemUseLightTheme"; type="DWORD"; value=0}
	);
	"HKCU:\Control Panel\Desktop"=@(
		@{name="MenuShowDelay"; type="String"; value=0}
	);
	"HKCU:\Software\Policies\Microsoft\Windows\Explorer"=@(
		@{name="DisableSearchBoxSuggestions"; type="DWORD"; value=1}
	);
	"HKCR:\DesktopBackground\Shell\powershell\command"=@(
		@{name="(Default)"; type ="String"; value="C:\Windows\System32\WindowsPowerShell\v1.0"}
	);
	"HKCR:\DesktopBackground\Shell\Display\command"=@(
		@{name="DelegateExecute"; type ="String"; value="{556FF0D6-A1EE-49E5-9FA4-90AE116AD744}"}
	);	
}

function Reg-AddKey{
	param(
		[Parameter(Mandatory=$true)]
		[string]$Path
	)
	$PathArray = $Path.Split("\")
	Write-Host  $Path
	#Write-Host  $PathArray
	for( $i = 1; $i -lt $PathArray.Length; $i++) {
		$path = [system.String]::Join("\", $PathArray[0..($i - 1)])
		$key = $PathArray[$i]
		Write-Host "$path"
		New-Item -Path $path -Name $key
		
	}
	
}

function Reg-AddItem{
	param(
		[Parameter(Mandatory=$true)]
		[Object]$Items,
		[String]$path
	)
	foreach( $v in $Items) {
		$type = $v["type"]
		$name = $v["name"] 
		$value = ($v["value"])
		New-ItemProperty -PropertyType $type -Path $path -Name $name -Value $value -Verbose
		
		# TODO: check for property exist and modify values
	}

}

# TODO: reduce error outputs
foreach($k in $RegAdd.getEnumerator()) {
	$v = $k.Value
	$k = $k.Name

	Reg-AddKey $k
	Reg-AddItem $v $k

}