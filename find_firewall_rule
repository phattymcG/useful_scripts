# outputs firewall rules containing a specified remote IP address

$ip = "[ip address]"

$rules = Get-NetFirewallRule

Write-Output("These rules contain " + $ip + " as a remote address:`n")

foreach ($rule in $rules){
$contains = $rule | Get-NetFirewallAddressFilter | Where-Object {$_.RemoteAddress -contains $ip}
if ($contains){
Write-Output $rule.DisplayName
}
}
