[string]$dns_1
[string]$dns_2
[string]$firewallrule

Import-Module ".\lib_switch_DNS.psm1"

switch-dns $dns_1 $dns_2 $firewallrule

Remove-Module "lib_switch_DNS"
