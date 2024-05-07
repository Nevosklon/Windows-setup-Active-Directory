$IPAddress = Read-Host "Enter Server IPv4 address"


Set-DnsClientServerAddress -ServerAddress $IPAddress -Validate
if ( $? ) {
	Write-Host "Failed to set and connect to dns server"
}
