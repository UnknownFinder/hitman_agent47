#!/bin/bash
exec &> kill_list.log
#Поиск и уничтожение zombie процессов
zombies=$(ps aux | awk '$8 ~ /Z/ {print $2}')
if [ -n "$zombies" ]; then
	echo "Zombie processes found!"
	for zombie in $zombies; do
		echo "Killing process $zombie"
		kill -9 $zombie
	done
fi
#Поиск процессов, превышающих установленные пороги
high_cpu_proc=$(top -bn1 | grep PID -A 20 | tail -n +2 | awk -v tresh=$cpu_max '{if ($9+0>=tresh){print $3}}')
high_ram_proc=$(top -bn1 | grep PID -A 20 | tail -n +2 | awk -v tresh=$ram_max '{if ($10+0>=tresh){print $3}}')
if [ -n "$cpu_max" ] || [ -n "$ram_max" ]; then
	echo "Warning! Overloading is detected."
	for pid in ${cpu_max[@]} ${ram_max[@]}; do
		echo "Changing priority for process $pid"
		renice 15 -p $pid
	done
else
	echo "Overloading is not detected."
fi
#Extremely high loading
ex_cpu=95
ex_mem=95
ex_cpu_proc=$(top -bn1 | grep PID -A 20 | tail -n +2 | awk -v tresh=$ex_cpu '{if ($9+0>=tresh){print $3}}')
ex_mem_proc=$(top -bn1 | grep PID -A 20 | tail -n +2 | awk -v tresh=$ex_mem '{if ($10+0>=ex_mem){print $3}}')
if [ -n "ex_cpu" ] || [ -n "$ex_mem" ]; then 
	echo "Warning! Extremelly high load!"
	for pid in ${ex_cpu[@]} ${ex_mem[@]}; do
		echo "Killing process $pid"
		kill -9 $pid
	done
fi
