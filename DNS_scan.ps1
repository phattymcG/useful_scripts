# returns IPV4 addresses

param(
    [string]$dns_server = "1.1.1.1",
    [string[]]$domains = @("www.google.com" 
                         , "www.microsoft.com"                         
                         )
)

function Get-A-Records {
param([string]$domain,[string]$dns_server)
$a = Resolve-DnsName $domain -DnsOnly -Server $dns_server
foreach ($addr in $a) { if ($addr.IP4Address) {$addr.IP4Address + "`n"}}
}

foreach ($domain in $domains) { $domain + "`n" + (Get-A-Records $domain $dns_server) }
