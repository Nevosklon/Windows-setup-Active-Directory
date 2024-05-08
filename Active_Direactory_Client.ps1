function main {
	$IPAddress = Read-Host "Enter Server IPv4 address"
    $USER = Read-Host "Enter User"
	$DOMAIN="Barportestates.com"

	Get-NetAdapter | Set-DnsClientServerAddress -Addresses $IPAddress -Validate -Verbose
    Rename-Computer $USER
	Add-Computer -Domain $DOMAIN -Credential "Barpo\$USER" -Force
	Read-Host "Press any Key to Exit"
	Restart-Computer
}
main
