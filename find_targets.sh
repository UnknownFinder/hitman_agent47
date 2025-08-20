#!/bin/bash
for PORT in ${PORTS[*]}; do
	grep "New connections from" $watching_from | grep "$PORT" | awk '{print $NF}' | sort -u >> $target_list
done
while IFS =read -r ip; do
	echo "Scanning target $ip" >> $information
	nmap -A -sV >> $information
	if [[ $ip =~ .*\.local|.*\.lan ]]; then
		echo "Getting more information about target $ip" >> $information
		enum4linux -A $ip >> $information
	fi
done < "$target_list

