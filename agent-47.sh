#!/bin/bash
clear
DIR=$(pwd)
export SCRIPT_DIRECTORY=$DIR 
sleep 1
while true; do
echo " _    _   ___   _____     _     _           __       _    _ "
echo "| |  | | |_ _| |_   _|   / \   / \         /  \     | |  | |"
echo "| |__| |  | |    | |    /   \_/   \       / /\ \    |  \ | |"
echo "|  __  |  | |    | |   /  _     _  \     / ____ \   |   \| |"
echo "| |  | |  | |    | |  /  / \   / \  \   / /    \ \  |  _   |"
echo "|_|  |_| |___|   |_| /__/   \_/   \__\ /_/      \_\ |_| \__|"
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
	#We will drop all packages with invalid status
    sudo iptables -A INPUT -m state --state INVALID -j DROP
    sudo iptables -A FORWARD -m state --state INVALID -j DROP
    #Protecting from SYN flood
    sudo iptables -A INPUT  -p tcp ! --syn -m state --state NEW -j DROP
    sudo iptables -A OUTPUT -p tcp ! --syn -m state --state NEW -j DROP
    #Protecting from ICMP redirectioin
    sudo iptables -A INPUT --fragment -p ICMP -j DROP
    sudo iptables -A OUTPUT --fragment -p ICMP -j DROP
fi
if [ $choice -eq 3 ]; then
	echo "O'kay, my friend. Now enter:"
	echo "1 to create service which will controll thresholds"
	echo "2 to delete this service"
	read hardware_choice
	if [ $hardware_choice -eq 1 ]; then
		echo "Enter % of CPU usage"
		read cpu_treshold
		echo "Enter % of RAM usage"
		read ram_treshold
		echo "You have entered parameters. Please, wait... "
		bash $SCRIPT_DIRECTORY/call_daemon.sh
		echo "Well, you have entered parameters, so I will work for you to protect your device from crushs."
	elif [ $hardware_choice -eq 2 ]; then
		cd /etc/systemd/system
		rm hitman.service
		echo "Well, now you can run this script again to rewrite the parameters."
		cd
	fi
fi	
if [ $choice -eq 99 ]; then
	echo "Goodbuy, have a nice day!"
	break
fi
done
