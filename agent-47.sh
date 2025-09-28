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
	echo "To check information about your system enter 1"
	echo "To create a simple firewall rool enter 2"
	echo "To protect your system from hardware crushs enter 3"
	echo "To exit enter 99"	
	read choice
	if [ $choice -eq 1 ]; then 
		bash $SCRIPT_DIRECTORY/system_monitor.sh
	fi
	if [ $choice -eq 2 ]; then
		# Запускаем от рута или используем sudo перед каждым вызовом iptables
		if [ "$(id -u)" != "0" ]; then
   			echo "Нужно запустить от root!" >&2
   		exit 1
	fi
	# Сбросим все существующие правила
	iptables -F
	# Устанавливаем политику по умолчанию - блокировать входящие соединения
	iptables -P INPUT DROP
	iptables -P FORWARD DROP
	iptables -P OUTPUT ACCEPT
	# Разрешаем локальные петли
	iptables -A INPUT -i lo -j ACCEPT
	# Разрешаем уже установленные и связанные подключения
	iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
	# Предотвращение bruteforce атак на ssh
	iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set --name SSH --rsource
	iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --ste --seconds 60 --hitcount 3 --name SSH --rsource -j DROP
	# SYN Flood защита
	iptables -N syn-flood
	iptables -A INPUT -p tcp --syn -j syn-flood
	iptables -A syn-flood -m limit --limit 10/s --limit-burst 20 -j RETURN
	iptables -A syn-flood -j LOG --log-prefix "SYN-flood: "
	iptables -A syn-flood -j DROP
	# Ping Flood защита
	iptables -A INPUT -p icmp -m limit --limit 1/s --limit-burst 1 -j ACCEPT
	iptables -A INPUT -p icmp -j DROP
	# UDP Flood защита
	iptables -N udp-flood
	iptables -A INPUT -p udp -j udp-flood
	iptables -A udp-flood -p udp -m limit --limit 50/s -j RETURN
	iptables -A udp-flood -j DROP
	# Connection Limit
	iptables -A INPUT -p tcp -m connlimit --connlimit-above 20 -j REJECT
	# Блокируем сканирование NULL пакетов
	iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
	# Блокируем Xmas пакеты (FIN, PSH and URG flags set)
	iptables -A INPUT -p tcp --tcp-flags FIN,PSH,URG FIN,PSH,URG -j DROP
	# Блокируем пакеты с установленными всеми флагами TCP
	iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
	# Защищаемся от фрагментации пакетов
	iptables -A INPUT -f -j DROP
	for i in {1..10}; do
        echo -n "[]"
        sleep 1 
	done
	sleep 1
	echo -e "\nФайрвол настроен!"
	clear
	sudo sh create_firewall.sh
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
