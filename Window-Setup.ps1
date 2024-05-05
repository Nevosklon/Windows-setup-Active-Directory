
$RegAdd=[ordered]@{
	"HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"=@(@{key="NoLockScreen"; type="DWORD"; value=1});
	"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"=@(
		@{key="DisallowShaking"; type="DWORD"; value=1}
	);
	"HKCU:\SOFTWARE\Policies\Microsoft\Windows\Personalization"=@(
		@{key="AppsUseLightTheme"; type="DWORD"; value=0},
		@{key="SystemUseLightTheme"; type="DWORD"; value=0}
	);
	"HKCU:\Control Panel\Desktop"=@(
		@{key="MenuShowDelay"; type="String"; value=0}
	);
	"HKCU:\Software\Policies\Microsoft\Windows\Explorer"=@(
		@{key="DisableSearchBoxSuggestions"; type="DWORD"; value=1}
	);
	"HKCR:\DesktopBackground\Shell\powershell\command"=@(
		@{key="(Default)"; type ="String"; value="C:\Windows\System32\WindowsPowerShell\v1.0"}
	);
	"HKCR:\DesktopBackground\Shell\Display\command"=@(
		@{key="DelegateExecute"; type ="String"; value="{556FF0D6-A1EE-49E5-9FA4-90AE116AD744}"}
	);	
}

function Reg_AddKey{
	param(
		[Parameter(Mandatory=$true)]
		[string]$Path
	)
	$PathArray = $Path.Split("\")
	Write-Host  $PathArray
	$Path.GetType()
	for( $i = 0; $i -lt $PathArray.Length; $i++) {
		$tmp = [system.String]::Join("\", $Path[0..$i])
		#$tmp.GetType()
		Write-Host "$tmp"
	}
	
}
Reg_AddKey "HKCR:\DesktopBackground\Shell\powershell\command"
foreach($k in $RegAdd.getEnumerator()) {
	# $v = $RegAdd[$k][0]["key"]
	$v = ($k.Value)[0]["key"]
	$k = $k.Name
	#echo $k
	#Reg_AddKey $k
}