#!/bin/bash
#
# display iptables chains in order of packet traversal
# see https://stuffphilwrites.com/2014/09/iptables-processing-flowchart/

CHAINS=(
"raw PREROUTING"
"mangle PREROUTING"
"nat PREROUTING"
"mangle INPUT"
"filter INPUT"
"nat INPUT"
)

show_iptables() {
  local table=$1
  local chain=$2
  echo -e "${table}\n"
  iptables -t ${table} -L ${chain} -vn;
  echo
}

for chain in "${CHAINS[@]}"; do
  show_iptables ${chain}
done
