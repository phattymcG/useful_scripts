function switch-dns {
param([string]$dns_1
    ,[string]$dns_2
    ,[string]$firewallrule)

$adaptor = Get-WmiObject Win32_NetworkAdapterConfiguration | where {$_.Dnsserversearchorder -eq $dns_1}
if ($adaptor) {($adaptor.SetDNSServerSearchOrder($dns_2))} else {"No adaptors set to specified 'from' address (" + $dns_1 + ")"}

try
{$firewall = Get-NetFirewallRule -displayname $firewallrule -ErrorAction Stop}
catch {"'" + $firewallrule + "'" + " does not exist."}
 
if ($firewall) {
$firewall = $firewall | Get-NetFirewallAddressFilter | where {$_.RemoteAddress -eq $dns_1}
if ($firewall) { $firewall | Set-NetFirewallAddressFilter -RemoteAddress $dns_2} 
else {"'" + $firewallrule + "'" + " not set to specified 'from' address (" + $dns_1 + ")"}
}
}
