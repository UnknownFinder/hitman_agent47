#!/bin/bash
for PORT in ${PORTS[*]}; do
	grep "New connections from" $LOG_FILE | grep "$PORT" | awk '{print $NF}' | sort -u >> $IP_LIST
done
while IFS =read -r ip; do
	echo "Scanning target $ip" >> $RESULTS
	nmap -A -sV >> $RESULTS
	if [[ $ip =~ .*\.local|.*\.lan ]]; then
		echo "Getting more information about target $ip" >> $RESULTS
		enum4linux -A $ip >> $information
	fi
done < "$IP_LIS

