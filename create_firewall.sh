#!/bin/bash
function validate_ip() {
    local ip=$1
    if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        return 0
    else
        return 1
    fi
}
function validate_port() {
    local port=$1
    if [[ $port =~ ^[0-9]+$ && $port -ge 1 && $port -le 65535 ]]; then
        return 0
    else
        return 1
    fi
}
while true; do
    		echo "Enter 1 to close some ports, then follow instructions"
    		echo "Enter 2 to open some ports, then follow instructions"
    		echo "Enter 3 to create blacklist of ip-addresses, then follow instructions"
    		echo "Enter 4 to create whitelist of ip-addresses, then follow instructions"
    		echo "Enter 5 to delete your settings"
    		echo "Enter 99 to exit"
    		read firewall_choice
    		case $firewall_choice in
        	1)
            	while true; do
                	read -p "Enter port number to close (enter 0 to finish): " port
                	if [[ $port == 0 ]]; then break; fi
                	if validate_port "$port"; then
                    	sudo iptables -A INPUT -p tcp --dport $port -j DROP
                    	sudo iptables -A OUTPUT -p tcp --dport $port -j DROP
                	else
                    	echo "Invalid port number. Please enter a valid port between 1 and 65535."
                	fi
            	done
            	;;
        	2)
            	while true; do
                	read -p "Enter port number to open (enter 0 to finish): " port
                	if [[ $port == 0 ]]; then break; fi
                	if validate_port "$port"; then
                    	sudo iptables -A INPUT -p tcp --dport $port -j ACCEPT
                    	sudo iptables -A OUTPUT -p tcp --dport $port -j ACCEPT
                	else
                    	echo "Invalid port number. Please enter a valid port between 1 and 65535."
                	fi
            	done
            	;;
        	3)
            	ip_array=()
            	while true; do
                	read -rp "Enter IP-address to block (enter 0 to finish): " ipaddr
                	if [[ $ipaddr == 0 ]]; then break; fi
                	if validate_ip "$ipaddr"; then
                    	ip_array+=("$ipaddr")
                	else
                    	echo "Invalid IP address. Please enter a valid IPv4 address."
                	fi
            	done
            	for IP in "${ip_array[@]}"; do
                	sudo iptables -A INPUT -s "$IP" -j DROP
            	done
            	;;
        	4)
            	ip_array=()
            	while true; do
                	read -rp "Enter IP-address to accept (enter 0 to finish): " ipaddr
                	if [[ $ipaddr == 0 ]]; then break; fi
                	if validate_ip "$ipaddr"; then
                    	ip_array+=("$ipaddr")
                	else
                    	echo "Invalid IP address. Please enter a valid IPv4 address."
                fi
            	done
            	for IP in "${ip_array[@]}"; do
                	sudo iptables -A INPUT -s "$IP" -j ACCEPT
            	done
            	;;
        	5)
            	sudo iptables -F
			 	sudo iptables -X
           	echo "All rules cleared."
            	;;
        	99)
            	echo "Exiting..."
            	break
            	;;
        	*)
            	echo "Invalid choice. Please try again."
            	;;
    	esac
done
