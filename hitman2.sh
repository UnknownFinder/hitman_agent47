#!/bin/bash
exec &> kill_list.log
# Поиск и уничтожение Zombie-процессов
zombies=$(ps aux | awk '$8 ~ /Z/ {print $2}')
if [ -n "$zombies" ]; then
    echo "Zombie processes found!"
    for zombie in $zombies; do
        echo "Killing process $zombie"
        kill -9 $zombie
    done
fi
# Поиск процессов, превышающих установленные пороги
max_cpu=80
max_ram=80
high_cpu_proc=$(top -bn1 | grep PID -A 20 | tail -n +2 | awk -v tresh="$max_cpu" '{if ($9+0 >= tresh) print $1}')
high_ram_proc=$(top -bn1 | grep PID -A 20 | tail -n +2 | awk -v tresh="$max_ram" '{if ($10+0 >= tresh) print $1}')
if [ -n "$high_cpu_proc" ] || [ -n "$high_ram_proc" ]; then
    echo "Warning! Overloading is detected."
    # Используем правильные имена переменных
    for pid in $high_cpu_proc $high_ram_proc; do
        echo "Changing priority for process $pid"
        renice 15 -p $pid
    done
else
    echo "Overloading is not detected."
fi
# Экстремальная нагрузка
ex_cpu=95
ex_mem=95
ex_cpu_proc=$(top -bn1 | grep PID -A 20 | tail -n +2 | awk -v tresh="$ex_cpu" '{if ($9+0 >= tresh) print $1}')
ex_mem_proc=$(top -bn1 | grep PID -A 20 | tail -n +2 | awk -v tresh="$ex_mem" '{if ($10+0 >= tresh) print $1}')
if [ -n "$ex_cpu_proc" ] || [ -n "$ex_mem_proc" ]; then
    echo "Warning! Extremely high load!"
    # Исправляем двойное использование переменной ex_cpu_proc
    for pid in $ex_cpu_proc $ex_mem_proc; do
        echo "Killing process $pid"
        kill -9 $pid
    done
fi
