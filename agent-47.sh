#!/bin/bash
DIR=$(pwd)
export SCRIPT_DIRECTORY=$DIR 
clear
sleep 1
while true; do
	echo " _    _   ___   _____     _     _           __       _    _ "
	echo "| |  | | [_ _] [_   _]   / \   / \         /  \     | |  | |"
	echo "| |__| |  | |    | |    /   \_/   \       / /\ \    |  \ | |"
	echo "|  __  |  | |    | |   /  _     _  \     / ____ \   |   \| |"
	echo "| |  | |  | |    | |  /  / \   / \  \   / /    \ \  |  _   |"
	echo "|_|  |_| [___]   |_| /__/   \_/   \__\ /_/      \_\ |_| \__|"
	echo "Hello, User! I was created to help you set some settings on  your machine. Please read this short manual before using:"
	echo "To know information about your system enter 1"
	echo "To create a simple firewall rool enter 2"
	echo "To protect your system from hardware crushs enter 3"
	echo "To exit enter 99"	
	read choice
	if [ $choice -eq 1 ]; then 
		bash $SCRIPT_DIRECTORY/system_monitor.sh
	fi
	if [ $choice -eq 2 ]; then
 		sudo bash $SCRIPT_DIRECTORY/find_targets.sh
   		LOG_FILE="/var/log/syslog"
	 	export watching_from=$LOG_FILE
		IP_LIST="ips.txt"
  		export target_list=$IP_LIST
		RESULTS="results.txt"
  		export information=$RESULTS
		PORTS=(22 80 139 443)
		if command -v enum4linux &> /dev/null; then
			sleep 1
		else
			echo "Now I need install some instruments to work with my targets."
			sudo snap install enum4linux
		fi
		#We will drop all packages with invalid status
    	sudo iptables -A INPUT -m state --state INVALID -j DROP
    	sudo iptables -A FORWARD -m state --state INVALID -j DROP
    	#Protecting from SYN flood
    	sudo iptables -A INPUT  -p tcp ! --syn -m state --state NEW -j DROP
    	sudo iptables -A OUTPUT -p tcp ! --syn -m state --state NEW -j DROP
    	#Protecting from ICMP redirectioin
    	sudo iptables -A INPUT --fragment -p ICMP -j DROP
    	sudo iptables -A OUTPUT --fragment -p ICMP -j DROP
	 	echo "Creating firewall"
	 	for i in {1..10}; do
   			echo  -n "*"
	  		sleep 0.5
	  	done
		echo "Now your system protected from SYN flood, ICMP redirection and packages with <INVALID> status."
    	bash $SCRIPT_DIRECTORY/create_firewall.sh
fi
if [ $choice -eq 3 ]; then
	while true; do
		echo "O'kay, my friend. Now enter:"
		echo "1 to create service which will controll thresholds"
		echo "2 to delete this service"
  		echo "99 to exit"
		read hardware_choice
  		if [ $hardware_choice -eq 99 ]; then
			break
   		fi
		if [ $hardware_choice -eq 1 ]; then
			echo "Enter % of CPU usage"
			read cpu_threshold
			echo "Enter % of RAM usage"
			read ram_threshold
   			export max_cpu=$cpu_threshold
	  		export max_ram=$ram_threshold
			echo "You have entered parameters. Please, wait... "
			bash $SCRIPT_DIRECTORY/call_daemon.sh
			echo "Well, you have entered parameters, so I will work for you to protect your device from crushs."
		elif [ $hardware_choice -eq 2 ]; then
			cd /etc/systemd/system
			rm hitman.service -y
			echo "Well, now you can run this script again to rewrite the parameters."
			cd
		fi
	done
fi	
if [ $choice -eq 99 ]; then
	echo "Goodbuy, have a nice day!"
	break
fi
done
