#!/usr/bin/env bash
# Custom Nagios plugin: free memory in percent.
# Usage: check_mem.sh -w <warn%> -c <crit%>   (thresholds on FREE memory)
# Output: "STATUS - message | perfdata"   Exit: 0 OK, 1 WARNING, 2 CRITICAL, 3 UNKNOWN
WARN=20; CRIT=10
while getopts "w:c:" opt; do
  case $opt in
    w) WARN=$OPTARG ;;
    c) CRIT=$OPTARG ;;
    *) echo "UNKNOWN - usage: $0 -w <warn%> -c <crit%>"; exit 3 ;;
  esac
done

TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
AVAIL=$(free -m | awk '/^Mem:/ {print $7}')
[[ -n "$TOTAL" && "$TOTAL" -gt 0 ]] || { echo "UNKNOWN - cannot read memory"; exit 3; }
PCT=$(( AVAIL * 100 / TOTAL ))

MSG="${PCT}% memory available (${AVAIL}MB of ${TOTAL}MB) | avail_pct=${PCT}%;${WARN};${CRIT};0;100"
if   (( PCT <= CRIT )); then echo "CRITICAL - $MSG"; exit 2
elif (( PCT <= WARN )); then echo "WARNING - $MSG";  exit 1
else                         echo "OK - $MSG";       exit 0
fi
