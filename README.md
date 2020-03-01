# useful_scripts
A variety of useful scripts in several languages

DNS_scan.ps1: get DNS A records for specified FQDNs from specified DNS server
file_dedupe.ps1: de-duplicate two folders based on similar size and file hash
find_firewall_rule.ps1: find firewall rules containing a specified remote IP address
hashcrack.py: crack a hash using a wordlist
http_retrieval.ps1: single page TLS 1.2 web request with minimal noise
iptables_packet_trace.sh: follow the flow
one_liners.sh: some handy one-liner Bash and Bash + Python scripts
- ping sweep
- nmap sweep on specified TCP port
- SMTP sweep
-- uses vrfy.py
- in-depth scan of results of ping sweep (above)
- progressive series of SNMP scans
page_scraper.ps1: scrape site for sequentially named files (like log files)
page_scraper_alt_1.ps1: modularized page scraper
- uses page_scraper_functions.psm1
ping_scan_parallel.bat: parallelized Windows ping scan
switch_DNS.ps1: switch DNS servers in network adaptor and Windows Firewall DNS rule
- uses lib_switch_DNS.psm1
