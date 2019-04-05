#!/bin/bash

#ping sweep:

for ip in $(seq 1 254); do (ping -c 1 10.11.1.$ip &); done | grep 'bytes from' | cut -d " " -f 4 | cut -d ":" -f 1 | sort > /root/Desktop/pings2.txt

#-- alternative to create separate files: 
for ip in $(seq 1 2); do (echo -e for 10.11.1.$ip\\n; ping -c 1 10.11.1.$ip &) >> ./test/10.11.1.${ip}_blah.txt ; done

#nmap sweep for specific port:

for ip in $(seq 1 254); do (nmap -Pn -p T:25 10.11.1.$ip &);done | grep -B 4 open | grep "Nmap scan" | cut -d " " -f 5 > /root/Desktop/machines_open_tcp_25.txt


#bash/python machine sweep (for SMTP commands):

for ip in $(cat /root/Desktop/smtp_open.txt);do (./vrfy.py administrator $ip &); done


#additional nmap investigation of target list (respond to pings):

for ip in $(cat /root/Desktop/pings.txt);do (nmap -Pn -O $ip &); done > /root/Desktop/systems.txt


#snmp progression: 

#---find SNMP agents:

for ip in $(cat ./snmp/snmp_open.txt); do echo Checking $ip; (onesixtyone -c ./snmp/strings.txt $ip &) > ./snmp/${ip}_onesixtyone.txt; done

#---walk for specific OID and community string:

for ip in $(cat ./snmp/*onesix* | grep -Eo 10.11.1.[[:digit:]]+); do echo Checking $ip; (echo For ${ip} using SNMP v1; snmpwalk -c public -v 1 $ip 1.3.6.1.2.1.6.13.1.3 &) >> ./snmp/${ip}.txt ; done

#---walk multiple OIDs (DOES NOT WORK YET: bash syntax error)

for ip in $(cat ./snmp/*onesix* | grep -Eo 10.11.1.[[:digit:]]+); do echo Checking $ip; (echo For ${ip} using SNMP v1; for oid in $(cat ./snmp/OIDs.txt); do snmpwalk -c public -v 1 ${ip} ${oid} &) >> ./snmp/${ip}.txt ; done ; done

#---in-depth check

for ip in $(cat ./snmp/*onesix* | grep -Eo 10.11.1.[[:digit:]]+); do echo Checking $ip; (snmp-check -c public -v 2c $ip &) > ./snmp/${ip}_snmp-check_v2c.txt ; done
