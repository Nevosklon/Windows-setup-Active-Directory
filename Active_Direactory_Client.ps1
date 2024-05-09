function main {
	$IPAddress = Read-Host "Enter Server IPv4 address"
 	$USER = Read-Host "Enter User Name"

	$DOMAIN="Barportestates.com"
 	$LOCALDOMAIN = "Barpo"

	# Clear Dns and register dns before setting new domain
 	Clear-DnsClientCache -Verbose
	Get-NetAdapter | Set-DnsClientServerAddress -Addresses "$IPAddress" -Verbose
 	Register-DnsClient -Verbose

	Add-Computer -Domain "$DOMAIN" -DomainCredential "$USER@$DOMAIN" -LocalCredential "$LOCALDOMAIN\$USER" -Force
 	Read-Host "Press enter To restart pc"
	Restart-Computer
}
main
