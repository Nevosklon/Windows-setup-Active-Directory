function main {
	$IPAddress = Read-Host "Enter Server IPv4 address"
	$DOMAIN="Barportestates.com"
	$USERS=@("Dennis","Anthony")

	Get-NetAdapter | Set-DnsClientServerAddress -Addresses $IPAddress -Validate -Verbose
	foreach( $user in $USERS ) {
		Add-Computer -Domain $DOMAIN -$user -Force
	}
	Restart-Computer
}
main