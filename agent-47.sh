#!/bin/bash
clear
DIR=$(pwd)
export SCRIPT_DIRECTORY=$DIR 
sleep 1
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
echo "To stop this script enter 99"	
read choice
if [ $choice -eq 1 ]; then 
	bash $SCRIPT_DIRECTORY/system_monitor.sh
fi
if [ $choice -eq 2 ]; then 
    echo "Please read this instruction to avoid problems in future:"
    echo "If you want to block one port enter 2, then follow the instructions"
    echo "If you want to block more than one port enter 3, then follow the instruction"
	echo "If you want to create white list of IP-addresses and block all orher connections enter 4, then follow the instruction"
	echo "If you want to create blacklist of IP-addresses and accept all other connections entire 5 then follow the instruction"
	echo "If you want to delete all chains, enter 6."
 	echo "If you want to exit enter 99"
   	read firewall_choice
    if [ $firewall_choice -eq 2 ]; then
    	echo "You have chosen to close one port. Please, enter a port number:"
    	read port
        sudo iptables -A INPUT -p tcp --dport $port -j DROP
        sudo iptables -A INPUT -p UDP -s 0/0 --dport $port -j DROP
	fi
    if [ $firewall_choice -eq 3 ]; then
        echo "You have chosen to close some ports. Please, enter amount of ports, which must be closed, then enter their numbers. Press 0 to stop."
		declare -a closed_ports
        read -a closed_ports
        for port in "${closed_ports}"; do
            sudo iptables -A INPUT -p tcp --dport $port -j DROP
            sudo iptables -A OUTPUT -p tcp --dport $port -j DROP
            sudo iptables -A INPUT -p UDP -s 0/0 --dport $port -j DROP
        done
	fi
        if [ $firewall_choice -eq 4 ]; then
            echo "Enter ip-addresses that must be added to whitelist:"
            declare -a whitelist
            read -a whitelist
            for ip_address in "${whitelist}"; do
                sudo iptables -A INPUT -s $ip_address -j ACCEPT
                sudo iptables -A OUTPUT -s $ip_address -j ACCEPT
            done
		fi
        if [ $firewall_choice -eq 5 ]; then 
			echo "Enter ip-addresses which must be added at blacklist:"
            declare -a blacklist
            read -a blacklist
            for ip_address in "${blacklist}"; do
                sudo iptables -A INPUT -s $ip_address -j DROP
                sudo iptables -A OUTPUT -s $ip_address -j DROP
            done
		fi
  		if [ $firewall_choice -eq 6 ]; then
            sudo iptables -F
			sudo iptables -X
   		fi
fi
echo "O'kay, you've create some firewall settings."
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
	exit 0
fi
