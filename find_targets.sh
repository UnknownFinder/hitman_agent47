#!/bin/bash
LOG_FILE="/var/log/syslog"
IP_LIST="ips.txt"
RESULTS="results.txt"
PORTS=(22 80 139 443)
for PORT in ${PORTS[*]}; do
	grep "New connections from" $LOG_FILE | grep "$PORT" | awk '{print $NF}' | sort -u >> $IP_LIST
done
echo "Now I need install some instruments to work with my targets."
sudo snap install enum4linux
while IFS =read -r ip; do
	echo "Scanning target $ip" >> $RESULTS
	nmap -A -sV >> $RESULTS
	if [[ $ip =~ .*\.local|.*\.lan ]]; then
		echo "Getting more information about target $ip" >> $RESULTS
		enum4linux $ip >> $RESULTS
	fi
done < "$IP_LIST"

